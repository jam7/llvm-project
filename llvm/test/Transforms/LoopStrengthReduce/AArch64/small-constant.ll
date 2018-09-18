; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py

; RUN: llc < %s -mtriple=aarch64-unknown-unknown | FileCheck %s

; LSR doesn't consider bumping a pointer by constants outside the loop when the
; constants fit as immediate add operands. The constants are re-associated as an
; unfolded offset rather than a register and are not combined later with
; loop-invariant registers. For large-enough constants LSR produces better
; solutions for these test cases, with test1 switching from:
;
; The chosen solution requires 2 instructions 2 regs, with addrec cost 1, plus 1 scale cost, plus 4 imm cost, plus 1 setup cost:
;   LSR Use: Kind=ICmpZero, Offsets={0}, widest fixup type: i64
;     -7 + reg({(7 + %start)<nsw>,+,1}<nsw><%for.body>)
;   LSR Use: Kind=Address of float in addrspace(0), Offsets={0}, widest fixup type: float*
;     reg(%arr) + 4*reg({(7 + %start)<nsw>,+,1}<nsw><%for.body>)
;
; to:
;
; The chosen solution requires 1 instruction 2 regs, with addrec cost 1, plus 1 scale cost, plus 1 setup cost:
;   LSR Use: Kind=ICmpZero, Offsets={0}, widest fixup type: i64
;     reg({%start,+,1}<nsw><%for.body>)
;   LSR Use: Kind=Address of float in addrspace(0), Offsets={0}, widest fixup type: float*
;     reg((88888 + %arr)) + 4*reg({%start,+,1}<nsw><%for.body>)
;
; and test2 switching from:
;
; The chosen solution requires 2 instructions 2 regs, with addrec cost 1, plus 1 base add, plus 1 scale cost:
;   LSR Use: Kind=ICmpZero, Offsets={0}, widest fixup type: i64
;     reg({%start,+,1}<nsw><%for.body>)
;   LSR Use: Kind=Basic, Offsets={0}, widest fixup type: i64
;     reg({%start,+,1}<nsw><%for.body>)
;   LSR Use: Kind=Address of float in addrspace(0), Offsets={0}, widest fixup type: float*
;     reg(%arr) + 4*reg({%start,+,1}<nsw><%for.body>) + imm(28)
;
; to:
;
; The chosen solution requires 1 instruction 2 regs, with addrec cost 1, plus 1 scale cost, plus 1 setup cost:
;   LSR Use: Kind=ICmpZero, Offsets={0}, widest fixup type: i64
;     reg({%start,+,1}<nsw><%for.body>)
;   LSR Use: Kind=Basic, Offsets={0}, widest fixup type: i64
;     reg({%start,+,1}<nsw><%for.body>)
;   LSR Use: Kind=Address of float in addrspace(0), Offsets={0}, widest fixup type: float*
;     reg((88888 + %arr)) + 4*reg({%start,+,1}<nsw><%for.body>)

; float test(float *arr, long long start, float threshold) {
;   for (long long i = start; i != 0; ++i) {
;     float x = arr[i + 7];
;     if (x > threshold)
;       return x;
;   }
;   return -7;
; }
define float @test1(float* nocapture readonly %arr, i64 %start, float %threshold) {
; CHECK-LABEL: test1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fmov s2, #-7.00000000
; CHECK-NEXT:    cbz x1, .LBB0_5
; CHECK-NEXT:  // %bb.1: // %for.body.preheader
; CHECK-NEXT:    add x8, x1, #7 // =7
; CHECK-NEXT:  .LBB0_2: // %for.body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldr s1, [x0, x8, lsl #2]
; CHECK-NEXT:    fcmp s1, s0
; CHECK-NEXT:    b.gt .LBB0_6
; CHECK-NEXT:  // %bb.3: // %for.cond
; CHECK-NEXT:    // in Loop: Header=BB0_2 Depth=1
; CHECK-NEXT:    add x8, x8, #1 // =1
; CHECK-NEXT:    cmp x8, #7 // =7
; CHECK-NEXT:    b.ne .LBB0_2
; CHECK-NEXT:  // %bb.4:
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB0_5:
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB0_6: // %cleanup2
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
entry:
  %cmp11 = icmp eq i64 %start, 0
  br i1 %cmp11, label %cleanup2, label %for.body

for.cond:                                         ; preds = %for.body
  %cmp = icmp eq i64 %inc, 0
  br i1 %cmp, label %cleanup2, label %for.body

for.body:                                         ; preds = %entry, %for.cond
  %i.012 = phi i64 [ %inc, %for.cond ], [ %start, %entry ]
  %add = add nsw i64 %i.012, 7
  %arrayidx = getelementptr inbounds float, float* %arr, i64 %add
  %0 = load float, float* %arrayidx, align 4
  %cmp1 = fcmp ogt float %0, %threshold
  %inc = add nsw i64 %i.012, 1
  br i1 %cmp1, label %cleanup2, label %for.cond

cleanup2:                                         ; preds = %for.cond, %for.body, %entry
  %1 = phi float [ -7.000000e+00, %entry ], [ %0, %for.body ], [ -7.000000e+00, %for.cond ]
  ret float %1
}

; Same as test1, except i has another use:
;     if (x > threshold) ---> if (x > threshold + i)
define float @test2(float* nocapture readonly %arr, i64 %start, float %threshold) {
; CHECK-LABEL: test2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fmov s2, #-7.00000000
; CHECK-NEXT:    cbz x1, .LBB1_4
; CHECK-NEXT:  .LBB1_1: // %for.body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add x8, x0, x1, lsl #2
; CHECK-NEXT:    ldr s1, [x8, #28]
; CHECK-NEXT:    scvtf s3, x1
; CHECK-NEXT:    fadd s3, s3, s0
; CHECK-NEXT:    fcmp s1, s3
; CHECK-NEXT:    b.gt .LBB1_5
; CHECK-NEXT:  // %bb.2: // %for.cond
; CHECK-NEXT:    // in Loop: Header=BB1_1 Depth=1
; CHECK-NEXT:    add x1, x1, #1 // =1
; CHECK-NEXT:    cbnz x1, .LBB1_1
; CHECK-NEXT:  // %bb.3:
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB1_4:
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB1_5: // %cleanup4
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
entry:
  %cmp14 = icmp eq i64 %start, 0
  br i1 %cmp14, label %cleanup4, label %for.body

for.cond:                                         ; preds = %for.body
  %cmp = icmp eq i64 %inc, 0
  br i1 %cmp, label %cleanup4, label %for.body

for.body:                                         ; preds = %entry, %for.cond
  %i.015 = phi i64 [ %inc, %for.cond ], [ %start, %entry ]
  %add = add nsw i64 %i.015, 7
  %arrayidx = getelementptr inbounds float, float* %arr, i64 %add
  %0 = load float, float* %arrayidx, align 4
  %conv = sitofp i64 %i.015 to float
  %add1 = fadd float %conv, %threshold
  %cmp2 = fcmp ogt float %0, %add1
  %inc = add nsw i64 %i.015, 1
  br i1 %cmp2, label %cleanup4, label %for.cond

cleanup4:                                         ; preds = %for.cond, %for.body, %entry
  %1 = phi float [ -7.000000e+00, %entry ], [ %0, %for.body ], [ -7.000000e+00, %for.cond ]
  ret float %1
}
