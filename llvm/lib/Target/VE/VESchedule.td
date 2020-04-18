//===-- VESchedule.td - VE Scheduling Definitions ----------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Sched definitions for integer pipeline instructions
//
// Basic ALU operation.
def WriteALU : SchedWrite;
def ReadALU : SchedRead;

// Multiplys.
def WriteMUL : SchedWrite;

// Divisions.
def WriteDIV32 : SchedWrite;
def WriteDIV64 : SchedWrite;

// Loads/Stores.
def WriteLD : SchedWrite;
def WriteST : SchedWrite;

// Branches.
def WriteBR : SchedWrite;

// CMOV and Controll.
def WriteCMOV : SchedWrite;
def WriteCNT : SchedWrite;

// Noop.
def WriteNOP : SchedWrite;

//===----------------------------------------------------------------------===//
// Sched definitions for floating-point and neon instructions
//
// ALU operations.
def WriteFPALU : SchedWrite;
def WriteFPALU128 : SchedWrite;
def WriteFPMUL128 : SchedWrite;

// Division
def WriteFPDIV32 : SchedWrite;
def WriteFPDIV64 : SchedWrite;

// Vector load and stores
def WriteVLD : SchedWrite;
def WriteVST : SchedWrite;
def WriteVEC7 : SchedWrite;

// Helper to set SchedWrite ExePorts/Latency/ResourceCycles/NumMicroOps.
multiclass VEWriteRes<SchedWrite SchedRW,
                      list<ProcResourceKind> ExePorts,
                      int Lat, list<int> Res, int UOps> {
  def : WriteRes<SchedRW, ExePorts> {
    let Latency = Lat;
    let ResourceCycles = Res;
    let NumMicroOps = UOps;
  }
}

// Define TII for use in SchedVariant Predicates.
def : PredicateProlog<[{
  const VEInstrInfo *TII =
    static_cast<const VEInstrInfo*>(SchedModel->getInstrInfo());
  (void)TII;
  const VESubtarget *STI =
    static_cast<const VESubtarget*>(SchedModel->getSubtargetInfo());
  (void)STI;
}]>;

def IsPredicatedPred : SchedPredicate<[{TII->isPredicated(*MI)}]>;

//===----------------------------------------------------------------------===//
// Processor instruction itineraries.

include "VEScheduleAurora.td"
