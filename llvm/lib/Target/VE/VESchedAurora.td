//=- VEScheduleAurora.td - NEC SX-Aurora Scheduling Defs -----*- tablegen -*-=//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the machine model for NEC SX-Aurora to support
// instruction scheduling and other instruction cost heuristics.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//

def AuroraModel : SchedMachineModel {
  let IssueWidth        = 4;  // 4-way decode and dispatch
  let MicroOpBufferSize = 0;  // 128 micro-op re-order buffer
  let LoadLatency       = 3;  // Optimistic load latency
  let MispredictPenalty = 12; // Fetch + Decode/Rename/Dispatch + Branch

  // Enable partial & runtime unrolling. The magic number is chosen based on
  // experiments and benchmarking data.
  let LoopMicroOpBufferSize = 16;
  let CompleteModel = 0;  // developing atm.  FIXME: need to set 1 at release.
}

//===----------------------------------------------------------------------===//
// Define each kind of processor resource and number available on Aurora VE.
// Aurora VE has 11 pipelines that each has its own ???-entry queue where
// micro-ops wait for their operands and then issue out-of-order.

def AuroraUnitALU : ProcResource<2>;
def AuroraUnitFPALU : ProcResource<2>;
def AuroraUnitVEC : ProcResource<3>;
def AuroraUnitMEMC : ProcResource<1>;
def AuroraUnitDIV : ProcResource<1>;
def AuroraUnitQUAD : ProcResource<1>;
def AuroraUnitBR : ProcResource<1>;

let SchedModel = AuroraModel in {

//===----------------------------------------------------------------------===//
// Define customized scheduler read/write types specific to the Cortex-A57.

include "VESchedAuroraWriteRes.td"

//===----------------------------------------------------------------------===//
// Map the target-defined scheduler read/write resources and latency for
// Aurora VE. The Aurora VE types are directly associated with resources, so
// defining the aliases precludes the need for mapping them using WriteRes. The
// aliases are sufficient for creating a coarse, working model. As the model
// evolves, InstRWs will be used to override some of these SchedAliases.
//
// WARNING: Using SchedAliases is convenient and works well for latency and
//          resource lookup for instructions. However, this creates an entry in
//          AArch64WriteLatencyTable with a WriteResourceID of 0, breaking
//          any SchedReadAdvance since the lookup will fail.

/*
def : SchedAlias<WriteALU, AuroraWriteALU>;
def : SchedAlias<WriteMUL, AuroraWriteMUL>;
def : SchedAlias<WriteDIV32, AuroraWriteDIV32>;
def : SchedAlias<WriteDIV64, AuroraWriteDIV64>;

def : SchedAlias<WriteLD, AuroraWriteLD>;
def : SchedAlias<WriteST, AuroraWriteST>;
def : SchedAlias<WriteBR, AuroraWriteBR>;
def : SchedAlias<WriteNOP, AuroraWriteNOP>;

def : SchedAlias<WriteFPALU, AuroraWriteFPALU>;
def : SchedAlias<WriteFPALU128, AuroraWriteFPALU128>;
def : SchedAlias<WriteFPDIV32, AuroraWriteFPDIV32>;
def : SchedAlias<WriteFPDIV64, AuroraWriteFPDIV64>;

def : SchedAlias<WriteVLD, AuroraWriteVLD>;
def : SchedAlias<WriteVST, AuroraWriteVST>;
*/

// Forwarding logic is not implemented at the moment.
// HW may have some...
def : ReadAdvance<ReadALU, 0>;

//===----------------------------------------------------------------------===//
// Specialize the coarse model by associating instruction groups with the
// subtarget-defined types. As the modeled is refined, this will override most
// of the above ShchedAlias mappings.

def : InstRW<[AuroraWriteALU], (instregex "^(LEA|ADD|SUB|CMP|MAX|MIN|AND|OR|XOR|EQV|NND|LDZ|BRV|BSWP|SLL|SRL|SLA|SRA)")>;
def : InstRW<[AuroraWriteCMOV], (instregex "^(MRG|CMOV|SLD|SRD)")>;
def : InstRW<[AuroraWriteMUL], (instregex "^(MUL)")>;
def : InstRW<[AuroraWriteDIV32], (instregex "^(DIVUW|DIVSW)")>;
def : InstRW<[AuroraWriteDIV64], (instregex "^(DIVUL|DIVSL)")>;

def : InstRW<[AuroraWriteLD], (instregex "^(LD[^Z]|DLD|TS1AM|TS2AM|TS3AM|ATMAM|CAS|FENCE|SVOB)")>;
def : InstRW<[AuroraWriteST], (instregex "^(ST)")>;
def : InstRW<[AuroraWriteBR], (instregex "^(BC|BRCF|RET|BSIC|CALL)")>;
def : InstRW<[AuroraWriteCNT], (instregex "^(STC|LPM|SPM|LFR|SFR|SMIR|MONC|LCR|SCR|TSCR|FIDCR|LHM|SHM)")>;
def : InstRW<[AuroraWriteNOP], (instregex "^(NOP)")>;

def : InstRW<[AuroraWriteFPALU], (instregex "^(FADD[DS]|FSUB[DS]|FMUL[DS]|FCMP[DS]|FMAX|FMIN|CVT|PCNT)")>;
def : InstRW<[AuroraWriteFPALU128], (instregex "^(FADDQ|FSUBQ|FMULQ|FCMPQ)")>;
def : InstRW<[AuroraWriteFPDIV32], (instregex "^(FDIVS)")>;
def : InstRW<[AuroraWriteFPDIV64], (instregex "^(FDIVD)")>;

} // SchedModel = AuroraModel
