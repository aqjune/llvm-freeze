; Make sure that seldag legalization works correctly for freeze instruction.
; RUN: llc -march=x86 < %s 2>&1 | FileCheck %s

; CHECK-LABEL: expand:
; CHECK: movl    $303174162, %eax
; CHECK: movl    $875836468, %ecx
; CHECK: movl    $1448498774, %edx
; CHECK: xorl    %eax, %edx
; CHECK: movl    $2021161080, %eax
; CHECK: xorl    %ecx, %eax
; CHECK: retl

define i64 @expand(i32 %x) {
  %y1 = freeze i64 1302123111658042420 ; 0x1212121234343434
  %y2 = freeze i64 6221254864647256184 ; 0x5656565678787878
  %t2 = xor i64 %y1, %y2
  ret i64 %t2
}

; CHECK-LABEL: expand_vec:
; CHECK: movl    $16843009, %ecx
; CHECK: movl    $589505315, %edx
; CHECK: movl    $303174162, %esi
; CHECK: movl    $875836468, %edi
; CHECK: movl    $1162167621, %ebx
; CHECK: xorl    %ecx, %ebx
; CHECK: movl    $1734829927, %ecx
; CHECK: xorl    %edx, %ecx
; CHECK: movl    $1448498774, %edx
; CHECK: xorl    %esi, %edx
; CHECK: movl    $2021161080, %esi
; CHECK: xorl    %edi, %esi

define <2 x i64> @expand_vec(i32 %x) {
  ; <0x1212121234343434, 0x0101010123232323>
  %y1 = freeze <2 x i64> <i64 1302123111658042420, i64 72340173410738979>
  ; <0x5656565678787878, 0x4545454567676767>
  %y2 = freeze <2 x i64> <i64 6221254864647256184, i64 4991471926399952743>
  %t2 = xor <2 x i64> %y1, %y2
  ret <2 x i64> %t2
}

; CHECK-LABEL: promote:
; CHECK: movw    $682, %cx
; CHECK: movw    $992, %ax
; CHECK: addl    %ecx, %eax
; CHECK: retl
define i10 @promote() {
  %a = freeze i10 682
  %b = freeze i10 992
  %res = add i10 %a, %b
  ret i10 %res
}

; CHECK-LABEL: promote_vec
; CHECK: movw    $125, %ax
; CHECK: movw    $682, %cx
; CHECK: movw    $393, %dx
; CHECK: addl    %eax, %edx
; CHECK: movw    $992, %ax
; CHECK: addl    %ecx, %eax
; CHECK: retl
define <2 x i10> @promote_vec() {
  %a = freeze <2 x i10> <i10 682, i10 125>
  %b = freeze <2 x i10> <i10 992, i10 393>
  %res = add <2 x i10> %a, %b
  ret <2 x i10> %res
}
