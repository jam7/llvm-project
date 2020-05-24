; RUN: llc < %s -mtriple=ve-unknown-unknown | FileCheck %s
; RUN: llc < %s -mtriple=ve-unknown-unknown -mattr=-vec | FileCheck %s
; RUN: llc < %s -mtriple=ve-unknown-unknown -mattr=+vec | FileCheck %s -check-prefix=VEC

@data = common global [16 x i32] zeroinitializer, align 4
@ldata = common global [16 x i64] zeroinitializer, align 8

; Function Attrs: noinline nounwind
define void @fun() {
; CHECK-LABEL: fun:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s0, data@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s0, data@hi(, %s0)
; CHECK-NEXT:    or %s1, 0, (0)1
; CHECK-NEXT:    st %s1, (, %s0)
; CHECK-NEXT:    st %s1, 8(, %s0)
; CHECK-NEXT:    st %s1, 16(, %s0)
; CHECK-NEXT:    st %s1, 24(, %s0)
; CHECK-NEXT:    or %s11, 0, %s9
;
; VEC-LABEL: fun:
; VEC:       .LBB{{[0-9]+}}_2:
; VEC-NEXT:    lea %s0, data@lo
; VEC-NEXT:    and %s0, %s0, (32)0
; VEC-NEXT:    lea.sl %s0, data@hi(, %s0)
; VEC-NEXT:    or %s1, 0, (0)1
; VEC-NEXT:    st %s1, (, %s0)
; VEC-NEXT:    st %s1, 8(, %s0)
; VEC-NEXT:    st %s1, 16(, %s0)
; VEC-NEXT:    st %s1, 24(, %s0)
; VEC-NEXT:    or %s11, 0, %s9
  store i32 0, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @data, i64 0, i64 0), align 4
  store i32 0, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @data, i64 0, i64 1), align 4
  store i32 0, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @data, i64 0, i64 2), align 4
  store i32 0, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @data, i64 0, i64 3), align 4
  store i32 0, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @data, i64 0, i64 4), align 4
  store i32 0, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @data, i64 0, i64 5), align 4
  store i32 0, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @data, i64 0, i64 6), align 4
  store i32 0, i32* getelementptr inbounds ([16 x i32], [16 x i32]* @data, i64 0, i64 7), align 4
  ret void
}

; Function Attrs: noinline nounwind
define void @fun2() {
; CHECK-LABEL: fun2:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s0, ldata@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s0, ldata@hi(, %s0)
; CHECK-NEXT:    or %s1, 0, (0)1
; CHECK-NEXT:    st %s1, (, %s0)
; CHECK-NEXT:    st %s1, 8(, %s0)
; CHECK-NEXT:    st %s1, 16(, %s0)
; CHECK-NEXT:    st %s1, 24(, %s0)
; CHECK-NEXT:    st %s1, 32(, %s0)
; CHECK-NEXT:    st %s1, 40(, %s0)
; CHECK-NEXT:    st %s1, 48(, %s0)
; CHECK-NEXT:    st %s1, 56(, %s0)
; CHECK-NEXT:    or %s11, 0, %s9
;
; VEC-LABEL: fun2:
; VEC:       .LBB{{[0-9]+}}_2:
; VEC-NEXT:    lea %s0, 8
; VEC-NEXT:    or %s1, 0, (0)1
; VEC-NEXT:    lvl %s0
; VEC-NEXT:    vbrd %v0,%s1
; VEC-NEXT:    lea %s1, ldata@lo
; VEC-NEXT:    and %s1, %s1, (32)0
; VEC-NEXT:    lea.sl %s1, ldata@hi(, %s1)
; VEC-NEXT:    vst %v0,8,%s1
; VEC-NEXT:    or %s11, 0, %s9
  store i64 0, i64* getelementptr inbounds ([16 x i64], [16 x i64]* @ldata, i64 0, i64 0), align 8
  store i64 0, i64* getelementptr inbounds ([16 x i64], [16 x i64]* @ldata, i64 0, i64 1), align 8
  store i64 0, i64* getelementptr inbounds ([16 x i64], [16 x i64]* @ldata, i64 0, i64 2), align 8
  store i64 0, i64* getelementptr inbounds ([16 x i64], [16 x i64]* @ldata, i64 0, i64 3), align 8
  store i64 0, i64* getelementptr inbounds ([16 x i64], [16 x i64]* @ldata, i64 0, i64 4), align 8
  store i64 0, i64* getelementptr inbounds ([16 x i64], [16 x i64]* @ldata, i64 0, i64 5), align 8
  store i64 0, i64* getelementptr inbounds ([16 x i64], [16 x i64]* @ldata, i64 0, i64 6), align 8
  store i64 0, i64* getelementptr inbounds ([16 x i64], [16 x i64]* @ldata, i64 0, i64 7), align 8
  ret void
}

