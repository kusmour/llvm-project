; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+v -target-abi=lp64d -verify-machineinstrs < %s | FileCheck %s

declare <vscale x 1 x double> @llvm.vp.fmul.nxv1f64(<vscale x 1 x double> %x, <vscale x 1 x double> %y, <vscale x 1 x i1> %m, i32 %vl)
declare <vscale x 1 x double> @llvm.vp.fadd.nxv1f64(<vscale x 1 x double> %x, <vscale x 1 x double> %y, <vscale x 1 x i1> %m, i32 %vl)

; (fadd (fmul x, y), z)) -> (fma x, y, z)
define <vscale x 1 x double> @fma(<vscale x 1 x double> %x, <vscale x 1 x double> %y, <vscale x 1 x double> %z, <vscale x 1 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: fma:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfmadd.vv v9, v8, v10, v0.t
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %1 = call fast <vscale x 1 x double> @llvm.vp.fmul.nxv1f64(<vscale x 1 x double> %x, <vscale x 1 x double> %y, <vscale x 1 x i1> %m, i32 %vl)
  %2 = call fast <vscale x 1 x double> @llvm.vp.fadd.nxv1f64(<vscale x 1 x double> %1, <vscale x 1 x double> %z, <vscale x 1 x i1> %m, i32 %vl)
  ret <vscale x 1 x double> %2
}

; (fadd z, (fmul x, y))) -> (fma x, y, z)
define <vscale x 1 x double> @fma_commute(<vscale x 1 x double> %x, <vscale x 1 x double> %y, <vscale x 1 x double> %z, <vscale x 1 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: fma_commute:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfmadd.vv v9, v8, v10, v0.t
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %1 = call fast <vscale x 1 x double> @llvm.vp.fmul.nxv1f64(<vscale x 1 x double> %x, <vscale x 1 x double> %y, <vscale x 1 x i1> %m, i32 %vl)
  %2 = call fast <vscale x 1 x double> @llvm.vp.fadd.nxv1f64(<vscale x 1 x double> %z, <vscale x 1 x double> %1, <vscale x 1 x i1> %m, i32 %vl)
  ret <vscale x 1 x double> %2
}

; Test operand with true mask
define <vscale x 1 x double> @fma_true(<vscale x 1 x double> %x, <vscale x 1 x double> %y, <vscale x 1 x double> %z, <vscale x 1 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: fma_true:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfmadd.vv v9, v8, v10, v0.t
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %1 = call fast <vscale x 1 x double> @llvm.vp.fmul.nxv1f64(<vscale x 1 x double> %x, <vscale x 1 x double> %y, <vscale x 1 x i1> splat (i1 true), i32 %vl)
  %2 = call fast <vscale x 1 x double> @llvm.vp.fadd.nxv1f64(<vscale x 1 x double> %1, <vscale x 1 x double> %z, <vscale x 1 x i1> %m, i32 %vl)
  ret <vscale x 1 x double> %2
}

; Test operand with normal opcode.
define <vscale x 1 x double> @fma_nonvp(<vscale x 1 x double> %x, <vscale x 1 x double> %y, <vscale x 1 x double> %z, <vscale x 1 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: fma_nonvp:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfmadd.vv v9, v8, v10, v0.t
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %1 = fmul fast <vscale x 1 x double> %x, %y
  %2 = call fast <vscale x 1 x double> @llvm.vp.fadd.nxv1f64(<vscale x 1 x double> %1, <vscale x 1 x double> %z, <vscale x 1 x i1> %m, i32 %vl)
  ret <vscale x 1 x double> %2
}

define <vscale x 1 x double> @fma_reassociate(<vscale x 1 x double> %a, <vscale x 1 x double> %b, <vscale x 1 x double> %c, <vscale x 1 x double> %d, <vscale x 1 x double> %e, <vscale x 1 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: fma_reassociate:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfmadd.vv v11, v10, v12, v0.t
; CHECK-NEXT:    vfmadd.vv v9, v8, v11, v0.t
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %1 = call fast <vscale x 1 x double> @llvm.vp.fmul.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, <vscale x 1 x i1> %m, i32 %vl)
  %2 = call fast <vscale x 1 x double> @llvm.vp.fmul.nxv1f64(<vscale x 1 x double> %c, <vscale x 1 x double> %d, <vscale x 1 x i1> %m, i32 %vl)
  %3 = call fast <vscale x 1 x double> @llvm.vp.fadd.nxv1f64(<vscale x 1 x double> %1, <vscale x 1 x double> %2, <vscale x 1 x i1> %m, i32 %vl)
  %4 = call fast <vscale x 1 x double> @llvm.vp.fadd.nxv1f64(<vscale x 1 x double> %3, <vscale x 1 x double> %e, <vscale x 1 x i1> %m, i32 %vl)
  ret <vscale x 1 x double> %4
}
