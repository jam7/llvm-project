//===- VE.cpp -------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "InputFiles.h"
#include "Symbols.h"
#include "SyntheticSections.h"
#include "Target.h"
#include "lld/Common/ErrorHandler.h"
#include "llvm/Support/Endian.h"

using namespace llvm;
using namespace llvm::support::endian;
using namespace llvm::ELF;
using namespace lld;
using namespace lld::elf;

namespace {
class VE final : public TargetInfo {
public:
  VE();
  RelExpr getRelExpr(RelType type, const Symbol &s,
                     const uint8_t *loc) const override;
  void writePlt(uint8_t *buf, const Symbol &sym,
                uint64_t pltEntryAddr) const override;
  void relocate(uint8_t *loc, const Relocation &rel,
                uint64_t val) const override;
};
} // namespace

VE::VE() {
  copyRel = R_VE_COPY; // not sure how this works.
  gotRel = R_VE_GLOB_DAT;
  noneRel = R_VE_NONE;
  pltRel = R_VE_JUMP_SLOT;
  relativeRel = R_VE_RELATIVE;
  // iRelativeRel = R_RISCV_IRELATIVE;  // no irelative on VE
  symbolicRel = R_VE_REFQUAD;
  // tlsDescRel; // no DESCREL
  // tlsGotRel = R_VE_TLS_TPREL64;
  tlsModuleIndexRel = R_VE_DTPMOD64;
  tlsOffsetRel = R_VE_DTPOFF64;

  pltEntrySize = 32;
  pltHeaderSize = 4 * pltEntrySize;

  defaultCommonPageSize = 8192;
  defaultMaxPageSize = 0x100000;
  defaultImageBase = 0x100000;
}

RelExpr VE::getRelExpr(RelType type, const Symbol &s,
                            const uint8_t *loc) const {
  switch (type) {
  case R_VE_NONE:
    return R_NONE;
  case R_VE_REFLONG:
  case R_VE_REFQUAD:
    return R_ABS;
  case R_VE_SREL32:
    return R_PC;
  case R_VE_HI32:
  case R_VE_LO32:
    return R_ABS;
  case R_VE_PC_HI32:
  case R_VE_PC_LO32:
    return R_PC;
  case R_VE_GOT32:
  case R_VE_GOT_HI32:
  case R_VE_GOT_LO32:
    return R_GOT_PC;
  case R_VE_GOTOFF32:
  case R_VE_GOTOFF_HI32:
  case R_VE_GOTOFF_LO32:
    return R_GOT_OFF;
  case R_VE_PLT32:
  case R_VE_PLT_HI32:
  case R_VE_PLT_LO32:
    return R_PLT_PC;
  case R_VE_TLS_GD_HI32:
  case R_VE_TLS_GD_LO32:
  case R_VE_TPOFF_HI32:
  case R_VE_TPOFF_LO32:
    return R_TLS;
  case R_VE_CALL_HI32:
  case R_VE_CALL_LO32:
    return R_ABS;
  default:
    error(getErrorLocation(loc) + "unknown relocation (" + Twine(type) +
          ") against symbol " + toString(s));
    return R_NONE;
  }
}

void VE::relocate(uint8_t *loc, const Relocation &rel,
                       uint64_t val) const {
  switch (rel.type) {
  case R_VE_REFLONG:
    // 32 bits
    checkUInt(loc, val, 32, rel);
    write32le(loc, val);
    break;
  case R_VE_REFQUAD:
    // 64 bits
    write64le(loc, val);
    break;
  case R_VE_SREL32:
  case R_VE_GOT32:
  case R_VE_GOTOFF32:
  case R_VE_PLT32:
    // 32 bits
    checkUInt(loc, val, 32, rel);
    write32le(loc, val);
    break;
  case R_VE_HI32:
  case R_VE_PC_HI32:
  case R_VE_GOT_HI32:
  case R_VE_GOTOFF_HI32:
  case R_VE_PLT_HI32:
  case R_VE_TLS_GD_HI32:
  case R_VE_TPOFF_HI32:
  case R_VE_CALL_HI32:
    // high 32 bits
    write32le(loc, ((val >> 32) & 0xffffffff));
    break;
  case R_VE_LO32:
  case R_VE_PC_LO32:
  case R_VE_GOT_LO32:
  case R_VE_GOTOFF_LO32:
  case R_VE_PLT_LO32:
  case R_VE_TLS_GD_LO32:
  case R_VE_TPOFF_LO32:
  case R_VE_CALL_LO32:
    // low 32 bits
    write32le(loc, (val & 0xffffffff));
    break;
  default:
    llvm_unreachable("unknown relocation");
  }
}

void VE::writePlt(uint8_t *buf, const Symbol & /*sym*/,
                       uint64_t pltEntryAddr) const {
  const uint8_t pltData[] = {
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79, // nop
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79, // nop
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79, // nop
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79, // nop
  };
  memcpy(buf, pltData, sizeof(pltData));

#if 0
  uint64_t off = pltEntryAddr - in.plt->getVA();
  relocateNoSym(buf, R_SPARC_22, off);
  relocateNoSym(buf + 4, R_SPARC_WDISP19, -(off + 4 - pltEntrySize));
#endif
}

TargetInfo *elf::getVETargetInfo() {
  static VE target;
  return &target;
}
