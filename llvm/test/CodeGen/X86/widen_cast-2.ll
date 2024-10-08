; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse4.2 | FileCheck %s
; bitcast v14i16 to v7i32

define void @convert(ptr %dst, ptr %src) nounwind {
; CHECK-LABEL: convert:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    movl $0, (%esp)
; CHECK-NEXT:    pcmpeqd %xmm0, %xmm0
; CHECK-NEXT:    cmpl $3, (%esp)
; CHECK-NEXT:    jg .LBB0_3
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB0_2: # %forbody
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movl (%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    shll $5, %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK-NEXT:    movdqa (%edx,%eax), %xmm1
; CHECK-NEXT:    movdqa 16(%edx,%eax), %xmm2
; CHECK-NEXT:    psubw %xmm0, %xmm2
; CHECK-NEXT:    psubw %xmm0, %xmm1
; CHECK-NEXT:    movdqa %xmm1, (%ecx,%eax)
; CHECK-NEXT:    movd %xmm2, 16(%ecx,%eax)
; CHECK-NEXT:    pextrd $1, %xmm2, 20(%ecx,%eax)
; CHECK-NEXT:    pextrd $2, %xmm2, 24(%ecx,%eax)
; CHECK-NEXT:    incl (%esp)
; CHECK-NEXT:    cmpl $3, (%esp)
; CHECK-NEXT:    jle .LBB0_2
; CHECK-NEXT:  .LBB0_3: # %afterfor
; CHECK-NEXT:    popl %eax
; CHECK-NEXT:    retl
entry:
	%dst.addr = alloca ptr
	%src.addr = alloca ptr
	%i = alloca i32, align 4
	store ptr %dst, ptr %dst.addr
	store ptr %src, ptr %src.addr
	store i32 0, ptr %i
	br label %forcond

forcond:
	%tmp = load i32, ptr %i
	%cmp = icmp slt i32 %tmp, 4
	br i1 %cmp, label %forbody, label %afterfor

forbody:
	%tmp1 = load i32, ptr %i
	%tmp2 = load ptr, ptr %dst.addr
	%arrayidx = getelementptr <7 x i32>, ptr %tmp2, i32 %tmp1
	%tmp3 = load i32, ptr %i
	%tmp4 = load ptr, ptr %src.addr
	%arrayidx5 = getelementptr <14 x i16>, ptr %tmp4, i32 %tmp3
	%tmp6 = load <14 x i16>, ptr %arrayidx5
	%add = add <14 x i16> %tmp6, < i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1 >
	%conv = bitcast <14 x i16> %add to <7 x i32>
	store <7 x i32> %conv, ptr %arrayidx
	br label %forinc

forinc:
	%tmp7 = load i32, ptr %i
	%inc = add i32 %tmp7, 1
	store i32 %inc, ptr %i
	br label %forcond

afterfor:
	ret void
}
