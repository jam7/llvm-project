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

def AuroraModel : SchedMachineModel {
  let IssueWidth        = 4;   // 4-way decode and dispatch.
  let LoadLatency       = 3;   // Optimistic load latency.
  let MispredictPenalty = 12;  // Assumes best-case based on ALU.
  let HighLatency       = 10;

  // Just a guess atm.
  let MicroOpBufferSize = 192; // Guess

  // Enable partial & runtime unrolling. The magic number is chosen based on
  // experiments and benchmarking data.
  let LoopMicroOpBufferSize = 16;

  // FIXME: This variable is required for incomplete model.
  // We haven't catered all instructions.
  // So, we reset the value of this variable so as to
  // say that the model is incomplete.
  let CompleteModel = 0;
}

let SchedModel = AuroraModel in {

//===----------------------------------------------------------------------===//
// Define each kind of processor resource and number available on Aurora VE.
// Aurora VE has 13 resource units.

def AuroraUnitALU : ProcResource<2>;
def AuroraUnitFPALU : ProcResource<2>;
def AuroraUnitVEC : ProcResource<3>;

def AuroraUnitMEMC : ProcResource<1>;
def AuroraUnitDIV : ProcResource<1>;
def AuroraUnitCMOV : ProcResource<1>;
def AuroraUnitQUAD0 : ProcResource<1>;
def AuroraUnitQUAD1 : ProcResource<1>;

def AuroraUnitBR : ProcResource<1>;

//===----------------------------------------------------------------------===//
// Define each pipeline and OOO buffer size on Aurora VE.  Aurora VE has totally
// 4 ALU, 2 for integer and 2 for floating point.  However, Aurora VE can issue
// only 2 ALU instructions in one cycle.  To represent this limitaion, we use
// AuroraPipeALU, e.g. "WriteRes<WriteALU, [AuroraPipeALU, AuroraUnitALU]>" to
// limit the combination of both ALU to 2.

def AuroraPipeALU : ProcResource<2>;
def AuroraPipe0 : ProcResGroup<[AuroraPipeALU, AuroraUnitALU,
                                AuroraUnitFPALU]> {
  let BufferSize=2;
}

def AuroraPipe1 : ProcResGroup<[AuroraPipeALU, AuroraUnitALU, AuroraUnitFPALU,
                                AuroraUnitVEC]> {
  let BufferSize=2;
}

def AuroraPipe2 : ProcResGroup<[AuroraUnitMEMC, AuroraUnitDIV, AuroraUnitCMOV,
                                AuroraUnitQUAD0, AuroraUnitQUAD1]> {
  let BufferSize=2;
}

def AuroraPipe3 : ProcResGroup<[AuroraUnitBR]> {
  let BufferSize=2;
}

/*
// The Zen FP Retire Queue renames SIMD and FP uOps onto a pool of 160 128-bit
// registers. Operations on 256-bit data types are cracked into two COPs.
// Reference: "Software Optimization Guide for AMD Family 17h Processors"
def AuroraFpuPRF: RegisterFile<160, [VR64, VR128, VR256], [1, 1, 2]>;
*/

// The unit can track up to 192(??? not checked) macro ops in-flight.
// The retire unit handles in-order commit of up to 3 macro ops per cycle.
def AuroraRCU : RetireControlUnit<192, 3>;

//===----------------------------------------------------------------------===//
// Define customized scheduler read/write types specific to the Cortex-A57.

defm : VEWriteRes<WriteALU, [AuroraPipeALU, AuroraUnitALU], 1, [1, 1], 1>;
defm : VEWriteRes<WriteMUL, [AuroraPipeALU, AuroraUnitALU], 3, [1, 3], 1>;

defm : VEWriteRes<WriteDIV32, [AuroraPipe2, AuroraUnitDIV], 16, [1, 16], 1>;
defm : VEWriteRes<WriteDIV64, [AuroraPipe2, AuroraUnitDIV], 27, [1, 27], 1>;

defm : VEWriteRes<WriteCMOV, [AuroraPipe2, AuroraUnitCMOV], 3, [1, 3], 1>;
defm : VEWriteRes<WriteLD, [AuroraPipe2, AuroraUnitMEMC], 3, [1, 3], 1>;
defm : VEWriteRes<WriteST, [AuroraPipe2, AuroraUnitMEMC], 1, [1, 1], 1>;
defm : VEWriteRes<WriteCNT, [AuroraPipe2, AuroraUnitMEMC], 1, [1, 1], 1>;

defm : VEWriteRes<WriteBR, [AuroraPipe3, AuroraUnitBR], 1, [1, 1], 1>;

defm : VEWriteRes<WriteNOP, [], 0, [], 0>;

defm : VEWriteRes<WriteFPALU, [AuroraPipeALU, AuroraUnitFPALU], 3, [1, 3], 1>;
defm : VEWriteRes<WriteFPALU128, [AuroraPipe2, AuroraUnitQUAD0], 12, [1, 12],
                  1>;
defm : VEWriteRes<WriteFPMUL128, [AuroraPipe2, AuroraUnitQUAD1], 12, [1, 12],
                  1>;
defm : VEWriteRes<WriteFPDIV32, [AuroraPipe2, AuroraUnitDIV], 14, [1, 14], 1>;
defm : VEWriteRes<WriteFPDIV64, [AuroraPipe2, AuroraUnitDIV], 24, [1, 24], 1>;

// FIXME: Use SchedWriteVariant to determine the latency depend on the
//        vector length
defm : VEWriteRes<WriteVLD, [AuroraPipe1, AuroraUnitVEC], 18, [1, 18], 1>;
defm : VEWriteRes<WriteVST, [AuroraPipe1, AuroraUnitVEC], 16, [1, 16], 1>;
defm : VEWriteRes<WriteVEC7, [AuroraPipe1, AuroraUnitVEC], 3, [1, 3], 1>;

// Forwarding logic is not implemented at the moment.
// HW may have some...
def : ReadAdvance<ReadALU, 0>;

//===----------------------------------------------------------------------===//
// Specialize the coarse model by associating instruction groups with the
// subtarget-defined types. As the modeled is refined, this will override most
// of the above ShchedAlias mappings.

def : InstRW<[WriteALU], (instregex "^(LEA|ADD|SUB|CMP|MAX|MIN|AND|OR|XOR|EQV|NND|LDZ|BRV|BSWP|SLL|SRL|SLA|SRA)")>;
def : InstRW<[WriteCMOV], (instregex "^(MRG|CMOV|SLD|SRD)")>;
def : InstRW<[WriteMUL], (instregex "^(MUL)")>;
def : InstRW<[WriteDIV32], (instregex "^(DIVUW|DIVSW)")>;
def : InstRW<[WriteDIV64], (instregex "^(DIVUL|DIVSL)")>;

def : InstRW<[WriteLD], (instregex "^(LD[^Z]|DLD|TS1AM|TS2AM|TS3AM|ATMAM|CAS|FENCE|SVOB)")>;
def : InstRW<[WriteST], (instregex "^(ST)")>;
def : InstRW<[WriteBR], (instregex "^(BC|BRCF|RET|BSIC|CALL)")>;
def : InstRW<[WriteCNT], (instregex "^(STC|LPM|SPM|LFR|SFR|SMIR|MONC|LCR|SCR|TSCR|FIDCR|LHM|SHM)")>;
def : InstRW<[WriteNOP], (instregex "^(NOP)")>;

def : InstRW<[WriteFPALU], (instregex "^(FADD[DS]|FSUB[DS]|FMUL[DS]|FCMP[DS]|FMAX|FMIN|CVT|PCNT)")>;
def : InstRW<[WriteFPALU128], (instregex "^(FADDQ|FSUBQ|FMULQ|FCMPQ)")>;
def : InstRW<[WriteFPDIV32], (instregex "^(FDIVS)")>;
def : InstRW<[WriteFPDIV64], (instregex "^(FDIVD)")>;

def : InstRW<[WriteVEC7], (instregex "^(lvm)")>;

} // SchedModel = AuroraModel
