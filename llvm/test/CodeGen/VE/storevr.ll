; RUN: llc < %s -mtriple=ve-unknown-unknown | FileCheck %s

@v256i64 = common dso_local local_unnamed_addr global <256 x i64> zeroinitializer, align 16

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc void @storev256i64(<256 x i64>* nocapture, <256 x i64>) {
; CHECK-LABEL: storev256i64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vst %v0,8,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  store <256 x i64> %1, <256 x i64>* %0, align 16
  ret void
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc void @storev256i64stk(<256 x i64>) {
; CHECK-LABEL: storev256i64stk:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s0, 256
; CHECK-NEXT:    lea %s1, 176(, %s11)
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vst %v0,8,%s1
; CHECK-NEXT:    or %s11, 0, %s9
  %addr = alloca <256 x i64>, align 16
  store <256 x i64> %0, <256 x i64>* %addr, align 16
  ret void
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc void @storev256i64com(<256 x i64>) {
; CHECK-LABEL: storev256i64com:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s0, v256i64@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s0, v256i64@hi(, %s0)
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vst %v0,8,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  store <256 x i64> %0, <256 x i64>* @v256i64, align 16
  ret void
}

; Function Attrs: norecurse nounwind readonly
define x86_regcallcc void @storev256f64(<256 x double>* nocapture, <256 x double>) {
; CHECK-LABEL: storev256f64:
; CHECK:       .LBB{{[0-9]+}}_2:
; CHECK-NEXT:    lea %s1, 256
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vst %v0,8,%s0
; CHECK-NEXT:    or %s11, 0, %s9
  store <256 x double> %1, <256 x double>* %0, align 16
  ret void
}
