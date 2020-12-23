; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -verify -iroutliner < %s | FileCheck %s

; This test checks that we do not outline memset intrinsics since it requires
; extra address space checks.

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i32, i1)

define i64 @function1(i64 %x, i64 %z, i64 %n) {
; CHECK-LABEL: @function1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[POOL:%.*]] = alloca [59 x i64], align 4
; CHECK-NEXT:    [[TMP:%.*]] = bitcast [59 x i64]* [[POOL]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[TMP]], i8 0, i64 236, i1 false)
; CHECK-NEXT:    call void @outlined_ir_func_0(i64 [[N:%.*]], i64 [[X:%.*]], i64 [[Z:%.*]])
; CHECK-NEXT:    ret i64 0
;
entry:
  %pool = alloca [59 x i64], align 4
  %tmp = bitcast [59 x i64]* %pool to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull %tmp, i8 0, i64 236, i32 4, i1 false)
  %cmp3 = icmp eq i64 %n, 0
  %a = add i64 %x, %z
  %c = add i64 %x, %z
  ret i64 0
}

define i64 @function2(i64 %x, i64 %z, i64 %n) {
; CHECK-LABEL: @function2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[POOL:%.*]] = alloca [59 x i64], align 4
; CHECK-NEXT:    [[TMP:%.*]] = bitcast [59 x i64]* [[POOL]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[TMP]], i8 0, i64 236, i1 false)
; CHECK-NEXT:    call void @outlined_ir_func_0(i64 [[N:%.*]], i64 [[X:%.*]], i64 [[Z:%.*]])
; CHECK-NEXT:    ret i64 0
;
entry:
  %pool = alloca [59 x i64], align 4
  %tmp = bitcast [59 x i64]* %pool to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull %tmp, i8 0, i64 236, i32 4, i1 false)
  %cmp3 = icmp eq i64 %n, 0
  %a = add i64 %x, %z
  %c = add i64 %x, %z
  ret i64 0
}
