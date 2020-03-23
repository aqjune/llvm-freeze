; RUN: llc -mtriple=x86_64-unknown-linux-gnu < %s 2>&1 | FileCheck %s --check-prefix=X86ASM
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -optimize-regalloc=false < %s 2>&1 | FileCheck %s --check-prefix=X86ASM_NORAOPT

@x = global i32 0
@y = global i32 0

define void @f(i1 %cond) {
; X86ASM-LABEL: f:
; X86ASM:       # %bb.0:
; X86ASM-NEXT:    # kill: def $eax killed $eax def $rax
; X86ASM-NEXT:    testb $1, %dil
; X86ASM-NEXT:    je .LBB0_2
; X86ASM-NEXT:  # %bb.1: # %BB1
; X86ASM-NEXT:    leal -1(%rax), %ecx
; X86ASM-NEXT:    jmp .LBB0_3
; X86ASM-NEXT:  .LBB0_2: # %BB2
; X86ASM-NEXT:    xorl %ecx, %ecx
; X86ASM-NEXT:  .LBB0_3: # %END
; X86ASM-NEXT:    movl %eax, {{.*}}(%rip)
; X86ASM-NEXT:    movl %ecx, {{.*}}(%rip)
; X86ASM-NEXT:    retq
;
; X86ASM_NORAOPT-LABEL: f:
; X86ASM_NORAOPT: # %bb.0:
; X86ASM_NORAOPT-NEXT: # kill: def $dil killed $dil killed $edi
; X86ASM_NORAOPT-NEXT: # implicit-def: $eax
; X86ASM_NORAOPT-NEXT:	testb	$1, %dil
; X86ASM_NORAOPT-NEXT:	je	.LBB0_2
; X86ASM_NORAOPT-NEXT: # %bb.1:
; X86ASM_NORAOPT-NEXT:	movl	%eax, %ecx
; X86ASM_NORAOPT-NEXT:	leal	-1(%rcx), %edx
; X86ASM_NORAOPT-NEXT:	movl	%eax, -4(%rsp)
; X86ASM_NORAOPT-NEXT:	movl	%edx, -8(%rsp)
; X86ASM_NORAOPT-NEXT:	jmp	.LBB0_3
; X86ASM_NORAOPT-NEXT:.LBB0_2:
; X86ASM_NORAOPT-NEXT:	xorl	%ecx, %ecx
; X86ASM_NORAOPT-NEXT:	movl	%eax, -4(%rsp)
; X86ASM_NORAOPT-NEXT:	movl	%ecx, -8(%rsp)
; X86ASM_NORAOPT-NEXT:.LBB0_3:
; X86ASM_NORAOPT-NEXT:	movl	-8(%rsp), %eax
; X86ASM_NORAOPT-NEXT:	movl	-4(%rsp), %ecx
; X86ASM_NORAOPT-NEXT:	movl	%ecx, x(%rip)
; X86ASM_NORAOPT-NEXT:	movl	%eax, y(%rip)
; X86ASM_NORAOPT-NEXT:	retq
	br i1 %cond, label %BB1, label %BB2
BB1:
  %y1 = freeze i32 undef
  %k1 = sub i32 %y1, 1
  br label %END
BB2:
  %y2 = freeze i32 undef
  br label %END
END:
  %p = phi i32 [%y1, %BB1], [%y2, %BB2]
  %p2 = phi i32 [%k1, %BB1], [0, %BB2]
  store i32 %p, i32* @x
  store i32 %p2, i32* @y
	ret void
}
