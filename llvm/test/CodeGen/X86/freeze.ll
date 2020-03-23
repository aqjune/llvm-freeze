; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu < %s 2>&1 | FileCheck %s --check-prefix=X86ASM

%struct.T = type { i32, i32 }

define i32 @freeze_int() {
; X86ASM-LABEL: freeze_int:
; X86ASM:       # %bb.0:
; X86ASM-NEXT:    # kill: def $ecx killed $eax
; X86ASM-NEXT:    movl %ecx, %eax
; X86ASM-NEXT:    imull %ecx, %eax
; X86ASM-NEXT:    xorl %ecx, %eax
; X86ASM-NEXT:    retq
  %y1 = freeze i32 undef
  %t1 = mul i32 %y1, %y1
  %t2 = xor i32 %t1, %y1
  ret i32 %t2
}

define i5 @freeze_int2() {
; X86ASM-LABEL: freeze_int2:
; X86ASM:       # %bb.0:
; X86ASM-NEXT:    # kill: def $cl killed $al
; X86ASM-NEXT:    movl %ecx, %eax
; X86ASM-NEXT:    mulb %cl
; X86ASM-NEXT:    xorb %cl, %al
; X86ASM-NEXT:    retq
  %y1 = freeze i5 undef
  %t1 = mul i5 %y1, %y1
  %t2 = xor i5 %t1, %y1
  ret i5 %t2
}

define float @freeze_float() {
; X86ASM-LABEL: freeze_float:
; X86ASM:       # %bb.0:
; X86ASM-NEXT:    # kill: def $xmm0 killed $xmm0
; X86ASM-NEXT:    addss %xmm0, %xmm0
; X86ASM-NEXT:    retq
  %y1 = freeze float undef
  %t1 = fadd float %y1, %y1
  ret float %t1
}

define <2 x i32> @freeze_ivec() {
; X86ASM-LABEL: freeze_ivec:
; X86ASM:       # %bb.0:
; X86ASM-NEXT:    # kill: def $xmm0 killed $xmm0
; X86ASM-NEXT:    paddd %xmm0, %xmm0
; X86ASM-NEXT:    retq
  %y1 = freeze <2 x i32> undef
  %t1 = add <2 x i32> %y1, %y1
  ret <2 x i32> %t1
}

define i8* @freeze_ptr() {
; X86ASM-LABEL: freeze_ptr:
; X86ASM:       # %bb.0:
; X86ASM-NEXT:    # kill: def $rax killed $rax
; X86ASM-NEXT:    addq $4, %rax
; X86ASM-NEXT:    retq
  %y1 = freeze i8* undef
  %t1 = getelementptr i8, i8* %y1, i64 4
  ret i8* %t1
}

define i32 @freeze_struct() {
; X86ASM-LABEL: freeze_struct:
; X86ASM:       # %bb.0:
; X86ASM-NEXT:    # kill: def $eax killed $eax
; X86ASM-NEXT:    addl %eax, %eax
; X86ASM-NEXT:    retq
  %y1 = freeze %struct.T undef
  %v1 = extractvalue %struct.T %y1, 0
  %v2 = extractvalue %struct.T %y1, 1
  %t1 = add i32 %v1, %v2
  ret i32 %t1
}

define i32 @freeze_anonstruct() {
; X86ASM-LABEL: freeze_anonstruct:
; X86ASM:       # %bb.0:
; X86ASM-NEXT:    # kill: def $eax killed $eax
; X86ASM-NEXT:    addl %eax, %eax
; X86ASM-NEXT:    retq
  %y1 = freeze {i32, i32} undef
  %v1 = extractvalue {i32, i32} %y1, 0
  %v2 = extractvalue {i32, i32} %y1, 1
  %t1 = add i32 %v1, %v2
  ret i32 %t1
}

define i64 @freeze_array() {
; X86ASM-LABEL: freeze_array:
; X86ASM:       # %bb.0:
; X86ASM-NEXT:    # kill: def $rax killed $rax
; X86ASM-NEXT:    addq %rax, %rax
; X86ASM-NEXT:    retq
  %y1 = freeze [2 x i64] undef
  %v1 = extractvalue [2 x i64] %y1, 0
  %v2 = extractvalue [2 x i64] %y1, 1
  %t1 = add i64 %v1, %v2
  ret i64 %t1
}
