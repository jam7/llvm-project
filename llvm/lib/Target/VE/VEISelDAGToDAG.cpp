//===-- VEISelDAGToDAG.cpp - A dag to dag inst selector for VE ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines an instruction selector for the VE target.
//
//===----------------------------------------------------------------------===//

#include "VETargetMachine.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

//===----------------------------------------------------------------------===//
//                      Pattern Matcher Implementation
//===----------------------------------------------------------------------===//

namespace {
  /// This corresponds to X86AddressMode, but uses SDValue's instead of register
  /// numbers for the leaves of the matched tree.
  struct VEISelAddressMode {
    enum {
      RegBase,
      FrameIndexBase
    } BaseType;

    // This is really a union, discriminated by BaseType!
    SDValue Base_Reg;
    int Base_FrameIndex;

    enum {
      RegIndex,
      ImmIndex
    } IndexType;

    SDValue IndexReg;
    int32_t IndexImm;

    int32_t Disp;
    const GlobalValue *GV;
    const Constant *CP;
    const BlockAddress *BlockAddr;
    const char *ES;
    MCSymbol *MCSym;
    int JT;
    unsigned Align;    // CP alignment.
    unsigned SymbolFlags;  // VEMCExpr::VK_*

    VEISelAddressMode()
        : BaseType(RegBase), Base_Reg(), Base_FrameIndex(0),
          IndexType(RegIndex), IndexReg(), IndexImm(0),
          Disp(0), GV(nullptr), CP(nullptr), BlockAddr(nullptr), ES(nullptr),
          MCSym(nullptr), JT(-1), Align(0), SymbolFlags(0) {}

    bool hasSymbolicDisplacement() const {
      return GV != nullptr || CP != nullptr || ES != nullptr ||
             MCSym != nullptr || JT != -1 || BlockAddr != nullptr;
    }

    bool hasBaseOrIndexReg() const {
      return BaseType == FrameIndexBase ||
             IndexReg.getNode() != nullptr || Base_Reg.getNode() != nullptr;
    }

    void setBaseReg(SDValue Reg) {
      BaseType = RegBase;
      Base_Reg = Reg;
    }

#if !defined(NDEBUG) || defined(LLVM_ENABLE_DUMP)
    void dump(SelectionDAG *DAG = nullptr) {
      dbgs() << "VEISelAddressMode " << this << '\n';
      dbgs() << "Base_Reg ";
      if (Base_Reg.getNode())
        Base_Reg.getNode()->dump(DAG);
      else
        dbgs() << "nul\n";
      if (BaseType == FrameIndexBase)
        dbgs() << " Base_FrameIndex " << Base_FrameIndex << '\n';
      dbgs() << "IndexReg ";
      if (IndexReg.getNode())
        IndexReg.getNode()->dump(DAG);
      else
        dbgs() << "nul\n";
      if (IndexType == ImmIndex)
        dbgs() << " ImmIndex " << IndexImm << '\n';
      dbgs() << " Disp " << Disp << '\n'
             << "GV ";
      if (GV)
        GV->dump();
      else
        dbgs() << "nul";
      dbgs() << " CP ";
      if (CP)
        CP->dump();
      else
        dbgs() << "nul";
      dbgs() << '\n'
             << "ES ";
      if (ES)
        dbgs() << ES;
      else
        dbgs() << "nul";
      dbgs() << " MCSym ";
      if (MCSym)
        dbgs() << MCSym;
      else
        dbgs() << "nul";
      dbgs() << " JT" << JT << " Align" << Align << '\n';
    }
#endif
  };
}

//===----------------------------------------------------------------------===//
// Instruction Selector Implementation
//===----------------------------------------------------------------------===//

//===--------------------------------------------------------------------===//
/// VEDAGToDAGISel - VE specific code to select VE machine
/// instructions for SelectionDAG operations.
///
namespace {
class VEDAGToDAGISel : public SelectionDAGISel {
  /// Subtarget - Keep a pointer to the VE Subtarget around so that we can
  /// make the right decision when generating code for different targets.
  const VESubtarget *Subtarget;

public:
  explicit VEDAGToDAGISel(VETargetMachine &tm) : SelectionDAGISel(tm) {}

