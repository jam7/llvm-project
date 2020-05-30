//===-- VESubtarget.cpp - VE Subtarget Information ------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements the VE specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#include "VESubtarget.h"
#include "VE.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "ve-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "VEGenSubtargetInfo.inc"

void VESubtarget::anchor() {}

VESubtarget &VESubtarget::initializeSubtargetDependencies(StringRef CPU,
                                                          StringRef FS) {
  // Determine default and user specified characteristics
  if (CPU.empty())
    CPU = "aurora";

  // Parse features string.
  ParseSubtargetFeatures(CPU, FS);
  initializeProperties();

  return *this;
}

void VESubtarget::initializeProperties() {
  // Initialize CPU specific properties. We should add a tablegen feature for
  // this in the future so we can specify it together with the subtarget
  // features.
  switch (NECProcFamily) {
  case Others:
    break;
  case Aurora:
    PrefFunctionLogAlignment = 3;
    CacheLineSize = 128;
#if 0
    PrefetchDistance = 280;
    MinPrefetchStride = 2048;
    MaxPrefetchIterationsAhead = 3;
#endif
    break;
  }
}

VESubtarget::VESubtarget(const Triple &TT, const std::string &CPU,
                         const std::string &FS, const TargetMachine &TM)
    : VEGenSubtargetInfo(TT, CPU, FS), TargetTriple(TT),
      InstrInfo(initializeSubtargetDependencies(CPU, FS)), TLInfo(TM, *this),
      FrameLowering(*this) {}

uint64_t VESubtarget::getAdjustedFrameSize(uint64_t frameSize) const {

  // VE stack frame:
  //
  //         +----------------------------------------+
  //         | Locals and temporaries                 |
  //         +----------------------------------------+
  //         | Parameter area for callee              |
  // 176(fp) |                                        |
  //         +----------------------------------------+
  //         | Register save area (RSA) for callee    |
  //         |                                        |
  //  16(fp) |                         20 * 8 bytes   |
  //         +----------------------------------------+
  //   8(fp) | Return address                         |
  //         +----------------------------------------+
  //   0(fp) | Frame pointer of caller                |
  // --------+----------------------------------------+--------
  //         | Locals and temporaries for callee      |
  //         +----------------------------------------+
  //         | Parameter area for callee of callee    |
  //         +----------------------------------------+
  //  16(sp) | RSA for callee of callee               |
  //         +----------------------------------------+
  //   8(sp) | Return address                         |
  //         +----------------------------------------+
  //   0(sp) | Frame pointer of callee                |
  //         +----------------------------------------+

  // RSA frame:
  //         +----------------------------------------------+
  // 168(fp) | %s33                                         |
  //         +----------------------------------------------+
  //         | %s19...%s32                                  |
  //         +----------------------------------------------+
  //  48(fp) | %s18                                         |
  //         +----------------------------------------------+
  //  40(fp) | Linkage area register (%s17)                 |
  //         +----------------------------------------------+
  //  32(fp) | Procedure linkage table register (%plt=%s16) |
  //         +----------------------------------------------+
  //  24(fp) | Global offset table register (%got=%s15)     |
  //         +----------------------------------------------+
  //  16(fp) | Thread pointer register (%tp=%s14)           |
  //         +----------------------------------------------+

  frameSize += 176;                     // for RSA, RA, and FP

  return frameSize;
}

bool VESubtarget::enableMachineScheduler() const { return true; }
