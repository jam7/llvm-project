; RUN: llc < %s -mtriple=ve-unknown-unknown -mattr=+vec | FileCheck %s

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <512 x i32> @brdv512i32(i32) {
; CHECK-LABEL: brdv512i32:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    and %s1, %s0, (32)0
; CHECK-NEXT:    sll %s0, %s0, 32
; CHECK-NEXT:    or %s0, %s0, %s1
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    pvbrd %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <512 x i32> undef, i32 %0, i32 0
  %ret = insertelement <512 x i32> %val, i32 %0, i32 1
  ret <512 x i32> %ret
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <512 x float> @brdv512f32(float) {
; CHECK-LABEL: brdv512f32:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    srl %s1, %s0, 32
; CHECK-NEXT:    or %s0, %s0, %s1
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    pvbrd %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <512 x float> undef, float %0, i32 0
  %ret = insertelement <512 x float> %val, float %0, i32 1
  ret <512 x float> %ret
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <256 x i64> @brdv256i64(i64) {
; CHECK-LABEL: brdv256i64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrd %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <256 x i64> undef, i64 %0, i32 0
  %ret = insertelement <256 x i64> %val, i64 %0, i32 1
  ret <256 x i64> %ret
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <256 x i32> @brdv256i32(i32) {
; CHECK-LABEL: brdv256i32:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrdl %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <256 x i32> undef, i32 %0, i32 0
  %ret = insertelement <256 x i32> %val, i32 %0, i32 1
  ret <256 x i32> %ret
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <256 x double> @brdv256f64(double) {
; CHECK-LABEL: brdv256f64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrd %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <256 x double> undef, double %0, i32 0
  %ret = insertelement <256 x double> %val, double %0, i32 1
  ret <256 x double> %ret
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <256 x float> @brdv256f32(float) {
; CHECK-LABEL: brdv256f32:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrdu %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <256 x float> undef, float %0, i32 0
  %ret = insertelement <256 x float> %val, float %0, i32 1
  ret <256 x float> %ret
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <128 x i64> @brdv128i64(i64) {
; CHECK-LABEL: brdv128i64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 128
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrd %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <128 x i64> undef, i64 %0, i32 0
  %ret = insertelement <128 x i64> %val, i64 %0, i32 1
  ret <128 x i64> %ret
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <64 x i64> @brdv64i64(i64) {
; CHECK-LABEL: brdv64i64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 64
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrd %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <64 x i64> undef, i64 %0, i32 0
  %ret = insertelement <64 x i64> %val, i64 %0, i32 1
  ret <64 x i64> %ret
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <32 x i64> @brdv32i64(i64) {
; CHECK-LABEL: brdv32i64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 32
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrd %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <32 x i64> undef, i64 %0, i32 0
  %ret = insertelement <32 x i64> %val, i64 %0, i32 1
  ret <32 x i64> %ret
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <16 x i64> @brdv16i64(i64) {
; CHECK-LABEL: brdv16i64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 16
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrd %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <16 x i64> undef, i64 %0, i32 0
  %ret = insertelement <16 x i64> %val, i64 %0, i32 1
  ret <16 x i64> %ret
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <8 x i64> @brdv8i64(i64) {
; CHECK-LABEL: brdv8i64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 8
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrd %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <8 x i64> undef, i64 %0, i32 0
  %ret = insertelement <8 x i64> %val, i64 %0, i32 1
  ret <8 x i64> %ret
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <4 x i64> @brdv4i64(i64) {
; CHECK-LABEL: brdv4i64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 4
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrd %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <4 x i64> undef, i64 %0, i32 0
  %ret = insertelement <4 x i64> %val, i64 %0, i32 1
  ret <4 x i64> %ret
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc <2 x i64> @brdv2i64(i64) {
; CHECK-LABEL: brdv2i64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 2
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vbrd %v0,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  %val = insertelement <2 x i64> undef, i64 %0, i32 0
  %ret = insertelement <2 x i64> %val, i64 %0, i32 1
  ret <2 x i64> %ret
}