  bool runOnMachineFunction(MachineFunction &MF) override {
    // Reset the subtarget each time through.
    Subtarget = &MF.getSubtarget<VESubtarget>();
    return SelectionDAGISel::runOnMachineFunction(MF);
  }

  void Select(SDNode *N) override;

  // Complex Pattern Selectors.
  bool SelectADDRrri(SDValue N, SDValue &Base, SDValue &Idx, SDValue &Offset);
  bool SelectADDRrii(SDValue N, SDValue &Base, SDValue &Idx, SDValue &Offset);
  bool SelectADDRzii(SDValue N, SDValue &Base, SDValue &Idx, SDValue &Offset);
  bool SelectADDRri(SDValue N, SDValue &Base, SDValue &Offset);
  bool SelectADDRzi(SDValue N, SDValue &Base, SDValue &Offset);

  /// SelectInlineAsmMemoryOperand - Implement addressing mode selection for
  /// inline asm expressions.
  bool SelectInlineAsmMemoryOperand(const SDValue &Op,
                                    unsigned ConstraintID,
                                    std::vector<SDValue> &OutOps) override;

  StringRef getPassName() const override {
    return "VE DAG->DAG Pattern Instruction Selection";
  }

  // Include the pieces autogenerated from the target description.
#include "VEGenDAGISel.inc"

private:
  SDNode *getGlobalBaseReg();
  bool tryInlineAsm(SDNode *N);

#if 0
  private:
    void Select(SDNode *N) override;

    bool foldOffsetIntoAddress(uint64_t Offset, X86ISelAddressMode &AM);
    bool matchLoadInAddress(LoadSDNode *N, X86ISelAddressMode &AM);
    bool matchWrapper(SDValue N, X86ISelAddressMode &AM);
    bool matchAddress(SDValue N, X86ISelAddressMode &AM);
    bool matchVectorAddress(SDValue N, X86ISelAddressMode &AM);
    bool matchAdd(SDValue &N, X86ISelAddressMode &AM, unsigned Depth);
    bool matchAddressRecursively(SDValue N, X86ISelAddressMode &AM,
                                 unsigned Depth);
    bool matchAddressBase(SDValue N, X86ISelAddressMode &AM);
#endif
};
} // end anonymous namespace

// Re-assemble i64 arguments split up in SelectionDAGBuilder's
// visitInlineAsm / GetRegistersForValue functions.
//
// Note: This function was copied from, and is essentially identical
// to ARMISelDAGToDAG::SelectInlineAsm. It is very unfortunate that
// such hacking-up is necessary; a rethink of how inline asm operands
// are handled may be in order to make doing this more sane.
//
// TODO: fix inline asm support so I can simply tell it that 'i64'
// inputs to asm need to be allocated to the IntPair register type,
// and have that work. Then, delete this function.
bool VEDAGToDAGISel::tryInlineAsm(SDNode *N){
  std::vector<SDValue> AsmNodeOperands;
  unsigned Flag, Kind;
  bool Changed = false;
  unsigned NumOps = N->getNumOperands();

  // Normally, i64 data is bounded to two arbitrary GPRs for "%r"
  // constraint.  However, some instructions (e.g. ldd/std) require
  // (even/even+1) GPRs.

  // So, here, we check for this case, and mutate the inlineasm to use
  // a single IntPair register instead, which guarantees such even/odd
  // placement.

  SDLoc dl(N);
  SDValue Glue = N->getGluedNode() ? N->getOperand(NumOps-1)
                                   : SDValue(nullptr,0);

  SmallVector<bool, 8> OpChanged;
  // Glue node will be appended late.
  for(unsigned i = 0, e = N->getGluedNode() ? NumOps - 1 : NumOps; i < e; ++i) {
    SDValue op = N->getOperand(i);
    AsmNodeOperands.push_back(op);

    if (i < InlineAsm::Op_FirstOperand)
      continue;

    if (ConstantSDNode *C = dyn_cast<ConstantSDNode>(N->getOperand(i))) {
      Flag = C->getZExtValue();
      Kind = InlineAsm::getKind(Flag);
    }
    else
      continue;

    // Immediate operands to inline asm in the SelectionDAG are modeled with
    // two operands. The first is a constant of value InlineAsm::Kind_Imm, and
    // the second is a constant with the value of the immediate. If we get here
    // and we have a Kind_Imm, skip the next operand, and continue.
    if (Kind == InlineAsm::Kind_Imm) {
      SDValue op = N->getOperand(++i);
      AsmNodeOperands.push_back(op);
      continue;
    }

    unsigned NumRegs = InlineAsm::getNumOperandRegisters(Flag);
    if (NumRegs)
      OpChanged.push_back(false);

    unsigned DefIdx = 0;
    bool IsTiedToChangedOp = false;
    // If it's a use that is tied with a previous def, it has no
    // reg class constraint.
    if (Changed && InlineAsm::isUseOperandTiedToDef(Flag, DefIdx))
      IsTiedToChangedOp = OpChanged[DefIdx];

    if (Kind != InlineAsm::Kind_RegUse && Kind != InlineAsm::Kind_RegDef
        && Kind != InlineAsm::Kind_RegDefEarlyClobber)
      continue;

    unsigned RC;
    bool HasRC = InlineAsm::hasRegClassConstraint(Flag, RC);
    if ((!IsTiedToChangedOp && (!HasRC || RC != VE::I64RegClassID))
        || NumRegs != 2)
      continue;

    // No IntPairRegister on VE
    continue;
#if 0
    assert((i+2 < NumOps) && "Invalid number of operands in inline asm");
    SDValue V0 = N->getOperand(i+1);
    SDValue V1 = N->getOperand(i+2);
    unsigned Reg0 = cast<RegisterSDNode>(V0)->getReg();
    unsigned Reg1 = cast<RegisterSDNode>(V1)->getReg();
    SDValue PairedReg;
    MachineRegisterInfo &MRI = MF->getRegInfo();

    if (Kind == InlineAsm::Kind_RegDef ||
        Kind == InlineAsm::Kind_RegDefEarlyClobber) {
      // Replace the two GPRs with 1 GPRPair and copy values from GPRPair to
      // the original GPRs.

      unsigned GPVR = MRI.createVirtualRegister(&SP::IntPairRegClass);
      PairedReg = CurDAG->getRegister(GPVR, MVT::v2i32);
      SDValue Chain = SDValue(N,0);

      SDNode *GU = N->getGluedUser();
      SDValue RegCopy = CurDAG->getCopyFromReg(Chain, dl, GPVR, MVT::v2i32,
                                               Chain.getValue(1));

      // Extract values from a GPRPair reg and copy to the original GPR reg.
      SDValue Sub0 = CurDAG->getTargetExtractSubreg(SP::sub_even, dl, MVT::i32,
                                                    RegCopy);
      SDValue Sub1 = CurDAG->getTargetExtractSubreg(SP::sub_odd, dl, MVT::i32,
                                                    RegCopy);
      SDValue T0 = CurDAG->getCopyToReg(Sub0, dl, Reg0, Sub0,
                                        RegCopy.getValue(1));
      SDValue T1 = CurDAG->getCopyToReg(Sub1, dl, Reg1, Sub1, T0.getValue(1));

      // Update the original glue user.
      std::vector<SDValue> Ops(GU->op_begin(), GU->op_end()-1);
      Ops.push_back(T1.getValue(1));
      CurDAG->UpdateNodeOperands(GU, Ops);
    }
    else {
      // For Kind  == InlineAsm::Kind_RegUse, we first copy two GPRs into a
      // GPRPair and then pass the GPRPair to the inline asm.
      SDValue Chain = AsmNodeOperands[InlineAsm::Op_InputChain];

      // As REG_SEQ doesn't take RegisterSDNode, we copy them first.
      SDValue T0 = CurDAG->getCopyFromReg(Chain, dl, Reg0, MVT::i32,
                                          Chain.getValue(1));
      SDValue T1 = CurDAG->getCopyFromReg(Chain, dl, Reg1, MVT::i32,
                                          T0.getValue(1));
      SDValue Pair = SDValue(
          CurDAG->getMachineNode(
              TargetOpcode::REG_SEQUENCE, dl, MVT::v2i32,
              {
                  CurDAG->getTargetConstant(SP::IntPairRegClassID, dl,
                                            MVT::i32),
                  T0,
                  CurDAG->getTargetConstant(SP::sub_even, dl, MVT::i32),
                  T1,
                  CurDAG->getTargetConstant(SP::sub_odd, dl, MVT::i32),
              }),
          0);

      // Copy REG_SEQ into a GPRPair-typed VR and replace the original two
      // i32 VRs of inline asm with it.
      unsigned GPVR = MRI.createVirtualRegister(&SP::IntPairRegClass);
      PairedReg = CurDAG->getRegister(GPVR, MVT::v2i32);
      Chain = CurDAG->getCopyToReg(T1, dl, GPVR, Pair, T1.getValue(1));

      AsmNodeOperands[InlineAsm::Op_InputChain] = Chain;
      Glue = Chain.getValue(1);
    }

    Changed = true;

    if(PairedReg.getNode()) {
      OpChanged[OpChanged.size() -1 ] = true;
      Flag = InlineAsm::getFlagWord(Kind, 1 /* RegNum*/);
      if (IsTiedToChangedOp)
        Flag = InlineAsm::getFlagWordForMatchingOp(Flag, DefIdx);
      else
        Flag = InlineAsm::getFlagWordForRegClass(Flag, SP::IntPairRegClassID);
      // Replace the current flag.
      AsmNodeOperands[AsmNodeOperands.size() -1] = CurDAG->getTargetConstant(
          Flag, dl, MVT::i32);
      // Add the new register node and skip the original two GPRs.
      AsmNodeOperands.push_back(PairedReg);
      // Skip the next two GPRs.
      i += 2;
    }
#endif
  }

  if (Glue.getNode())
    AsmNodeOperands.push_back(Glue);
  if (!Changed)
    return false;

  SDValue New = CurDAG->getNode(ISD::INLINEASM, SDLoc(N),
      CurDAG->getVTList(MVT::Other, MVT::Glue), AsmNodeOperands);
  New->setNodeId(-1);
  ReplaceNode(N, New.getNode());
  return true;
}

