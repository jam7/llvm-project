//===- WriterUtils.cpp ----------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WriterUtils.h"
#include "lld/Common/ErrorHandler.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/EndianStream.h"
#include "llvm/Support/LEB128.h"

#define DEBUG_TYPE "lld"

using namespace llvm;
using namespace llvm::wasm;

namespace lld {
std::string toString(ValType type) {
  switch (type) {
  case ValType::I32:
    return "i32";
  case ValType::I64:
    return "i64";
  case ValType::F32:
    return "f32";
  case ValType::F64:
    return "f64";
  case ValType::V128:
    return "v128";
  case ValType::EXNREF:
    return "exnref";
  case ValType::EXTERNREF:
    return "externref";
  }
  llvm_unreachable("Invalid wasm::ValType");
}

std::string toString(const WasmSignature &sig) {
  SmallString<128> s("(");
  for (ValType type : sig.Params) {
    if (s.size() != 1)
      s += ", ";
    s += toString(type);
  }
  s += ") -> ";
  if (sig.Returns.empty())
    s += "void";
  else
    s += toString(sig.Returns[0]);
  return std::string(s.str());
}

std::string toString(const WasmGlobalType &type) {
  return (type.Mutable ? "var " : "const ") +
         toString(static_cast<ValType>(type.Type));
}

std::string toString(const WasmEventType &type) {
  if (type.Attribute == WASM_EVENT_ATTRIBUTE_EXCEPTION)
    return "exception";
  return "unknown";
}

namespace wasm {
void debugWrite(uint64_t offset, const Twine &msg) {
  LLVM_DEBUG(dbgs() << format("  | %08lld: ", offset) << msg << "\n");
}

void writeUleb128(raw_ostream &os, uint64_t number, const Twine &msg) {
  debugWrite(os.tell(), msg + "[" + utohexstr(number) + "]");
  encodeULEB128(number, os);
}

void writeSleb128(raw_ostream &os, int64_t number, const Twine &msg) {
  debugWrite(os.tell(), msg + "[" + utohexstr(number) + "]");
  encodeSLEB128(number, os);
}

void writeBytes(raw_ostream &os, const char *bytes, size_t count,
                      const Twine &msg) {
  debugWrite(os.tell(), msg + " [data[" + Twine(count) + "]]");
  os.write(bytes, count);
}

void writeStr(raw_ostream &os, StringRef string, const Twine &msg) {
  debugWrite(os.tell(),
             msg + " [str[" + Twine(string.size()) + "]: " + string + "]");
  encodeULEB128(string.size(), os);
  os.write(string.data(), string.size());
}

void writeU8(raw_ostream &os, uint8_t byte, const Twine &msg) {
  debugWrite(os.tell(), msg + " [0x" + utohexstr(byte) + "]");
  os << byte;
}

void writeU32(raw_ostream &os, uint32_t number, const Twine &msg) {
  debugWrite(os.tell(), msg + "[0x" + utohexstr(number) + "]");
  support::endian::write(os, number, support::little);
}

void writeU64(raw_ostream &os, uint64_t number, const Twine &msg) {
  debugWrite(os.tell(), msg + "[0x" + utohexstr(number) + "]");
  support::endian::write(os, number, support::little);
}

void writeValueType(raw_ostream &os, ValType type, const Twine &msg) {
  writeU8(os, static_cast<uint8_t>(type),
          msg + "[type: " + toString(type) + "]");
}

void writeSig(raw_ostream &os, const WasmSignature &sig) {
  writeU8(os, WASM_TYPE_FUNC, "signature type");
  writeUleb128(os, sig.Params.size(), "param Count");
  for (ValType paramType : sig.Params) {
    writeValueType(os, paramType, "param type");
  }
  writeUleb128(os, sig.Returns.size(), "result Count");
  for (ValType returnType : sig.Returns) {
    writeValueType(os, returnType, "result type");
  }
}

void writeI32Const(raw_ostream &os, int32_t number, const Twine &msg) {
  writeU8(os, WASM_OPCODE_I32_CONST, "i32.const");
  writeSleb128(os, number, msg);
}

void writeI64Const(raw_ostream &os, int64_t number, const Twine &msg) {
  writeU8(os, WASM_OPCODE_I64_CONST, "i64.const");
  writeSleb128(os, number, msg);
}

void writeMemArg(raw_ostream &os, uint32_t alignment, uint64_t offset) {
  writeUleb128(os, alignment, "alignment");
  writeUleb128(os, offset, "offset");
}

void writeInitExpr(raw_ostream &os, const WasmInitExpr &initExpr) {
  writeU8(os, initExpr.Opcode, "opcode");
  switch (initExpr.Opcode) {
  case WASM_OPCODE_I32_CONST:
    writeSleb128(os, initExpr.Value.Int32, "literal (i32)");
    break;
  case WASM_OPCODE_I64_CONST:
    writeSleb128(os, initExpr.Value.Int64, "literal (i64)");
    break;
  case WASM_OPCODE_F32_CONST:
    writeU32(os, initExpr.Value.Float32, "literal (f32)");
    break;
  case WASM_OPCODE_F64_CONST:
    writeU64(os, initExpr.Value.Float64, "literal (f64)");
    break;
  case WASM_OPCODE_GLOBAL_GET:
    writeUleb128(os, initExpr.Value.Global, "literal (global index)");
    break;
  case WASM_OPCODE_REF_NULL:
    writeValueType(os, ValType::EXTERNREF, "literal (externref type)");
    break;
  default:
    fatal("unknown opcode in init expr: " + Twine(initExpr.Opcode));
  }
  writeU8(os, WASM_OPCODE_END, "opcode:end");
}

void writeLimits(raw_ostream &os, const WasmLimits &limits) {
  writeU8(os, limits.Flags, "limits flags");
  writeUleb128(os, limits.Initial, "limits initial");
  if (limits.Flags & WASM_LIMITS_FLAG_HAS_MAX)
    writeUleb128(os, limits.Maximum, "limits max");
}

void writeGlobalType(raw_ostream &os, const WasmGlobalType &type) {
  // TODO: Update WasmGlobalType to use ValType and remove this cast.
  writeValueType(os, ValType(type.Type), "global type");
  writeU8(os, type.Mutable, "global mutable");
}

void writeGlobal(raw_ostream &os, const WasmGlobal &global) {
  writeGlobalType(os, global.Type);
  writeInitExpr(os, global.InitExpr);
}

void writeEventType(raw_ostream &os, const WasmEventType &type) {
  writeUleb128(os, type.Attribute, "event attribute");
  writeUleb128(os, type.SigIndex, "sig index");
}

void writeEvent(raw_ostream &os, const WasmEvent &event) {
  writeEventType(os, event.Type);
}

void writeTableType(raw_ostream &os, const llvm::wasm::WasmTable &type) {
  writeU8(os, WASM_TYPE_FUNCREF, "table type");
  writeLimits(os, type.Limits);
}

void writeImport(raw_ostream &os, const WasmImport &import) {
  writeStr(os, import.Module, "import module name");
  writeStr(os, import.Field, "import field name");
  writeU8(os, import.Kind, "import kind");
  switch (import.Kind) {
  case WASM_EXTERNAL_FUNCTION:
    writeUleb128(os, import.SigIndex, "import sig index");
    break;
  case WASM_EXTERNAL_GLOBAL:
    writeGlobalType(os, import.Global);
    break;
  case WASM_EXTERNAL_EVENT:
    writeEventType(os, import.Event);
    break;
  case WASM_EXTERNAL_MEMORY:
    writeLimits(os, import.Memory);
    break;
  case WASM_EXTERNAL_TABLE:
    writeTableType(os, import.Table);
    break;
  default:
    fatal("unsupported import type: " + Twine(import.Kind));
  }
}

void writeExport(raw_ostream &os, const WasmExport &export_) {
  writeStr(os, export_.Name, "export name");
  writeU8(os, export_.Kind, "export kind");
  switch (export_.Kind) {
  case WASM_EXTERNAL_FUNCTION:
    writeUleb128(os, export_.Index, "function index");
    break;
  case WASM_EXTERNAL_GLOBAL:
    writeUleb128(os, export_.Index, "global index");
    break;
  case WASM_EXTERNAL_EVENT:
    writeUleb128(os, export_.Index, "event index");
    break;
  case WASM_EXTERNAL_MEMORY:
    writeUleb128(os, export_.Index, "memory index");
    break;
  case WASM_EXTERNAL_TABLE:
    writeUleb128(os, export_.Index, "table index");
    break;
  default:
    fatal("unsupported export type: " + Twine(export_.Kind));
  }
}

} // namespace wasm
} // namespace lld
