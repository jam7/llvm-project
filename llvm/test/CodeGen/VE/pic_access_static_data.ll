; RUN: llc -relocation-model=pic < %s -mtriple=ve-unknown-unknown | FileCheck %s

@dst = internal unnamed_addr global i32 0, align 4
@src = internal unnamed_addr global i1 false, align 4
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1

define void @func() {
; CHECK-LABEL: func:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s15, _GLOBAL_OFFSET_TABLE_@pc_lo(-24)
; CHECK-NEXT:    and %s15, %s15, (32)0
; CHECK-NEXT:    sic %s16
; CHECK-NEXT:    lea.sl %s15, _GLOBAL_OFFSET_TABLE_@pc_hi(%s16, %s15)
; CHECK-NEXT:    lea %s0, src@gotoff_lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s0, src@gotoff_hi(, %s0)
; CHECK-NEXT:    adds.l %s0, %s15, %s0
; CHECK-NEXT:    ld1b.zx %s0, (, %s0)
; CHECK-NEXT:    or %s1, 0, (0)1
; CHECK-NEXT:    lea %s2, 100
; CHECK-NEXT:    cmov.w.ne %s1, %s2, %s0
; CHECK-NEXT:    lea %s0, dst@gotoff_lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s0, dst@gotoff_hi(, %s0)
; CHECK-NEXT:    adds.l %s0, %s15, %s0
; CHECK-NEXT:    stl %s1, (, %s0)
; CHECK-NEXT:    or %s11, 0, %s9

  %1 = load i1, i1* @src, align 4
  %2 = select i1 %1, i32 100, i32 0
  store i32 %2, i32* @dst, align 4
  ret void
}
