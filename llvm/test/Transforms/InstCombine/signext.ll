; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "n8:16:32:64"

declare void @use(i32)

define i32 @sextinreg(i32 %x) {
; CHECK-LABEL: @sextinreg(
; CHECK-NEXT:    [[SEXT:%.*]] = shl i32 [[X:%.*]], 16
; CHECK-NEXT:    [[T3:%.*]] = ashr exact i32 [[SEXT]], 16
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t1 = and i32 %x, 65535
  %t2 = xor i32 %t1, -32768
  %t3 = add i32 %t2, 32768
  ret i32 %t3
}

define i32 @sextinreg_extra_use(i32 %x) {
; CHECK-LABEL: @sextinreg_extra_use(
; CHECK-NEXT:    [[T1:%.*]] = and i32 [[X:%.*]], 65535
; CHECK-NEXT:    [[T2:%.*]] = xor i32 [[T1]], -32768
; CHECK-NEXT:    call void @use(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = add nsw i32 [[T2]], 32768
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t1 = and i32 %x, 65535
  %t2 = xor i32 %t1, -32768
  call void @use(i32 %t2)
  %t3 = add i32 %t2, 32768
  ret i32 %t3
}

define <2 x i32> @sextinreg_splat(<2 x i32> %x) {
; CHECK-LABEL: @sextinreg_splat(
; CHECK-NEXT:    [[SEXT:%.*]] = shl <2 x i32> [[X:%.*]], <i32 16, i32 16>
; CHECK-NEXT:    [[T3:%.*]] = ashr exact <2 x i32> [[SEXT]], <i32 16, i32 16>
; CHECK-NEXT:    ret <2 x i32> [[T3]]
;
  %t1 = and <2 x i32> %x, <i32 65535, i32 65535>
  %t2 = xor <2 x i32> %t1, <i32 -32768, i32 -32768>
  %t3 = add <2 x i32> %t2, <i32 32768, i32 32768>
  ret <2 x i32> %t3
}

define i32 @sextinreg_alt(i32 %x) {
; CHECK-LABEL: @sextinreg_alt(
; CHECK-NEXT:    [[SEXT:%.*]] = shl i32 [[X:%.*]], 16
; CHECK-NEXT:    [[T3:%.*]] = ashr exact i32 [[SEXT]], 16
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t1 = and i32 %x, 65535
  %t2 = xor i32 %t1, 32768
  %t3 = add i32 %t2, -32768
  ret i32 %t3
}

define <2 x i32> @sextinreg_alt_splat(<2 x i32> %x) {
; CHECK-LABEL: @sextinreg_alt_splat(
; CHECK-NEXT:    [[SEXT:%.*]] = shl <2 x i32> [[X:%.*]], <i32 16, i32 16>
; CHECK-NEXT:    [[T3:%.*]] = ashr exact <2 x i32> [[SEXT]], <i32 16, i32 16>
; CHECK-NEXT:    ret <2 x i32> [[T3]]
;
  %t1 = and <2 x i32> %x, <i32 65535, i32 65535>
  %t2 = xor <2 x i32> %t1, <i32 32768, i32 32768>
  %t3 = add <2 x i32> %t2, <i32 -32768, i32 -32768>
  ret <2 x i32> %t3
}

define i32 @sext(i16 %P) {
; CHECK-LABEL: @sext(
; CHECK-NEXT:    [[T5:%.*]] = sext i16 [[P:%.*]] to i32
; CHECK-NEXT:    ret i32 [[T5]]
;
  %t1 = zext i16 %P to i32
  %t4 = xor i32 %t1, 32768
  %t5 = add i32 %t4, -32768
  ret i32 %t5
}

define i32 @sext_extra_use(i16 %P) {
; CHECK-LABEL: @sext_extra_use(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i16 [[P:%.*]], -32768
; CHECK-NEXT:    [[T4:%.*]] = zext i16 [[TMP1]] to i32
; CHECK-NEXT:    call void @use(i32 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = sext i16 [[P]] to i32
; CHECK-NEXT:    ret i32 [[T5]]
;
  %t1 = zext i16 %P to i32
  %t4 = xor i32 %t1, 32768
  call void @use(i32 %t4)
  %t5 = add i32 %t4, -32768
  ret i32 %t5
}

define <2 x i32> @sext_splat(<2 x i16> %P) {
; CHECK-LABEL: @sext_splat(
; CHECK-NEXT:    [[T5:%.*]] = sext <2 x i16> [[P:%.*]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[T5]]
;
  %t1 = zext <2 x i16> %P to <2 x i32>
  %t4 = xor <2 x i32> %t1, <i32 32768, i32 32768>
  %t5 = add <2 x i32> %t4, <i32 -32768, i32 -32768>
  ret <2 x i32> %t5
}

define i32 @sextinreg2(i32 %x) {
; CHECK-LABEL: @sextinreg2(
; CHECK-NEXT:    [[SEXT:%.*]] = shl i32 [[X:%.*]], 24
; CHECK-NEXT:    [[T3:%.*]] = ashr exact i32 [[SEXT]], 24
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t1 = and i32 %x, 255
  %t2 = xor i32 %t1, 128
  %t3 = add i32 %t2, -128
  ret i32 %t3
}

define <2 x i32> @sextinreg2_splat(<2 x i32> %x) {
; CHECK-LABEL: @sextinreg2_splat(
; CHECK-NEXT:    [[SEXT:%.*]] = shl <2 x i32> [[X:%.*]], <i32 24, i32 24>
; CHECK-NEXT:    [[T3:%.*]] = ashr exact <2 x i32> [[SEXT]], <i32 24, i32 24>
; CHECK-NEXT:    ret <2 x i32> [[T3]]
;
  %t1 = and <2 x i32> %x, <i32 255, i32 255>
  %t2 = xor <2 x i32> %t1, <i32 128, i32 128>
  %t3 = add <2 x i32> %t2, <i32 -128, i32 -128>
  ret <2 x i32> %t3
}

define i32 @test5(i32 %x) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[T2:%.*]] = shl i32 [[X:%.*]], 16
; CHECK-NEXT:    [[T4:%.*]] = ashr exact i32 [[T2]], 16
; CHECK-NEXT:    ret i32 [[T4]]
;
  %t2 = shl i32 %x, 16
  %t4 = ashr i32 %t2, 16
  ret i32 %t4
}

;  If the shift amount equals the difference in width of the destination
;  and source scalar types:
;  ashr (shl (zext X), C), C --> sext X

define i32 @test6(i16 %P) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[T5:%.*]] = sext i16 [[P:%.*]] to i32
; CHECK-NEXT:    ret i32 [[T5]]
;
  %t1 = zext i16 %P to i32
  %sext1 = shl i32 %t1, 16
  %t5 = ashr i32 %sext1, 16
  ret i32 %t5
}

; Vectors should get the same fold as above.

define <2 x i32> @test6_splat_vec(<2 x i12> %P) {
; CHECK-LABEL: @test6_splat_vec(
; CHECK-NEXT:    [[ASHR:%.*]] = sext <2 x i12> [[P:%.*]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[ASHR]]
;
  %z = zext <2 x i12> %P to <2 x i32>
  %shl = shl <2 x i32> %z, <i32 20, i32 20>
  %ashr = ashr <2 x i32> %shl, <i32 20, i32 20>
  ret <2 x i32> %ashr
}

define i32 @ashr(i32 %x) {
; CHECK-LABEL: @ashr(
; CHECK-NEXT:    [[SUB:%.*]] = ashr i32 [[X:%.*]], 5
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %shr = lshr i32 %x, 5
  %xor = xor i32 %shr, 67108864
  %sub = add i32 %xor, -67108864
  ret i32 %sub
}

define <2 x i32> @ashr_splat(<2 x i32> %x) {
; CHECK-LABEL: @ashr_splat(
; CHECK-NEXT:    [[SUB:%.*]] = ashr <2 x i32> [[X:%.*]], <i32 5, i32 5>
; CHECK-NEXT:    ret <2 x i32> [[SUB]]
;
  %shr = lshr <2 x i32> %x, <i32 5, i32 5>
  %xor = xor <2 x i32> %shr, <i32 67108864, i32 67108864>
  %sub = add <2 x i32> %xor, <i32 -67108864, i32 -67108864>
  ret <2 x i32> %sub
}