bool VEDAGToDAGISel::SelectADDRrri(SDValue Addr, SDValue &Base, SDValue &Idx,
                                   SDValue &Offset) {
  if (Addr.getOpcode() == ISD::FrameIndex)
    return false;
  if (Addr.getOpcode() == ISD::TargetExternalSymbol ||
      Addr.getOpcode() == ISD::TargetGlobalAddress ||
      Addr.getOpcode() == ISD::TargetGlobalTLSAddress)
    return false; // direct calls.

  if (Addr.getOpcode() == ISD::ADD) {
    if (ConstantSDNode *CN = dyn_cast<ConstantSDNode>(Addr.getOperand(1)))
      if (isInt<32>(CN->getSExtValue()))
        return false; // Let the reg+imm pattern catch this!
    if (Addr.getOperand(0).getOpcode() == VEISD::Lo ||
        Addr.getOperand(1).getOpcode() == VEISD::Lo)
      return false; // Let the reg+imm(=0) pattern catch this!
    Base = Addr.getOperand(0);
    Idx = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
    Offset = Addr.getOperand(1);
    return true;
#if 0
  } else if (Addr.getOpcode() == ISD::OR) {
    // We want to look through a transform in InstCombine and DAGCombiner that
    // turns 'add' into 'or', so we can treat this 'or' exactly like an 'add'.
    if (CurDAG->haveNoCommonBitsSet(Addr.getOperand(0), Addr.getOperand(1))) {
      if (ConstantSDNode *CN = dyn_cast<ConstantSDNode>(Addr.getOperand(1)))
        if (isInt<32>(CN->getSExtValue()))
          return false;  // Let the reg+imm pattern catch this!
      Base = Addr.getOperand(0);
      Idx = Addr.getOperand(1);
      Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
      return true;
    }
#endif
  }

  return false; // Let the reg+imm(=0) pattern catch this!
}

