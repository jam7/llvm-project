; RUN: llc < %s -mtriple=ve-unknown-unknown | FileCheck %s

; Function Attrs: norecurse nounwind readnone
define i32 @callee(i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i8 signext, i16 signext, fp128) {
; CHECK-LABEL: callee:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    ld %s35, 448(, %s11)
; CHECK-NEXT:    ld %s34, 456(, %s11)
; CHECK-NEXT:    ldl.sx %s36, 440(, %s11)
; CHECK-NEXT:    ldl.sx %s37, 432(, %s11)
; CHECK-NEXT:    ldl.sx %s38, 424(, %s11)
; CHECK-NEXT:    ldl.sx %s39, 416(, %s11)
; CHECK-NEXT:    adds.w.sx %s0, %s1, %s0
; CHECK-NEXT:    adds.w.sx %s0, %s0, %s2
; CHECK-NEXT:    adds.w.sx %s0, %s0, %s3
; CHECK-NEXT:    adds.w.sx %s0, %s0, %s4
; CHECK-NEXT:    adds.w.sx %s0, %s0, %s5
; CHECK-NEXT:    adds.w.sx %s0, %s0, %s6
; CHECK-NEXT:    adds.w.sx %s0, %s0, %s7
; CHECK-NEXT:    adds.w.sx %s0, %s0, %s39
; CHECK-NEXT:    adds.w.sx %s0, %s0, %s38
; CHECK-NEXT:    adds.w.sx %s0, %s0, %s37
; CHECK-NEXT:    adds.w.sx %s0, %s0, %s36
; CHECK-NEXT:    cvt.d.q %s1, %s34
; CHECK-NEXT:    cvt.w.d.sx.rz %s1, %s1
; CHECK-NEXT:    adds.w.sx %s0, %s0, %s1
; CHECK-NEXT:    or %s11, 0, %s9
  %14 = add nsw i32 %1, %0
  %15 = add nsw i32 %14, %2
  %16 = add nsw i32 %15, %3
  %17 = add nsw i32 %16, %4
  %18 = add nsw i32 %17, %5
  %19 = add nsw i32 %18, %6
  %20 = add nsw i32 %19, %7
  %21 = add nsw i32 %20, %8
  %22 = add nsw i32 %21, %9
  %23 = sext i8 %10 to i32
  %24 = add nsw i32 %22, %23
  %25 = sext i16 %11 to i32
  %26 = add nsw i32 %24, %25
  %27 = fptosi fp128 %12 to i32
  %28 = add nsw i32 %26, %27
  ret i32 %28
}

; Function Attrs: nounwind
define i32 @caller2() {
; CHECK-LABEL: caller2:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    or %s0, 10, (0)1
; CHECK-NEXT:    st %s0, 248(, %s11)
; CHECK-NEXT:    or %s34, 9, (0)1
; CHECK-NEXT:    lea %s0, callee2@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s12, callee2@hi(, %s0)
; CHECK-NEXT:    or %s0, 1, (0)1
; CHECK-NEXT:    or %s1, 2, (0)1
; CHECK-NEXT:    or %s2, 3, (0)1
; CHECK-NEXT:    or %s3, 4, (0)1
; CHECK-NEXT:    or %s4, 5, (0)1
; CHECK-NEXT:    or %s5, 6, (0)1
; CHECK-NEXT:    or %s6, 7, (0)1
; CHECK-NEXT:    or %s7, 8, (0)1
; CHECK-NEXT:    st %s34, 240(, %s11)
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:    or %s11, 0, %s9
  %1 = tail call i32 @callee2(i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10)
  ret i32 %1
}

declare i32 @callee2(i32, i32, i32, i32, i32, i32, i32, i32, i32, i32)

; Function Attrs: nounwind
define i32 @caller3() {
; CHECK-LABEL: caller3:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    or %s0, 10, (0)1
; CHECK-NEXT:    st %s0, 248(, %s11)
; CHECK-NEXT:    or %s0, 9, (0)1
; CHECK-NEXT:    st %s0, 240(, %s11)
; CHECK-NEXT:    or %s7, 8, (0)1
; CHECK-NEXT:    st %s7, 232(, %s11)
; CHECK-NEXT:    or %s6, 7, (0)1
; CHECK-NEXT:    st %s6, 224(, %s11)
; CHECK-NEXT:    or %s5, 6, (0)1
; CHECK-NEXT:    st %s5, 216(, %s11)
; CHECK-NEXT:    or %s4, 5, (0)1
; CHECK-NEXT:    st %s4, 208(, %s11)
; CHECK-NEXT:    lea.sl %s0, 1074790400
; CHECK-NEXT:    st %s0, 200(, %s11)
; CHECK-NEXT:    or %s2, 3, (0)1
; CHECK-NEXT:    st %s2, 192(, %s11)
; CHECK-NEXT:    or %s1, 2, (0)1
; CHECK-NEXT:    st %s1, 184(, %s11)
; CHECK-NEXT:    or %s0, 1, (0)1
; CHECK-NEXT:    lea %s3, callee3@lo
; CHECK-NEXT:    and %s3, %s3, (32)0
; CHECK-NEXT:    lea.sl %s12, callee3@hi(, %s3)
; CHECK-NEXT:    lea.sl %s3, 1074790400
; CHECK-NEXT:    st %s0, 176(, %s11)
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:    or %s11, 0, %s9
  %1 = tail call i32 (i32, ...) @callee3(i32 1, i32 2, i32 3, double 4.000000e+00, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10)
  ret i32 %1
}

declare i32 @callee3(i32, ...)

; Function Attrs: nounwind
define i32 @caller4() {
; CHECK-LABEL: caller4:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    or %s0, 10, (0)1
; CHECK-NEXT:    st %s0, 248(, %s11)
; CHECK-NEXT:    or %s34, 9, (0)1
; CHECK-NEXT:    lea %s0, callee4@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s12, callee4@hi(, %s0)
; CHECK-NEXT:    or %s0, 1, (0)1
; CHECK-NEXT:    or %s1, 2, (0)1
; CHECK-NEXT:    or %s2, 3, (0)1
; CHECK-NEXT:    lea.sl %s3, 1074790400
; CHECK-NEXT:    or %s4, 5, (0)1
; CHECK-NEXT:    or %s5, 6, (0)1
; CHECK-NEXT:    or %s6, 7, (0)1
; CHECK-NEXT:    or %s7, 8, (0)1
; CHECK-NEXT:    st %s34, 240(, %s11)
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:    or %s11, 0, %s9
  %1 = tail call i32 bitcast (i32 (...)* @callee4 to i32 (i32, i32, i32, double, i32, i32, i32, i32, i32, i32)*)(i32 1, i32 2, i32 3, double 4.000000e+00, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10)
  ret i32 %1
}

declare i32 @callee4(...)

