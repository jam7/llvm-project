; RUN: llc < %s -mtriple=ve-unknown-unknown | FileCheck %s

define zeroext i1 @setccf64(double, double) {
; CHECK-LABEL: setccf64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    fcmp.d %s1, %s0, %s1
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    cmov.d.gt %s0, (63)0, %s1
; CHECK-NEXT:    or %s11, 0, %s9
  %3 = fcmp ogt double %0, %1
  ret i1 %3
}

define zeroext i1 @setccf32(float, float) {
; CHECK-LABEL: setccf32:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    fcmp.s %s1, %s0, %s1
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    cmov.s.gt %s0, (63)0, %s1
; CHECK-NEXT:    or %s11, 0, %s9
  %3 = fcmp ogt float %0, %1
  ret i1 %3
}

define zeroext i1 @setcci64(i64, i64) {
; CHECK-LABEL: setcci64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    cmps.l %s0, %s1, %s0
; CHECK-NEXT:    srl %s0, %s0, 63
; CHECK-NEXT:    or %s11, 0, %s9
  %3 = icmp sgt i64 %0, %1
  ret i1 %3
}

define zeroext i1 @setcci32(i32, i32) {
; CHECK-LABEL: setcci32:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    cmps.w.zx %s0, %s1, %s0
; CHECK-NEXT:    srl %s0, %s0, 31
; CHECK-NEXT:    or %s11, 0, %s9
  %3 = icmp sgt i32 %0, %1
  ret i1 %3
}

define zeroext i1 @setcci1(i1 zeroext, i1 zeroext) {
; CHECK-LABEL: setcci1:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    nnd %s0, %s1, %s0
; CHECK-NEXT:    or %s11, 0, %s9
  %3 = xor i1 %1, true
  %4 = and i1 %3, %0
  ret i1 %4
}
