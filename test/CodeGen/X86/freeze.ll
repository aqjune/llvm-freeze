; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -print-machineinstrs %s -o /dev/null 2>&1 | FileCheck %s --check-prefix=MCINSTR
; RUN: llc -mtriple=x86_64-unknown-linux-gnu < %s 2>&1 | FileCheck %s --check-prefix=X86ASM

; MCINSTR: %1:gr32 = IMPLICIT_DEF
; MCINSTR: %2:gr32 = IMUL32rr %1:gr32(tied-def 0), %1:gr32,
; MCINSTR: %3:gr32 = XOR32rr %2:gr32(tied-def 0), %1:gr32,
; MCINSTR: $eax = COPY %3:gr32
; MCINSTR: RET 0, $eax

define i32 @foo(i32 %x) {
; X86ASM-LABEL: foo:
; X86ASM:       # %bb.0:
; X86ASM-NEXT:    imull %eax, %eax
; X86ASM-NEXT:    xorl %eax, %eax
; X86ASM-NEXT:    retq
  %y1 = freeze i32 undef
  %t1 = mul i32 %y1, %y1
  %t2 = xor i32 %t1, %y1
  ret i32 %t2
}
