; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64--linux-gnu -mattr=+sve -aarch64-enable-mgather-combine=0 < %s | FileCheck %s
; RUN: llc -mtriple=aarch64--linux-gnu -mattr=+sve -aarch64-enable-mgather-combine=1 < %s | FileCheck %s

; Test for multiple uses of the mgather where the s/zext should not be combined

define <vscale x 2 x i64> @masked_sgather_sext(i8* %base, <vscale x 2 x i64> %offsets, <vscale x 2 x i1> %mask, <vscale x 2 x i8> %vals) {
; CHECK-LABEL: masked_sgather_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1sb { z0.d }, p0/z, [x0, z0.d]
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    sxtb z2.d, p0/m, z0.d
; CHECK-NEXT:    add z0.d, z0.d, z1.d
; CHECK-NEXT:    sxtb z0.d, p0/m, z0.d
; CHECK-NEXT:    mul z0.d, p0/m, z0.d, z2.d
; CHECK-NEXT:    ret
  %ptrs = getelementptr i8, i8* %base, <vscale x 2 x i64> %offsets
  %data = call <vscale x 2 x i8> @llvm.masked.gather.nxv2i8(<vscale x 2 x i8*> %ptrs, i32 1, <vscale x 2 x i1> %mask, <vscale x 2 x i8> undef)
  %data.sext = sext <vscale x 2 x i8> %data to <vscale x 2 x i64>
  %add = add <vscale x 2 x i8> %data, %vals
  %add.sext = sext <vscale x 2 x i8> %add to <vscale x 2 x i64>
  %mul = mul <vscale x 2 x i64> %data.sext, %add.sext
  ret <vscale x 2 x i64> %mul
}

define <vscale x 2 x i64> @masked_sgather_zext(i8* %base, <vscale x 2 x i64> %offsets, <vscale x 2 x i1> %mask, <vscale x 2 x i8> %vals) {
; CHECK-LABEL: masked_sgather_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT: ld1sb { z0.d }, p0/z, [x0, z0.d]
; CHECK-NEXT: ptrue p0.d
; CHECK-NEXT: add z1.d, z0.d, z1.d
; CHECK-NEXT: and z0.d, z0.d, #0xff
; CHECK-NEXT: and z1.d, z1.d, #0xff
; CHECK-NEXT: mul z0.d, p0/m, z0.d, z1.d
; CHECK-NEXT: ret
  %ptrs = getelementptr i8, i8* %base, <vscale x 2 x i64> %offsets
  %data = call <vscale x 2 x i8> @llvm.masked.gather.nxv2i8(<vscale x 2 x i8*> %ptrs, i32 1, <vscale x 2 x i1> %mask, <vscale x 2 x i8> undef)
  %data.zext = zext <vscale x 2 x i8> %data to <vscale x 2 x i64>
  %add = add <vscale x 2 x i8> %data, %vals
  %add.zext = zext <vscale x 2 x i8> %add to <vscale x 2 x i64>
  %mul = mul <vscale x 2 x i64> %data.zext, %add.zext
  ret <vscale x 2 x i64> %mul
}

; Tests that exercise various type legalisation scenarios for ISD::MGATHER.

; Code generate load of an illegal datatype via promotion.
define <vscale x 2 x i8> @masked_gather_nxv2i8(<vscale x 2 x i8*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2i8:
; CHECK: ld1sb { z0.d }, p0/z, [z0.d]
; CHECK: ret
  %data = call <vscale x 2 x i8> @llvm.masked.gather.nxv2i8(<vscale x 2 x i8*> %ptrs, i32 1, <vscale x 2 x i1> %mask, <vscale x 2 x i8> undef)
  ret <vscale x 2 x i8> %data
}

; Code generate load of an illegal datatype via promotion.
define <vscale x 2 x i16> @masked_gather_nxv2i16(<vscale x 2 x i16*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2i16:
; CHECK: ld1sh { z0.d }, p0/z, [z0.d]
; CHECK: ret
  %data = call <vscale x 2 x i16> @llvm.masked.gather.nxv2i16(<vscale x 2 x i16*> %ptrs, i32 2, <vscale x 2 x i1> %mask, <vscale x 2 x i16> undef)
  ret <vscale x 2 x i16> %data
}

; Code generate load of an illegal datatype via promotion.
define <vscale x 2 x i32> @masked_gather_nxv2i32(<vscale x 2 x i32*> %ptrs, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2i32:
; CHECK: ld1sw { z0.d }, p0/z, [z0.d]
; CHECK: ret
  %data = call <vscale x 2 x i32> @llvm.masked.gather.nxv2i32(<vscale x 2 x i32*> %ptrs, i32 4, <vscale x 2 x i1> %mask, <vscale x 2 x i32> undef)
  ret <vscale x 2 x i32> %data
}