bool VEDAGToDAGISel::SelectADDRrii(SDValue Addr,
                                   SDValue &Base, SDValue &Index,
                                   SDValue &Offset) {
  auto AddrTy = Addr->getValueType(0);
  if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr)) {
    Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), AddrTy);
    Index = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
    Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
    return true;
  }
  if (Addr.getOpcode() == ISD::TargetExternalSymbol ||
      Addr.getOpcode() == ISD::TargetGlobalAddress ||
      Addr.getOpcode() == ISD::TargetGlobalTLSAddress)
    return false;  // direct calls.

  if (CurDAG->isBaseWithConstantOffset(Addr)) {
    ConstantSDNode *CN = cast<ConstantSDNode>(Addr.getOperand(1));
    if (isInt<32>(CN->getSExtValue())) {
      if (FrameIndexSDNode *FIN =
              dyn_cast<FrameIndexSDNode>(Addr.getOperand(0))) {
        // Constant offset from frame ref.
        Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), AddrTy);
      } else {
        Base = Addr.getOperand(0);
      }
      Index = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
      Offset =
          CurDAG->getTargetConstant(CN->getZExtValue(), SDLoc(Addr), MVT::i32);
      return true;
    }
  }
  Base = Addr;
  Index = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
  Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
  return true;
}

bool VEDAGToDAGISel::SelectADDRzii(SDValue Addr,
                                   SDValue &Base, SDValue &Index,
                                   SDValue &Offset) {
  if (dyn_cast<FrameIndexSDNode>(Addr)) {
    return false;
  }
  if (Addr.getOpcode() == ISD::TargetExternalSymbol ||
      Addr.getOpcode() == ISD::TargetGlobalAddress ||
      Addr.getOpcode() == ISD::TargetGlobalTLSAddress)
    return false;  // direct calls.

  if (ConstantSDNode *CN = cast<ConstantSDNode>(Addr)) {
    if (isInt<32>(CN->getSExtValue())) {
      Base = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
      Index = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
      Offset =
          CurDAG->getTargetConstant(CN->getZExtValue(), SDLoc(Addr), MVT::i32);
      return true;
    }
  }
  return false;
}

bool VEDAGToDAGISel::SelectADDRri(SDValue Addr, SDValue &Base,
                                  SDValue &Offset) {
  auto AddrTy = Addr->getValueType(0);
  if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr)) {
    Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), AddrTy);
    Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
    return true;
  }
  if (Addr.getOpcode() == ISD::TargetExternalSymbol ||
      Addr.getOpcode() == ISD::TargetGlobalAddress ||
      Addr.getOpcode() == ISD::TargetGlobalTLSAddress)
    return false; // direct calls.

  if (CurDAG->isBaseWithConstantOffset(Addr)) {
    ConstantSDNode *CN = cast<ConstantSDNode>(Addr.getOperand(1));
    if (isInt<32>(CN->getSExtValue())) {
      if (FrameIndexSDNode *FIN =
              dyn_cast<FrameIndexSDNode>(Addr.getOperand(0))) {
        // Constant offset from frame ref.
        Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), AddrTy);
      } else {
        Base = Addr.getOperand(0);
      }
      Offset =
          CurDAG->getTargetConstant(CN->getZExtValue(), SDLoc(Addr), MVT::i32);
      return true;
    }
  }
  Base = Addr;
  Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
  return true;
}

bool VEDAGToDAGISel::SelectADDRzi(SDValue Addr, SDValue &Base,
                                  SDValue &Offset) {
  if (dyn_cast<FrameIndexSDNode>(Addr)) {
    return false;
  }
  if (Addr.getOpcode() == ISD::TargetExternalSymbol ||
      Addr.getOpcode() == ISD::TargetGlobalAddress ||
      Addr.getOpcode() == ISD::TargetGlobalTLSAddress)
    return false;  // direct calls.

  if (ConstantSDNode *CN = cast<ConstantSDNode>(Addr)) {
    if (isInt<32>(CN->getSExtValue())) {
      Base = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
      Offset =
          CurDAG->getTargetConstant(CN->getZExtValue(), SDLoc(Addr), MVT::i32);
      return true;
    }
  }
  return false;
}

