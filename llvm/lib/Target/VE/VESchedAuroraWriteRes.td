//=- VESchedAuroraWriteRes.td - NEC SX-Aurora Write Res ------*- tablegen -*-=//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Contains all of the Aurora specific SchedWriteRes types. The approach
// below is to define a generic SchedWriteRes for every combination of
// latency.
//
//===----------------------------------------------------------------------===//

// def : WriteRes<WriteALU, [AuroraUnitALU]> { let Latency = 1;  }

def AuroraWriteALU : SchedWriteRes<[AuroraUnitALU]> { let Latency = 1;  }
def AuroraWriteMUL : SchedWriteRes<[AuroraUnitALU]> { let Latency = 3;  }
def AuroraWriteDIV32 : SchedWriteRes<[AuroraUnitDIV]> { let Latency = 16; }
def AuroraWriteDIV64 : SchedWriteRes<[AuroraUnitDIV]> { let Latency = 27; }

def AuroraWriteCMOV : SchedWriteRes<[AuroraUnitMEMC]> { let Latency = 3; }
def AuroraWriteLD : SchedWriteRes<[AuroraUnitMEMC]> { let Latency = 3; }
def AuroraWriteST : SchedWriteRes<[AuroraUnitMEMC]> { let Latency = 1; }
def AuroraWriteBR : SchedWriteRes<[AuroraUnitBR]> { let Latency = 1; }
def AuroraWriteCNT : SchedWriteRes<[AuroraUnitMEMC]> { let Latency = 1; }

// def AuroraWriteNOP : SchedWriteRes<[AuroraUnitALU]> { let Latency = 0; let NumMicroOps = 0; }
def AuroraWriteNOP : SchedWriteRes<[AuroraUnitALU]> { let Latency = 0; }

def AuroraWriteFPALU : SchedWriteRes<[AuroraUnitFPALU]> { let Latency = 3; }
def AuroraWriteFPALU128 : SchedWriteRes<[AuroraUnitQUAD]> { let Latency = 12; }
def AuroraWriteFPDIV32 : SchedWriteRes<[AuroraUnitDIV]> { let Latency = 14; }
def AuroraWriteFPDIV64 : SchedWriteRes<[AuroraUnitDIV]> { let Latency = 24; }

// FIXME: Use SchedWriteVariant to determine the latency depend on the
//        vector length
def AuroraWriteVLD : SchedWriteRes<[AuroraUnitVEC]> { let Latency = 18; }
def AuroraWriteVST : SchedWriteRes<[AuroraUnitVEC]> { let Latency = 16; }
