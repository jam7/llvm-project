; RUN: llc < %s -mtriple=ve-unknown-unknown | FileCheck %s

; Function Attrs: norecurse nounwind readnone
define signext i8 @func_int8_t(i1 zeroext %cmp, i8 signext %a, i8 signext %b) {
; CHECK-LABEL: func_int8_t:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    adds.w.sx %s1, %s1, (0)1
; CHECK-NEXT:    adds.w.sx %s2, %s2, (0)1
; CHECK-NEXT:    cmov.w.ne %s2, %s1, %s0
; CHECK-NEXT:    adds.w.sx %s0, %s2, (0)1
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond.v = select i1 %cmp, i8 %a, i8 %b
  ret i8 %cond.v
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @func_uint8_t(i1 zeroext %cmp, i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: func_uint8_t:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    adds.w.sx %s1, %s1, (0)1
; CHECK-NEXT:    adds.w.sx %s2, %s2, (0)1
; CHECK-NEXT:    cmov.w.ne %s2, %s1, %s0
; CHECK-NEXT:    adds.w.zx %s0, %s2, (0)1
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond.v = select i1 %cmp, i8 %a, i8 %b
  ret i8 %cond.v
}

; Function Attrs: norecurse nounwind readnone
define signext i16 @func_int16_t(i1 zeroext %cmp, i16 signext %a, i16 signext %b) {
; CHECK-LABEL: func_int16_t:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    adds.w.sx %s1, %s1, (0)1
; CHECK-NEXT:    adds.w.sx %s2, %s2, (0)1
; CHECK-NEXT:    cmov.w.ne %s2, %s1, %s0
; CHECK-NEXT:    adds.w.sx %s0, %s2, (0)1
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond.v = select i1 %cmp, i16 %a, i16 %b
  ret i16 %cond.v
}

; Function Attrs: norecurse nounwind readnone
define zeroext i16 @func_uint16_t(i1 zeroext %cmp, i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: func_uint16_t:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    adds.w.sx %s1, %s1, (0)1
; CHECK-NEXT:    adds.w.sx %s2, %s2, (0)1
; CHECK-NEXT:    cmov.w.ne %s2, %s1, %s0
; CHECK-NEXT:    adds.w.zx %s0, %s2, (0)1
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond.v = select i1 %cmp, i16 %a, i16 %b
  ret i16 %cond.v
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @func_int32_t(i1 zeroext %cmp, i32 signext %a, i32 signext %b) {
; CHECK-LABEL: func_int32_t:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    adds.w.sx %s1, %s1, (0)1
; CHECK-NEXT:    adds.w.sx %s2, %s2, (0)1
; CHECK-NEXT:    cmov.w.ne %s2, %s1, %s0
; CHECK-NEXT:    adds.w.sx %s0, %s2, (0)1
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond = select i1 %cmp, i32 %a, i32 %b
  ret i32 %cond
}

; Function Attrs: norecurse nounwind readnone
define zeroext i32 @func_uint32_t(i1 zeroext %cmp, i32 zeroext %a, i32 zeroext %b) {
; CHECK-LABEL: func_uint32_t:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    adds.w.sx %s1, %s1, (0)1
; CHECK-NEXT:    adds.w.sx %s2, %s2, (0)1
; CHECK-NEXT:    cmov.w.ne %s2, %s1, %s0
; CHECK-NEXT:    adds.w.zx %s0, %s2, (0)1
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond = select i1 %cmp, i32 %a, i32 %b
  ret i32 %cond
}

; Function Attrs: norecurse nounwind readnone
define i64 @func_int64_t(i1 zeroext %cmp, i64 %a, i64 %b) {
; CHECK-LABEL: func_int64_t:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    cmov.w.ne %s2, %s1, %s0
; CHECK-NEXT:    or %s0, 0, %s2
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond = select i1 %cmp, i64 %a, i64 %b
  ret i64 %cond
}

; Function Attrs: norecurse nounwind readnone
define i64 @func_uint64_t(i1 zeroext %cmp, i64 %a, i64 %b) {
; CHECK-LABEL: func_uint64_t:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    cmov.w.ne %s2, %s1, %s0
; CHECK-NEXT:    or %s0, 0, %s2
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond = select i1 %cmp, i64 %a, i64 %b
  ret i64 %cond
}

; Function Attrs: norecurse nounwind readnone
define i128 @func_int128_t(i1 zeroext %cmp, i128 %a, i128 %b) {
; CHECK-LABEL: func_int128_t:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    cmov.w.ne %s3, %s1, %s0
; CHECK-NEXT:    cmov.w.ne %s4, %s2, %s0
; CHECK-NEXT:    or %s0, 0, %s3
; CHECK-NEXT:    or %s1, 0, %s4
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond = select i1 %cmp, i128 %a, i128 %b
  ret i128 %cond
}

; Function Attrs: norecurse nounwind readnone
define i128 @func_uint128_t(i1 zeroext %cmp, i128 %a, i128 %b) {
; CHECK-LABEL: func_uint128_t:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    cmov.w.ne %s3, %s1, %s0
; CHECK-NEXT:    cmov.w.ne %s4, %s2, %s0
; CHECK-NEXT:    or %s0, 0, %s3
; CHECK-NEXT:    or %s1, 0, %s4
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond = select i1 %cmp, i128 %a, i128 %b
  ret i128 %cond
}

; Function Attrs: norecurse nounwind readnone
define float @func_float(i1 zeroext %cmp, float %a, float %b) {
; CHECK-LABEL: func_float:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    cmov.w.ne %s2, %s1, %s0
; CHECK-NEXT:    or %s0, 0, %s2
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond = select i1 %cmp, float %a, float %b
  ret float %cond
}

; Function Attrs: norecurse nounwind readnone
define double @func_double(i1 zeroext %cmp, double %a, double %b) {
; CHECK-LABEL: func_double:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    cmov.w.ne %s2, %s1, %s0
; CHECK-NEXT:    or %s0, 0, %s2
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond = select i1 %cmp, double %a, double %b
  ret double %cond
}

; Function Attrs: norecurse nounwind readnone
define fp128 @func_quad(i1 zeroext %cmp, fp128 %a, fp128 %b) {
; CHECK-LABEL: func_quad:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    cmov.w.ne %s3, %s1, %s0
; CHECK-NEXT:    cmov.w.ne %s4, %s2, %s0
; CHECK-NEXT:    or %s0, 0, %s3
; CHECK-NEXT:    or %s1, 0, %s4
; CHECK-NEXT:    or %s11, 0, %s9
entry:
  %cond = select i1 %cmp, fp128 %a, fp128 %b
  ret fp128 %cond
}