void VEDAGToDAGISel::Select(SDNode *N) {
  SDLoc dl(N);
  if (N->isMachineOpcode()) {
    N->setNodeId(-1);
    return; // Already selected.
  }

  switch (N->getOpcode()) {
  default:
    break;
  case VEISD::GLOBAL_BASE_REG:
    ReplaceNode(N, getGlobalBaseReg());
    return;
  case ISD::INLINEASM: {
    if (tryInlineAsm(N))
      return;
    break;
  }
#if 0
  case ISD::SDIV:
  case ISD::UDIV: {
    // sdivx / udivx handle 64-bit divides.
    if (N->getValueType(0) == MVT::i64)
      break;
    // FIXME: should use a custom expander to expose the SRA to the dag.
    SDValue DivLHS = N->getOperand(0);
    SDValue DivRHS = N->getOperand(1);

    // Set the Y register to the high-part.
    SDValue TopPart;
    if (N->getOpcode() == ISD::SDIV) {
      TopPart = SDValue(CurDAG->getMachineNode(SP::SRAri, dl, MVT::i32, DivLHS,
                                   CurDAG->getTargetConstant(31, dl, MVT::i32)),
                        0);
    } else {
      TopPart = CurDAG->getRegister(SP::G0, MVT::i32);
    }
    TopPart = CurDAG->getCopyToReg(CurDAG->getEntryNode(), dl, SP::Y, TopPart,
                                   SDValue())
                  .getValue(1);

    // FIXME: Handle div by immediate.
    unsigned Opcode = N->getOpcode() == ISD::SDIV ? SP::SDIVrr : SP::UDIVrr;
    // SDIV is a hardware erratum on some LEON2 processors. Replace it with SDIVcc here.
    if (((VETargetMachine&)TM).getSubtargetImpl()->performSDIVReplace()
        &&
        Opcode == SP::SDIVrr) {
      Opcode = SP::SDIVCCrr;
    }
    CurDAG->SelectNodeTo(N, Opcode, MVT::i32, DivLHS, DivRHS, TopPart);
    return;
  }
#endif
  }

  SelectCode(N);
}

/// SelectInlineAsmMemoryOperand - Implement addressing mode selection for
/// inline asm expressions.
bool
VEDAGToDAGISel::SelectInlineAsmMemoryOperand(const SDValue &Op,
                                                unsigned ConstraintID,
                                                std::vector<SDValue> &OutOps) {
  SDValue Op0, Op1, Op2;
  switch (ConstraintID) {
  default: return true;
  case InlineAsm::Constraint_i:
  case InlineAsm::Constraint_o:
  case InlineAsm::Constraint_m: // memory
    if (!SelectADDRrri(Op, Op0, Op1, Op2))
      if (!SelectADDRrii(Op, Op0, Op1, Op2))
        if (SelectADDRri(Op, Op0, Op1)) {
          OutOps.push_back(Op0);
          OutOps.push_back(Op1);
          return false;
        }
    break;
  }

  OutOps.push_back(Op0);
  OutOps.push_back(Op1);
  OutOps.push_back(Op2);
  return false;
}

SDNode *VEDAGToDAGISel::getGlobalBaseReg() {
  Register GlobalBaseReg = Subtarget->getInstrInfo()->getGlobalBaseReg(MF);
  return CurDAG
      ->getRegister(GlobalBaseReg, TLI->getPointerTy(CurDAG->getDataLayout()))
      .getNode();
}

/// createVEISelDag - This pass converts a legalized DAG into a
/// VE-specific DAG, ready for instruction scheduling.
///
FunctionPass *llvm::createVEISelDag(VETargetMachine &TM) {
  return new VEDAGToDAGISel(TM);
}
