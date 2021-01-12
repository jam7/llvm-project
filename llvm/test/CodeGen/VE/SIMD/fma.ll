; RUN: llc < %s -mtriple=ve -mattr=+simd | FileCheck %s

; Function Attrs: norecurse nounwind readnone
define double @fma_d_1(double, double, double) {
; CHECK-LABEL: fma_d_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmul.d %s0, %s1, %s0
; CHECK-NEXT:    fadd.d %s0, %s0, %s2
; CHECK-NEXT:    b.l.t (, %s10)
  %4 = fmul double %1, %0
  %5 = fadd double %4, %2
  ret double %5
}

; Function Attrs: norecurse nounwind readnone
define double @fma_d_2(double, double, double) {
; CHECK-LABEL: fma_d_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmul.d %s0, %s1, %s0
; CHECK-NEXT:    fadd.d %s0, %s0, %s2
; CHECK-NEXT:    b.l.t (, %s10)
  %4 = fmul fast double %1, %0
  %5 = fadd fast double %4, %2
  ret double %5
}

; Function Attrs: norecurse nounwind readnone
define float @fma_f_1(float, float, float) {
; CHECK-LABEL: fma_f_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmul.s %s0, %s1, %s0
; CHECK-NEXT:    fadd.s %s0, %s0, %s2
; CHECK-NEXT:    b.l.t (, %s10)
  %4 = fmul float %1, %0
  %5 = fadd float %4, %2
  ret float %5
}

; Function Attrs: norecurse nounwind readnone
define float @fma_f_2(float, float, float) {
; CHECK-LABEL: fma_f_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmul.s %s0, %s1, %s0
; CHECK-NEXT:    fadd.s %s0, %s0, %s2
; CHECK-NEXT:    b.l.t (, %s10)
  %4 = fmul fast float %1, %0
  %5 = fadd fast float %4, %2
  ret float %5
}

; Function Attrs: norecurse nounwind readnone
define x86_regcallcc <256 x double> @__regcall3__fma_v256d_1(<256 x double>, <256 x double>, <256 x double>) {
; CHECK-LABEL: __regcall3__fma_v256d_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vfmul.d %v0, %v0, %v1
; CHECK-NEXT:    vfadd.d %v0, %v0, %v2
; CHECK-NEXT:    b.l.t (, %s10)
  %4 = fmul <256 x double> %0, %1
  %5 = fadd <256 x double> %4, %2
  ret <256 x double> %5
}

; Function Attrs: norecurse nounwind readnone
define x86_regcallcc <256 x double> @__regcall3__fma_v256d_2(<256 x double>, <256 x double>, <256 x double>) {
; CHECK-LABEL: __regcall3__fma_v256d_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vfmad.d %v0, %v2, %v0, %v1
; CHECK-NEXT:    b.l.t (, %s10)
  %4 = fmul fast <256 x double> %0, %1
  %5 = fadd fast <256 x double> %4, %2
  ret <256 x double> %5
}

; Function Attrs: norecurse nounwind readnone
define x86_regcallcc <256 x float> @__regcall3__fma_v256f_1(<256 x float>, <256 x float>, <256 x float>) {
; CHECK-LABEL: __regcall3__fma_v256f_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vfmul.s %v0, %v0, %v1
; CHECK-NEXT:    vfadd.s %v0, %v0, %v2
; CHECK-NEXT:    b.l.t (, %s10)
  %4 = fmul <256 x float> %0, %1
  %5 = fadd <256 x float> %4, %2
  ret <256 x float> %5
}

; Function Attrs: norecurse nounwind readnone
define x86_regcallcc <256 x float> @__regcall3__fma_v256f_2(<256 x float>, <256 x float>, <256 x float>) {
; CHECK-LABEL: __regcall3__fma_v256f_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vfmad.s %v0, %v2, %v0, %v1
; CHECK-NEXT:    b.l.t (, %s10)
  %4 = fmul fast <256 x float> %0, %1
  %5 = fadd fast <256 x float> %4, %2
  ret <256 x float> %5
}