; Code generate the worst case scenario when all vector types are legal.
define <vscale x 16 x i8> @masked_gather_nxv16i8(i8* %base, <vscale x 16 x i8> %indices, <vscale x 16 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv16i8:
; CHECK-DAG: ld1sb { {{z[0-9]+}}.s }, {{p[0-9]+}}/z, [x0, {{z[0-9]+}}.s, sxtw]
; CHECK-DAG: ld1sb { {{z[0-9]+}}.s }, {{p[0-9]+}}/z, [x0, {{z[0-9]+}}.s, sxtw]
; CHECK-DAG: ld1sb { {{z[0-9]+}}.s }, {{p[0-9]+}}/z, [x0, {{z[0-9]+}}.s, sxtw]
; CHECK-DAG: ld1sb { {{z[0-9]+}}.s }, {{p[0-9]+}}/z, [x0, {{z[0-9]+}}.s, sxtw]
; CHECK: ret
  %ptrs = getelementptr i8, i8* %base, <vscale x 16 x i8> %indices
  %data = call <vscale x 16 x i8> @llvm.masked.gather.nxv16i8(<vscale x 16 x i8*> %ptrs, i32 1, <vscale x 16 x i1> %mask, <vscale x 16 x i8> undef)
  ret <vscale x 16 x i8> %data
}

; Code generate the worst case scenario when all vector types are illegal.
define <vscale x 32 x i32> @masked_gather_nxv32i32(i32* %base, <vscale x 32 x i32> %indices, <vscale x 32 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv32i32:
; CHECK-NOT: unpkhi
; CHECK-DAG: ld1w { {{z[0-9]+}}.s }, {{p[0-9]+}}/z, [x0, z0.s, sxtw #2]
; CHECK-DAG: ld1w { {{z[0-9]+}}.s }, {{p[0-9]+}}/z, [x0, z1.s, sxtw #2]
; CHECK-DAG: ld1w { {{z[0-9]+}}.s }, {{p[0-9]+}}/z, [x0, z2.s, sxtw #2]
; CHECK-DAG: ld1w { {{z[0-9]+}}.s }, {{p[0-9]+}}/z, [x0, z3.s, sxtw #2]
; CHECK-DAG: ld1w { {{z[0-9]+}}.s }, {{p[0-9]+}}/z, [x0, z4.s, sxtw #2]
; CHECK-DAG: ld1w { {{z[0-9]+}}.s }, {{p[0-9]+}}/z, [x0, z5.s, sxtw #2]
; CHECK-DAG: ld1w { {{z[0-9]+}}.s }, {{p[0-9]+}}/z, [x0, z6.s, sxtw #2]
; CHECK-DAG: ld1w { {{z[0-9]+}}.s }, {{p[0-9]+}}/z, [x0, z7.s, sxtw #2]
; CHECK: ret
  %ptrs = getelementptr i32, i32* %base, <vscale x 32 x i32> %indices
  %data = call <vscale x 32 x i32> @llvm.masked.gather.nxv32i32(<vscale x 32 x i32*> %ptrs, i32 4, <vscale x 32 x i1> %mask, <vscale x 32 x i32> undef)
  ret <vscale x 32 x i32> %data
}

; TODO: Currently, the sign extend gets applied to the values after a 'uzp1' of two
; registers, so it doesn't get folded away. Same for any other vector-of-pointers
; style gathers which don't fit in an <vscale x 2 x type*> single register. Better folding
; is required before we can check those off.
define <vscale x 4 x i32> @masked_sgather_nxv4i8(<vscale x 4 x i8*> %ptrs, <vscale x 4 x i1> %mask) {
; CHECK-LABEL: masked_sgather_nxv4i8:
; CHECK:         pfalse p1.b
; CHECK-NEXT:    zip2 p2.s, p0.s, p1.s
; CHECK-NEXT:    zip1 p0.s, p0.s, p1.s
; CHECK-NEXT:    ld1sb { z1.d }, p2/z, [z1.d]
; CHECK-NEXT:    ld1sb { z0.d }, p0/z, [z0.d]
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    uzp1 z0.s, z0.s, z1.s
; CHECK-NEXT:    sxtb z0.s, p0/m, z0.s
; CHECK-NEXT:    ret
  %vals = call <vscale x 4 x i8> @llvm.masked.gather.nxv4i8(<vscale x 4 x i8*> %ptrs, i32 1, <vscale x 4 x i1> %mask, <vscale x 4 x i8> undef)
  %svals = sext <vscale x 4 x i8> %vals to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %svals
}

declare <vscale x 2 x i8> @llvm.masked.gather.nxv2i8(<vscale x 2 x i8*>, i32, <vscale x 2 x i1>, <vscale x 2 x i8>)
declare <vscale x 2 x i16> @llvm.masked.gather.nxv2i16(<vscale x 2 x i16*>, i32, <vscale x 2 x i1>, <vscale x 2 x i16>)
declare <vscale x 2 x i32> @llvm.masked.gather.nxv2i32(<vscale x 2 x i32*>, i32, <vscale x 2 x i1>, <vscale x 2 x i32>)
declare <vscale x 4 x i8> @llvm.masked.gather.nxv4i8(<vscale x 4 x i8*>, i32, <vscale x 4 x i1>, <vscale x 4 x i8>)
declare <vscale x 16 x i8> @llvm.masked.gather.nxv16i8(<vscale x 16 x i8*>, i32, <vscale x 16 x i1>, <vscale x 16 x i8>)
declare <vscale x 32 x i32> @llvm.masked.gather.nxv32i32(<vscale x 32 x i32*>, i32, <vscale x 32 x i1>, <vscale x 32 x i32>)
