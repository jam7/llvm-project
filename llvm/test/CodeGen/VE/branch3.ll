; RUN: llc < %s -mtriple=ve-unknown-unknown | FileCheck %s

define signext i8 @func1(i8 signext %a) {
; CHECK-LABEL: func1:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    brgt.w 1, %s0, .LBB{{[0-9]+}}_1
entry:
  %cmp = icmp sgt i8 %a, 0
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  %r8 = trunc i32 %ret.val to i8
  br label %join

join:
  %r = phi i8 [ %r8, %on.true ], [ 0, %entry ]
  ret i8 %r
}

declare i32 @ret(i32)

define i32 @func2(i16 signext %a) {
; CHECK-LABEL: func2:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    brgt.w 2, %s0, .LBB{{[0-9]+}}_1
entry:
  %cmp = icmp sgt i16 %a, 1
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  br label %join

join:
  %r = phi i32 [ %ret.val, %on.true ], [ 0, %entry ]
  ret i32 %r
}

define i32 @func3(i32 %a) {
; CHECK-LABEL: func3:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    brgt.w 19, %s0, .LBB{{[0-9]+}}_1
entry:
  %cmp = icmp sgt i32 %a, 18
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  br label %join

join:
  %r = phi i32 [ %ret.val, %on.true ], [ 0, %entry ]
  ret i32 %r
}

define i32 @func4(i64 %a) {
; CHECK-LABEL: func4:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    brgt.l -63, %s0, .LBB{{[0-9]+}}_1
entry:
  %cmp = icmp sgt i64 %a, -64
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  br label %join

join:
  %r = phi i32 [ %ret.val, %on.true ], [ 0, %entry ]
  ret i32 %r
}

define i32 @func5(i8 zeroext %a) {
; CHECK-LABEL: func5:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    cmpu.w %s0, 63, %s0
; CHECK-NEXT:    brlt.w 0, %s0, .LBB{{[0-9]+}}_1
entry:
  %cmp = icmp ugt i8 %a, 62
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  br label %join

join:
  %r = phi i32 [ %ret.val, %on.true ], [ 0, %entry ]
  ret i32 %r
}

define i32 @func6(i16 zeroext %a) {
; CHECK-LABEL: func6:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    cmpu.w %s0, 8, %s0
; CHECK-NEXT:    brlt.w 0, %s0, .LBB{{[0-9]+}}_1
entry:
  %cmp = icmp ugt i16 %a, 7
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  br label %join

join:
  %r = phi i32 [ %ret.val, %on.true ], [ 0, %entry ]
  ret i32 %r
}

define i32 @func7(i32 %a) {
; CHECK-LABEL: func7:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    cmpu.w %s0, 13, %s0
; CHECK-NEXT:    brlt.w 0, %s0, .LBB{{[0-9]+}}_1
entry:
  %cmp = icmp ugt i32 %a, 12
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  br label %join

join:
  %r = phi i32 [ %ret.val, %on.true ], [ 0, %entry ]
  ret i32 %r
}

define i32 @func8(float %a) {
; CHECK-LABEL: func8:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    brltnan.s 0, %s0, .LBB{{[0-9]+}}_1
entry:
  %cmp = fcmp ole float %a, 0.0
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  br label %join

join:
  %r = phi i32 [ %ret.val, %on.true ], [ 0, %entry ]
  ret i32 %r
}

define i32 @func9(double %a) {
; CHECK-LABEL: func9:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    brgenan.d 0, %s0, .LBB{{[0-9]+}}_1
entry:
  %cmp = fcmp ogt double %a, 0.0
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  br label %join

join:
  %r = phi i32 [ %ret.val, %on.true ], [ 0, %entry ]
  ret i32 %r
}

define i32 @func10(double %a) {
; CHECK-LABEL: func10:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    lea.sl %s1, 1075052544
; CHECK-NEXT:    brlenan.d %s0, %s1, .LBB{{[0-9]+}}_1
entry:
  %cmp = fcmp ogt double %a, 5.000000e+00
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  br label %join

join:
  %r = phi i32 [ %ret.val, %on.true ], [ 0, %entry ]
  ret i32 %r
}

define i32 @func11(fp128 %a) {
; CHECK-LABEL: func11:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    lea %s2, .LCPI10_0@lo
; CHECK-NEXT:    and %s2, %s2, (32)0
; CHECK-NEXT:    lea.sl %s2, .LCPI10_0@hi(, %s2)
; CHECK-NEXT:    ld %s4, 8(, %s2)
; CHECK-NEXT:    ld %s5, (, %s2)
; CHECK-NEXT:    fcmp.q %s0, %s4, %s0
; CHECK-NEXT:    brlenan.d 0, %s0, .LBB{{[0-9]+}}_1
entry:
  %cmp = fcmp ogt fp128 %a, 0xL00000000000000000000000000000000
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  br label %join

join:
  %r = phi i32 [ %ret.val, %on.true ], [ 0, %entry ]
  ret i32 %r
}

; Function Attrs: nounwind
define i32 @func12(i128 %a) {
; CHECK-LABEL: func12:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    srl %s2, %s1, 63
; CHECK-NEXT:    or %s3, 23, (0)1
; CHECK-NEXT:    cmpu.l %s0, %s0, %s3
; CHECK-NEXT:    srl %s0, %s0, 63
; CHECK-NEXT:    cmov.l.eq %s2, %s0, %s1
; CHECK-NEXT:    brne.w 0, %s2, .LBB{{[0-9]+}}_1
entry:
  %cmp = icmp sgt i128 %a, 22
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  br label %join

join:
  %r = phi i32 [ %ret.val, %on.true ], [ 0, %entry ]
  ret i32 %r
}

; Function Attrs: nounwind
define i32 @func13(i128 %a) {
; CHECK-LABEL: func13:
; CHECK:       .LBB{{[0-9]+}}_5:
; CHECK-NEXT:    cmpu.l %s0, %s0, (58)0
; CHECK-NEXT:    srl %s0, %s0, 63
; CHECK-NEXT:    cmov.l.ne %s0, (0)1, %s1
; CHECK-NEXT:    brne.w 0, %s0, .LBB{{[0-9]+}}_1
entry:
  %cmp = icmp ugt i128 %a, 62
  br i1 %cmp, label %on.true, label %join

on.true:
  %ret.val = tail call i32 @ret(i32 2)
  br label %join

join:
  %r = phi i32 [ %ret.val, %on.true ], [ 0, %entry ]
  ret i32 %r
}
