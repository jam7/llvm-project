; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine -expensive-combines=0 < %s | FileCheck %s --check-prefixes=CHECK,EXPENSIVE-OFF
; RUN: opt -S -instcombine -expensive-combines=1 < %s | FileCheck %s --check-prefixes=CHECK,EXPENSIVE-ON
target datalayout = "E-m:e-i64:64-n32:64"
target triple = "powerpc64-unknown-linux-gnu"

@d = global i32 15, align 4
@b = global i32* @d, align 8
@a = common global i32 0, align 4

; Check that both InstCombine and InstSimplify can use computeKnownBits to
; realize that:
;   ((2072 >> (L == 0)) >> 7) & 1
; is always zero.
define signext i32 @main() #1 {
; CHECK-LABEL: @main(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32*, i32** @b, align 8
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP0]], align 4
; CHECK-NEXT:    ret i32 [[TMP1]]
;
entry:
  %0 = load i32*, i32** @b, align 8
  %1 = load i32, i32* @a, align 4
  %lnot = icmp eq i32 %1, 0
  %lnot.ext = zext i1 %lnot to i32
  %shr.i = lshr i32 2072, %lnot.ext
  %call.lobit = lshr i32 %shr.i, 7
  %2 = and i32 %call.lobit, 1
  %3 = load i32, i32* %0, align 4
  %or = or i32 %2, %3
  store i32 %or, i32* %0, align 4
  %4 = load i32, i32* @a, align 4
  %lnot.1 = icmp eq i32 %4, 0
  %lnot.ext.1 = zext i1 %lnot.1 to i32
  %shr.i.1 = lshr i32 2072, %lnot.ext.1
  %call.lobit.1 = lshr i32 %shr.i.1, 7
  %5 = and i32 %call.lobit.1, 1
  %or.1 = or i32 %5, %or
  store i32 %or.1, i32* %0, align 4
  ret i32 %or.1

}

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind }

