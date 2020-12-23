; RUN: llc -mtriple=riscv64 -mattr=+experimental-v,+d,+experimental-zfh,+f,+d -verify-machineinstrs \
; RUN:   --riscv-no-aliases < %s | FileCheck %s
declare <vscale x 1 x i64> @llvm.riscv.vleff.nxv1i64(
  <vscale x 1 x i64>*,
  i64);

define <vscale x 1 x i64> @intrinsic_vleff_v_nxv1i64_nxv1i64(<vscale x 1 x i64>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv1i64_nxv1i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 1 x i64> @llvm.riscv.vleff.nxv1i64(
    <vscale x 1 x i64>* %0,
    i64 %1)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 1 x i64> @llvm.riscv.vleff.mask.nxv1i64(
  <vscale x 1 x i64>,
  <vscale x 1 x i64>*,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i64> @intrinsic_vleff_mask_v_nxv1i64_nxv1i64(<vscale x 1 x i64> %0, <vscale x 1 x i64>* %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv1i64_nxv1i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 1 x i64> @llvm.riscv.vleff.mask.nxv1i64(
    <vscale x 1 x i64> %0,
    <vscale x 1 x i64>* %1,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vleff.nxv2i64(
  <vscale x 2 x i64>*,
  i64);

define <vscale x 2 x i64> @intrinsic_vleff_v_nxv2i64_nxv2i64(<vscale x 2 x i64>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv2i64_nxv2i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 2 x i64> @llvm.riscv.vleff.nxv2i64(
    <vscale x 2 x i64>* %0,
    i64 %1)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vleff.mask.nxv2i64(
  <vscale x 2 x i64>,
  <vscale x 2 x i64>*,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i64> @intrinsic_vleff_mask_v_nxv2i64_nxv2i64(<vscale x 2 x i64> %0, <vscale x 2 x i64>* %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv2i64_nxv2i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 2 x i64> @llvm.riscv.vleff.mask.nxv2i64(
    <vscale x 2 x i64> %0,
    <vscale x 2 x i64>* %1,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vleff.nxv4i64(
  <vscale x 4 x i64>*,
  i64);

define <vscale x 4 x i64> @intrinsic_vleff_v_nxv4i64_nxv4i64(<vscale x 4 x i64>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv4i64_nxv4i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 4 x i64> @llvm.riscv.vleff.nxv4i64(
    <vscale x 4 x i64>* %0,
    i64 %1)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vleff.mask.nxv4i64(
  <vscale x 4 x i64>,
  <vscale x 4 x i64>*,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i64> @intrinsic_vleff_mask_v_nxv4i64_nxv4i64(<vscale x 4 x i64> %0, <vscale x 4 x i64>* %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv4i64_nxv4i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 4 x i64> @llvm.riscv.vleff.mask.nxv4i64(
    <vscale x 4 x i64> %0,
    <vscale x 4 x i64>* %1,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vleff.nxv8i64(
  <vscale x 8 x i64>*,
  i64);

define <vscale x 8 x i64> @intrinsic_vleff_v_nxv8i64_nxv8i64(<vscale x 8 x i64>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv8i64_nxv8i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m8,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 8 x i64> @llvm.riscv.vleff.nxv8i64(
    <vscale x 8 x i64>* %0,
    i64 %1)

  ret <vscale x 8 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vleff.mask.nxv8i64(
  <vscale x 8 x i64>,
  <vscale x 8 x i64>*,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i64> @intrinsic_vleff_mask_v_nxv8i64_nxv8i64(<vscale x 8 x i64> %0, <vscale x 8 x i64>* %1, <vscale x 8 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv8i64_nxv8i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m8,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 8 x i64> @llvm.riscv.vleff.mask.nxv8i64(
    <vscale x 8 x i64> %0,
    <vscale x 8 x i64>* %1,
    <vscale x 8 x i1> %2,
    i64 %3)

  ret <vscale x 8 x i64> %a
}

declare <vscale x 1 x double> @llvm.riscv.vleff.nxv1f64(
  <vscale x 1 x double>*,
  i64);

define <vscale x 1 x double> @intrinsic_vleff_v_nxv1f64_nxv1f64(<vscale x 1 x double>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv1f64_nxv1f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 1 x double> @llvm.riscv.vleff.nxv1f64(
    <vscale x 1 x double>* %0,
    i64 %1)

  ret <vscale x 1 x double> %a
}

declare <vscale x 1 x double> @llvm.riscv.vleff.mask.nxv1f64(
  <vscale x 1 x double>,
  <vscale x 1 x double>*,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x double> @intrinsic_vleff_mask_v_nxv1f64_nxv1f64(<vscale x 1 x double> %0, <vscale x 1 x double>* %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv1f64_nxv1f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 1 x double> @llvm.riscv.vleff.mask.nxv1f64(
    <vscale x 1 x double> %0,
    <vscale x 1 x double>* %1,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vleff.nxv2f64(
  <vscale x 2 x double>*,
  i64);

define <vscale x 2 x double> @intrinsic_vleff_v_nxv2f64_nxv2f64(<vscale x 2 x double>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv2f64_nxv2f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 2 x double> @llvm.riscv.vleff.nxv2f64(
    <vscale x 2 x double>* %0,
    i64 %1)

  ret <vscale x 2 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vleff.mask.nxv2f64(
  <vscale x 2 x double>,
  <vscale x 2 x double>*,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x double> @intrinsic_vleff_mask_v_nxv2f64_nxv2f64(<vscale x 2 x double> %0, <vscale x 2 x double>* %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv2f64_nxv2f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 2 x double> @llvm.riscv.vleff.mask.nxv2f64(
    <vscale x 2 x double> %0,
    <vscale x 2 x double>* %1,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vleff.nxv4f64(
  <vscale x 4 x double>*,
  i64);

define <vscale x 4 x double> @intrinsic_vleff_v_nxv4f64_nxv4f64(<vscale x 4 x double>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv4f64_nxv4f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 4 x double> @llvm.riscv.vleff.nxv4f64(
    <vscale x 4 x double>* %0,
    i64 %1)

  ret <vscale x 4 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vleff.mask.nxv4f64(
  <vscale x 4 x double>,
  <vscale x 4 x double>*,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x double> @intrinsic_vleff_mask_v_nxv4f64_nxv4f64(<vscale x 4 x double> %0, <vscale x 4 x double>* %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv4f64_nxv4f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 4 x double> @llvm.riscv.vleff.mask.nxv4f64(
    <vscale x 4 x double> %0,
    <vscale x 4 x double>* %1,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vleff.nxv8f64(
  <vscale x 8 x double>*,
  i64);

define <vscale x 8 x double> @intrinsic_vleff_v_nxv8f64_nxv8f64(<vscale x 8 x double>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv8f64_nxv8f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m8,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 8 x double> @llvm.riscv.vleff.nxv8f64(
    <vscale x 8 x double>* %0,
    i64 %1)

  ret <vscale x 8 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vleff.mask.nxv8f64(
  <vscale x 8 x double>,
  <vscale x 8 x double>*,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x double> @intrinsic_vleff_mask_v_nxv8f64_nxv8f64(<vscale x 8 x double> %0, <vscale x 8 x double>* %1, <vscale x 8 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv8f64_nxv8f64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m8,ta,mu
; CHECK:       vle64ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 8 x double> @llvm.riscv.vleff.mask.nxv8f64(
    <vscale x 8 x double> %0,
    <vscale x 8 x double>* %1,
    <vscale x 8 x i1> %2,
    i64 %3)

  ret <vscale x 8 x double> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vleff.nxv1i32(
  <vscale x 1 x i32>*,
  i64);

define <vscale x 1 x i32> @intrinsic_vleff_v_nxv1i32_nxv1i32(<vscale x 1 x i32>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv1i32_nxv1i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 1 x i32> @llvm.riscv.vleff.nxv1i32(
    <vscale x 1 x i32>* %0,
    i64 %1)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vleff.mask.nxv1i32(
  <vscale x 1 x i32>,
  <vscale x 1 x i32>*,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i32> @intrinsic_vleff_mask_v_nxv1i32_nxv1i32(<vscale x 1 x i32> %0, <vscale x 1 x i32>* %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv1i32_nxv1i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 1 x i32> @llvm.riscv.vleff.mask.nxv1i32(
    <vscale x 1 x i32> %0,
    <vscale x 1 x i32>* %1,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vleff.nxv2i32(
  <vscale x 2 x i32>*,
  i64);

define <vscale x 2 x i32> @intrinsic_vleff_v_nxv2i32_nxv2i32(<vscale x 2 x i32>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv2i32_nxv2i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 2 x i32> @llvm.riscv.vleff.nxv2i32(
    <vscale x 2 x i32>* %0,
    i64 %1)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vleff.mask.nxv2i32(
  <vscale x 2 x i32>,
  <vscale x 2 x i32>*,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i32> @intrinsic_vleff_mask_v_nxv2i32_nxv2i32(<vscale x 2 x i32> %0, <vscale x 2 x i32>* %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv2i32_nxv2i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 2 x i32> @llvm.riscv.vleff.mask.nxv2i32(
    <vscale x 2 x i32> %0,
    <vscale x 2 x i32>* %1,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vleff.nxv4i32(
  <vscale x 4 x i32>*,
  i64);

define <vscale x 4 x i32> @intrinsic_vleff_v_nxv4i32_nxv4i32(<vscale x 4 x i32>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv4i32_nxv4i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 4 x i32> @llvm.riscv.vleff.nxv4i32(
    <vscale x 4 x i32>* %0,
    i64 %1)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vleff.mask.nxv4i32(
  <vscale x 4 x i32>,
  <vscale x 4 x i32>*,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i32> @intrinsic_vleff_mask_v_nxv4i32_nxv4i32(<vscale x 4 x i32> %0, <vscale x 4 x i32>* %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv4i32_nxv4i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 4 x i32> @llvm.riscv.vleff.mask.nxv4i32(
    <vscale x 4 x i32> %0,
    <vscale x 4 x i32>* %1,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vleff.nxv8i32(
  <vscale x 8 x i32>*,
  i64);

define <vscale x 8 x i32> @intrinsic_vleff_v_nxv8i32_nxv8i32(<vscale x 8 x i32>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv8i32_nxv8i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 8 x i32> @llvm.riscv.vleff.nxv8i32(
    <vscale x 8 x i32>* %0,
    i64 %1)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vleff.mask.nxv8i32(
  <vscale x 8 x i32>,
  <vscale x 8 x i32>*,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i32> @intrinsic_vleff_mask_v_nxv8i32_nxv8i32(<vscale x 8 x i32> %0, <vscale x 8 x i32>* %1, <vscale x 8 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv8i32_nxv8i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 8 x i32> @llvm.riscv.vleff.mask.nxv8i32(
    <vscale x 8 x i32> %0,
    <vscale x 8 x i32>* %1,
    <vscale x 8 x i1> %2,
    i64 %3)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vleff.nxv16i32(
  <vscale x 16 x i32>*,
  i64);

define <vscale x 16 x i32> @intrinsic_vleff_v_nxv16i32_nxv16i32(<vscale x 16 x i32>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv16i32_nxv16i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m8,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 16 x i32> @llvm.riscv.vleff.nxv16i32(
    <vscale x 16 x i32>* %0,
    i64 %1)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vleff.mask.nxv16i32(
  <vscale x 16 x i32>,
  <vscale x 16 x i32>*,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i32> @intrinsic_vleff_mask_v_nxv16i32_nxv16i32(<vscale x 16 x i32> %0, <vscale x 16 x i32>* %1, <vscale x 16 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv16i32_nxv16i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m8,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 16 x i32> @llvm.riscv.vleff.mask.nxv16i32(
    <vscale x 16 x i32> %0,
    <vscale x 16 x i32>* %1,
    <vscale x 16 x i1> %2,
    i64 %3)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 1 x float> @llvm.riscv.vleff.nxv1f32(
  <vscale x 1 x float>*,
  i64);

define <vscale x 1 x float> @intrinsic_vleff_v_nxv1f32_nxv1f32(<vscale x 1 x float>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv1f32_nxv1f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 1 x float> @llvm.riscv.vleff.nxv1f32(
    <vscale x 1 x float>* %0,
    i64 %1)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vleff.mask.nxv1f32(
  <vscale x 1 x float>,
  <vscale x 1 x float>*,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x float> @intrinsic_vleff_mask_v_nxv1f32_nxv1f32(<vscale x 1 x float> %0, <vscale x 1 x float>* %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv1f32_nxv1f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 1 x float> @llvm.riscv.vleff.mask.nxv1f32(
    <vscale x 1 x float> %0,
    <vscale x 1 x float>* %1,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vleff.nxv2f32(
  <vscale x 2 x float>*,
  i64);

define <vscale x 2 x float> @intrinsic_vleff_v_nxv2f32_nxv2f32(<vscale x 2 x float>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv2f32_nxv2f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 2 x float> @llvm.riscv.vleff.nxv2f32(
    <vscale x 2 x float>* %0,
    i64 %1)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vleff.mask.nxv2f32(
  <vscale x 2 x float>,
  <vscale x 2 x float>*,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x float> @intrinsic_vleff_mask_v_nxv2f32_nxv2f32(<vscale x 2 x float> %0, <vscale x 2 x float>* %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv2f32_nxv2f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 2 x float> @llvm.riscv.vleff.mask.nxv2f32(
    <vscale x 2 x float> %0,
    <vscale x 2 x float>* %1,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vleff.nxv4f32(
  <vscale x 4 x float>*,
  i64);

define <vscale x 4 x float> @intrinsic_vleff_v_nxv4f32_nxv4f32(<vscale x 4 x float>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv4f32_nxv4f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 4 x float> @llvm.riscv.vleff.nxv4f32(
    <vscale x 4 x float>* %0,
    i64 %1)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vleff.mask.nxv4f32(
  <vscale x 4 x float>,
  <vscale x 4 x float>*,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x float> @intrinsic_vleff_mask_v_nxv4f32_nxv4f32(<vscale x 4 x float> %0, <vscale x 4 x float>* %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv4f32_nxv4f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 4 x float> @llvm.riscv.vleff.mask.nxv4f32(
    <vscale x 4 x float> %0,
    <vscale x 4 x float>* %1,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vleff.nxv8f32(
  <vscale x 8 x float>*,
  i64);

define <vscale x 8 x float> @intrinsic_vleff_v_nxv8f32_nxv8f32(<vscale x 8 x float>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv8f32_nxv8f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 8 x float> @llvm.riscv.vleff.nxv8f32(
    <vscale x 8 x float>* %0,
    i64 %1)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vleff.mask.nxv8f32(
  <vscale x 8 x float>,
  <vscale x 8 x float>*,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x float> @intrinsic_vleff_mask_v_nxv8f32_nxv8f32(<vscale x 8 x float> %0, <vscale x 8 x float>* %1, <vscale x 8 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv8f32_nxv8f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 8 x float> @llvm.riscv.vleff.mask.nxv8f32(
    <vscale x 8 x float> %0,
    <vscale x 8 x float>* %1,
    <vscale x 8 x i1> %2,
    i64 %3)

  ret <vscale x 8 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vleff.nxv16f32(
  <vscale x 16 x float>*,
  i64);

define <vscale x 16 x float> @intrinsic_vleff_v_nxv16f32_nxv16f32(<vscale x 16 x float>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv16f32_nxv16f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m8,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 16 x float> @llvm.riscv.vleff.nxv16f32(
    <vscale x 16 x float>* %0,
    i64 %1)

  ret <vscale x 16 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vleff.mask.nxv16f32(
  <vscale x 16 x float>,
  <vscale x 16 x float>*,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x float> @intrinsic_vleff_mask_v_nxv16f32_nxv16f32(<vscale x 16 x float> %0, <vscale x 16 x float>* %1, <vscale x 16 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv16f32_nxv16f32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m8,ta,mu
; CHECK:       vle32ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 16 x float> @llvm.riscv.vleff.mask.nxv16f32(
    <vscale x 16 x float> %0,
    <vscale x 16 x float>* %1,
    <vscale x 16 x i1> %2,
    i64 %3)

  ret <vscale x 16 x float> %a
}

declare <vscale x 1 x i16> @llvm.riscv.vleff.nxv1i16(
  <vscale x 1 x i16>*,
  i64);

define <vscale x 1 x i16> @intrinsic_vleff_v_nxv1i16_nxv1i16(<vscale x 1 x i16>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv1i16_nxv1i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 1 x i16> @llvm.riscv.vleff.nxv1i16(
    <vscale x 1 x i16>* %0,
    i64 %1)

  ret <vscale x 1 x i16> %a
}

declare <vscale x 1 x i16> @llvm.riscv.vleff.mask.nxv1i16(
  <vscale x 1 x i16>,
  <vscale x 1 x i16>*,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i16> @intrinsic_vleff_mask_v_nxv1i16_nxv1i16(<vscale x 1 x i16> %0, <vscale x 1 x i16>* %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv1i16_nxv1i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 1 x i16> @llvm.riscv.vleff.mask.nxv1i16(
    <vscale x 1 x i16> %0,
    <vscale x 1 x i16>* %1,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x i16> %a
}

declare <vscale x 2 x i16> @llvm.riscv.vleff.nxv2i16(
  <vscale x 2 x i16>*,
  i64);

define <vscale x 2 x i16> @intrinsic_vleff_v_nxv2i16_nxv2i16(<vscale x 2 x i16>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv2i16_nxv2i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 2 x i16> @llvm.riscv.vleff.nxv2i16(
    <vscale x 2 x i16>* %0,
    i64 %1)

  ret <vscale x 2 x i16> %a
}

declare <vscale x 2 x i16> @llvm.riscv.vleff.mask.nxv2i16(
  <vscale x 2 x i16>,
  <vscale x 2 x i16>*,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i16> @intrinsic_vleff_mask_v_nxv2i16_nxv2i16(<vscale x 2 x i16> %0, <vscale x 2 x i16>* %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv2i16_nxv2i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 2 x i16> @llvm.riscv.vleff.mask.nxv2i16(
    <vscale x 2 x i16> %0,
    <vscale x 2 x i16>* %1,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x i16> %a
}

declare <vscale x 4 x i16> @llvm.riscv.vleff.nxv4i16(
  <vscale x 4 x i16>*,
  i64);

define <vscale x 4 x i16> @intrinsic_vleff_v_nxv4i16_nxv4i16(<vscale x 4 x i16>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv4i16_nxv4i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 4 x i16> @llvm.riscv.vleff.nxv4i16(
    <vscale x 4 x i16>* %0,
    i64 %1)

  ret <vscale x 4 x i16> %a
}

declare <vscale x 4 x i16> @llvm.riscv.vleff.mask.nxv4i16(
  <vscale x 4 x i16>,
  <vscale x 4 x i16>*,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i16> @intrinsic_vleff_mask_v_nxv4i16_nxv4i16(<vscale x 4 x i16> %0, <vscale x 4 x i16>* %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv4i16_nxv4i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 4 x i16> @llvm.riscv.vleff.mask.nxv4i16(
    <vscale x 4 x i16> %0,
    <vscale x 4 x i16>* %1,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x i16> %a
}

declare <vscale x 8 x i16> @llvm.riscv.vleff.nxv8i16(
  <vscale x 8 x i16>*,
  i64);

define <vscale x 8 x i16> @intrinsic_vleff_v_nxv8i16_nxv8i16(<vscale x 8 x i16>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv8i16_nxv8i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 8 x i16> @llvm.riscv.vleff.nxv8i16(
    <vscale x 8 x i16>* %0,
    i64 %1)

  ret <vscale x 8 x i16> %a
}

declare <vscale x 8 x i16> @llvm.riscv.vleff.mask.nxv8i16(
  <vscale x 8 x i16>,
  <vscale x 8 x i16>*,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i16> @intrinsic_vleff_mask_v_nxv8i16_nxv8i16(<vscale x 8 x i16> %0, <vscale x 8 x i16>* %1, <vscale x 8 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv8i16_nxv8i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 8 x i16> @llvm.riscv.vleff.mask.nxv8i16(
    <vscale x 8 x i16> %0,
    <vscale x 8 x i16>* %1,
    <vscale x 8 x i1> %2,
    i64 %3)

  ret <vscale x 8 x i16> %a
}

declare <vscale x 16 x i16> @llvm.riscv.vleff.nxv16i16(
  <vscale x 16 x i16>*,
  i64);

define <vscale x 16 x i16> @intrinsic_vleff_v_nxv16i16_nxv16i16(<vscale x 16 x i16>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv16i16_nxv16i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 16 x i16> @llvm.riscv.vleff.nxv16i16(
    <vscale x 16 x i16>* %0,
    i64 %1)

  ret <vscale x 16 x i16> %a
}

declare <vscale x 16 x i16> @llvm.riscv.vleff.mask.nxv16i16(
  <vscale x 16 x i16>,
  <vscale x 16 x i16>*,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i16> @intrinsic_vleff_mask_v_nxv16i16_nxv16i16(<vscale x 16 x i16> %0, <vscale x 16 x i16>* %1, <vscale x 16 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv16i16_nxv16i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 16 x i16> @llvm.riscv.vleff.mask.nxv16i16(
    <vscale x 16 x i16> %0,
    <vscale x 16 x i16>* %1,
    <vscale x 16 x i1> %2,
    i64 %3)

  ret <vscale x 16 x i16> %a
}

declare <vscale x 32 x i16> @llvm.riscv.vleff.nxv32i16(
  <vscale x 32 x i16>*,
  i64);

define <vscale x 32 x i16> @intrinsic_vleff_v_nxv32i16_nxv32i16(<vscale x 32 x i16>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv32i16_nxv32i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m8,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 32 x i16> @llvm.riscv.vleff.nxv32i16(
    <vscale x 32 x i16>* %0,
    i64 %1)

  ret <vscale x 32 x i16> %a
}

declare <vscale x 32 x i16> @llvm.riscv.vleff.mask.nxv32i16(
  <vscale x 32 x i16>,
  <vscale x 32 x i16>*,
  <vscale x 32 x i1>,
  i64);

define <vscale x 32 x i16> @intrinsic_vleff_mask_v_nxv32i16_nxv32i16(<vscale x 32 x i16> %0, <vscale x 32 x i16>* %1, <vscale x 32 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv32i16_nxv32i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m8,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 32 x i16> @llvm.riscv.vleff.mask.nxv32i16(
    <vscale x 32 x i16> %0,
    <vscale x 32 x i16>* %1,
    <vscale x 32 x i1> %2,
    i64 %3)

  ret <vscale x 32 x i16> %a
}

declare <vscale x 1 x half> @llvm.riscv.vleff.nxv1f16(
  <vscale x 1 x half>*,
  i64);

define <vscale x 1 x half> @intrinsic_vleff_v_nxv1f16_nxv1f16(<vscale x 1 x half>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv1f16_nxv1f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 1 x half> @llvm.riscv.vleff.nxv1f16(
    <vscale x 1 x half>* %0,
    i64 %1)

  ret <vscale x 1 x half> %a
}

declare <vscale x 1 x half> @llvm.riscv.vleff.mask.nxv1f16(
  <vscale x 1 x half>,
  <vscale x 1 x half>*,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x half> @intrinsic_vleff_mask_v_nxv1f16_nxv1f16(<vscale x 1 x half> %0, <vscale x 1 x half>* %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv1f16_nxv1f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 1 x half> @llvm.riscv.vleff.mask.nxv1f16(
    <vscale x 1 x half> %0,
    <vscale x 1 x half>* %1,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vleff.nxv2f16(
  <vscale x 2 x half>*,
  i64);

define <vscale x 2 x half> @intrinsic_vleff_v_nxv2f16_nxv2f16(<vscale x 2 x half>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv2f16_nxv2f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 2 x half> @llvm.riscv.vleff.nxv2f16(
    <vscale x 2 x half>* %0,
    i64 %1)

  ret <vscale x 2 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vleff.mask.nxv2f16(
  <vscale x 2 x half>,
  <vscale x 2 x half>*,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x half> @intrinsic_vleff_mask_v_nxv2f16_nxv2f16(<vscale x 2 x half> %0, <vscale x 2 x half>* %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv2f16_nxv2f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 2 x half> @llvm.riscv.vleff.mask.nxv2f16(
    <vscale x 2 x half> %0,
    <vscale x 2 x half>* %1,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vleff.nxv4f16(
  <vscale x 4 x half>*,
  i64);

define <vscale x 4 x half> @intrinsic_vleff_v_nxv4f16_nxv4f16(<vscale x 4 x half>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv4f16_nxv4f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 4 x half> @llvm.riscv.vleff.nxv4f16(
    <vscale x 4 x half>* %0,
    i64 %1)

  ret <vscale x 4 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vleff.mask.nxv4f16(
  <vscale x 4 x half>,
  <vscale x 4 x half>*,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x half> @intrinsic_vleff_mask_v_nxv4f16_nxv4f16(<vscale x 4 x half> %0, <vscale x 4 x half>* %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv4f16_nxv4f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 4 x half> @llvm.riscv.vleff.mask.nxv4f16(
    <vscale x 4 x half> %0,
    <vscale x 4 x half>* %1,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vleff.nxv8f16(
  <vscale x 8 x half>*,
  i64);

define <vscale x 8 x half> @intrinsic_vleff_v_nxv8f16_nxv8f16(<vscale x 8 x half>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv8f16_nxv8f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 8 x half> @llvm.riscv.vleff.nxv8f16(
    <vscale x 8 x half>* %0,
    i64 %1)

  ret <vscale x 8 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vleff.mask.nxv8f16(
  <vscale x 8 x half>,
  <vscale x 8 x half>*,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x half> @intrinsic_vleff_mask_v_nxv8f16_nxv8f16(<vscale x 8 x half> %0, <vscale x 8 x half>* %1, <vscale x 8 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv8f16_nxv8f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 8 x half> @llvm.riscv.vleff.mask.nxv8f16(
    <vscale x 8 x half> %0,
    <vscale x 8 x half>* %1,
    <vscale x 8 x i1> %2,
    i64 %3)

  ret <vscale x 8 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vleff.nxv16f16(
  <vscale x 16 x half>*,
  i64);

define <vscale x 16 x half> @intrinsic_vleff_v_nxv16f16_nxv16f16(<vscale x 16 x half>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv16f16_nxv16f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 16 x half> @llvm.riscv.vleff.nxv16f16(
    <vscale x 16 x half>* %0,
    i64 %1)

  ret <vscale x 16 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vleff.mask.nxv16f16(
  <vscale x 16 x half>,
  <vscale x 16 x half>*,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x half> @intrinsic_vleff_mask_v_nxv16f16_nxv16f16(<vscale x 16 x half> %0, <vscale x 16 x half>* %1, <vscale x 16 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv16f16_nxv16f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 16 x half> @llvm.riscv.vleff.mask.nxv16f16(
    <vscale x 16 x half> %0,
    <vscale x 16 x half>* %1,
    <vscale x 16 x i1> %2,
    i64 %3)

  ret <vscale x 16 x half> %a
}

declare <vscale x 32 x half> @llvm.riscv.vleff.nxv32f16(
  <vscale x 32 x half>*,
  i64);

define <vscale x 32 x half> @intrinsic_vleff_v_nxv32f16_nxv32f16(<vscale x 32 x half>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv32f16_nxv32f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m8,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 32 x half> @llvm.riscv.vleff.nxv32f16(
    <vscale x 32 x half>* %0,
    i64 %1)

  ret <vscale x 32 x half> %a
}

declare <vscale x 32 x half> @llvm.riscv.vleff.mask.nxv32f16(
  <vscale x 32 x half>,
  <vscale x 32 x half>*,
  <vscale x 32 x i1>,
  i64);

define <vscale x 32 x half> @intrinsic_vleff_mask_v_nxv32f16_nxv32f16(<vscale x 32 x half> %0, <vscale x 32 x half>* %1, <vscale x 32 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv32f16_nxv32f16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m8,ta,mu
; CHECK:       vle16ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 32 x half> @llvm.riscv.vleff.mask.nxv32f16(
    <vscale x 32 x half> %0,
    <vscale x 32 x half>* %1,
    <vscale x 32 x i1> %2,
    i64 %3)

  ret <vscale x 32 x half> %a
}

declare <vscale x 1 x i8> @llvm.riscv.vleff.nxv1i8(
  <vscale x 1 x i8>*,
  i64);

define <vscale x 1 x i8> @intrinsic_vleff_v_nxv1i8_nxv1i8(<vscale x 1 x i8>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv1i8_nxv1i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf8,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 1 x i8> @llvm.riscv.vleff.nxv1i8(
    <vscale x 1 x i8>* %0,
    i64 %1)

  ret <vscale x 1 x i8> %a
}

declare <vscale x 1 x i8> @llvm.riscv.vleff.mask.nxv1i8(
  <vscale x 1 x i8>,
  <vscale x 1 x i8>*,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i8> @intrinsic_vleff_mask_v_nxv1i8_nxv1i8(<vscale x 1 x i8> %0, <vscale x 1 x i8>* %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv1i8_nxv1i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf8,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 1 x i8> @llvm.riscv.vleff.mask.nxv1i8(
    <vscale x 1 x i8> %0,
    <vscale x 1 x i8>* %1,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x i8> %a
}

declare <vscale x 2 x i8> @llvm.riscv.vleff.nxv2i8(
  <vscale x 2 x i8>*,
  i64);

define <vscale x 2 x i8> @intrinsic_vleff_v_nxv2i8_nxv2i8(<vscale x 2 x i8>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv2i8_nxv2i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf4,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 2 x i8> @llvm.riscv.vleff.nxv2i8(
    <vscale x 2 x i8>* %0,
    i64 %1)

  ret <vscale x 2 x i8> %a
}

declare <vscale x 2 x i8> @llvm.riscv.vleff.mask.nxv2i8(
  <vscale x 2 x i8>,
  <vscale x 2 x i8>*,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i8> @intrinsic_vleff_mask_v_nxv2i8_nxv2i8(<vscale x 2 x i8> %0, <vscale x 2 x i8>* %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv2i8_nxv2i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf4,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 2 x i8> @llvm.riscv.vleff.mask.nxv2i8(
    <vscale x 2 x i8> %0,
    <vscale x 2 x i8>* %1,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x i8> %a
}

declare <vscale x 4 x i8> @llvm.riscv.vleff.nxv4i8(
  <vscale x 4 x i8>*,
  i64);

define <vscale x 4 x i8> @intrinsic_vleff_v_nxv4i8_nxv4i8(<vscale x 4 x i8>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv4i8_nxv4i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf2,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 4 x i8> @llvm.riscv.vleff.nxv4i8(
    <vscale x 4 x i8>* %0,
    i64 %1)

  ret <vscale x 4 x i8> %a
}

declare <vscale x 4 x i8> @llvm.riscv.vleff.mask.nxv4i8(
  <vscale x 4 x i8>,
  <vscale x 4 x i8>*,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i8> @intrinsic_vleff_mask_v_nxv4i8_nxv4i8(<vscale x 4 x i8> %0, <vscale x 4 x i8>* %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv4i8_nxv4i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf2,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 4 x i8> @llvm.riscv.vleff.mask.nxv4i8(
    <vscale x 4 x i8> %0,
    <vscale x 4 x i8>* %1,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x i8> %a
}

declare <vscale x 8 x i8> @llvm.riscv.vleff.nxv8i8(
  <vscale x 8 x i8>*,
  i64);

define <vscale x 8 x i8> @intrinsic_vleff_v_nxv8i8_nxv8i8(<vscale x 8 x i8>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv8i8_nxv8i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m1,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 8 x i8> @llvm.riscv.vleff.nxv8i8(
    <vscale x 8 x i8>* %0,
    i64 %1)

  ret <vscale x 8 x i8> %a
}

declare <vscale x 8 x i8> @llvm.riscv.vleff.mask.nxv8i8(
  <vscale x 8 x i8>,
  <vscale x 8 x i8>*,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i8> @intrinsic_vleff_mask_v_nxv8i8_nxv8i8(<vscale x 8 x i8> %0, <vscale x 8 x i8>* %1, <vscale x 8 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv8i8_nxv8i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m1,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 8 x i8> @llvm.riscv.vleff.mask.nxv8i8(
    <vscale x 8 x i8> %0,
    <vscale x 8 x i8>* %1,
    <vscale x 8 x i1> %2,
    i64 %3)

  ret <vscale x 8 x i8> %a
}

declare <vscale x 16 x i8> @llvm.riscv.vleff.nxv16i8(
  <vscale x 16 x i8>*,
  i64);

define <vscale x 16 x i8> @intrinsic_vleff_v_nxv16i8_nxv16i8(<vscale x 16 x i8>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv16i8_nxv16i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m2,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 16 x i8> @llvm.riscv.vleff.nxv16i8(
    <vscale x 16 x i8>* %0,
    i64 %1)

  ret <vscale x 16 x i8> %a
}

declare <vscale x 16 x i8> @llvm.riscv.vleff.mask.nxv16i8(
  <vscale x 16 x i8>,
  <vscale x 16 x i8>*,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i8> @intrinsic_vleff_mask_v_nxv16i8_nxv16i8(<vscale x 16 x i8> %0, <vscale x 16 x i8>* %1, <vscale x 16 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv16i8_nxv16i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m2,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 16 x i8> @llvm.riscv.vleff.mask.nxv16i8(
    <vscale x 16 x i8> %0,
    <vscale x 16 x i8>* %1,
    <vscale x 16 x i1> %2,
    i64 %3)

  ret <vscale x 16 x i8> %a
}

declare <vscale x 32 x i8> @llvm.riscv.vleff.nxv32i8(
  <vscale x 32 x i8>*,
  i64);

define <vscale x 32 x i8> @intrinsic_vleff_v_nxv32i8_nxv32i8(<vscale x 32 x i8>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv32i8_nxv32i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m4,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 32 x i8> @llvm.riscv.vleff.nxv32i8(
    <vscale x 32 x i8>* %0,
    i64 %1)

  ret <vscale x 32 x i8> %a
}

declare <vscale x 32 x i8> @llvm.riscv.vleff.mask.nxv32i8(
  <vscale x 32 x i8>,
  <vscale x 32 x i8>*,
  <vscale x 32 x i1>,
  i64);

define <vscale x 32 x i8> @intrinsic_vleff_mask_v_nxv32i8_nxv32i8(<vscale x 32 x i8> %0, <vscale x 32 x i8>* %1, <vscale x 32 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv32i8_nxv32i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m4,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 32 x i8> @llvm.riscv.vleff.mask.nxv32i8(
    <vscale x 32 x i8> %0,
    <vscale x 32 x i8>* %1,
    <vscale x 32 x i1> %2,
    i64 %3)

  ret <vscale x 32 x i8> %a
}

declare <vscale x 64 x i8> @llvm.riscv.vleff.nxv64i8(
  <vscale x 64 x i8>*,
  i64);

define <vscale x 64 x i8> @intrinsic_vleff_v_nxv64i8_nxv64i8(<vscale x 64 x i8>* %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_v_nxv64i8_nxv64i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m8,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0)
  %a = call <vscale x 64 x i8> @llvm.riscv.vleff.nxv64i8(
    <vscale x 64 x i8>* %0,
    i64 %1)

  ret <vscale x 64 x i8> %a
}

declare <vscale x 64 x i8> @llvm.riscv.vleff.mask.nxv64i8(
  <vscale x 64 x i8>,
  <vscale x 64 x i8>*,
  <vscale x 64 x i1>,
  i64);

define <vscale x 64 x i8> @intrinsic_vleff_mask_v_nxv64i8_nxv64i8(<vscale x 64 x i8> %0, <vscale x 64 x i8>* %1, <vscale x 64 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vleff_mask_v_nxv64i8_nxv64i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m8,ta,mu
; CHECK:       vle8ff.v {{v[0-9]+}}, (a0), v0.t
  %a = call <vscale x 64 x i8> @llvm.riscv.vleff.mask.nxv64i8(
    <vscale x 64 x i8> %0,
    <vscale x 64 x i8>* %1,
    <vscale x 64 x i1> %2,
    i64 %3)

  ret <vscale x 64 x i8> %a
}
