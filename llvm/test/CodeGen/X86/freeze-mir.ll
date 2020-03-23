; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -verify-machineinstrs -o - -stop-after=finalize-isel %s 2>&1 | FileCheck %s --check-prefix=X86MIR

%struct.T = type { i32, i32 }

define i32 @freeze_int() {
  ; X86MIR-LABEL: name: freeze_int
  ; X86MIR: bb.0 (%ir-block.0):
  ; X86MIR:   [[DEF:%[0-9]+]]:gr32 = IMPLICIT_DEF
  ; X86MIR:   [[FREEZE:%[0-9]+]]:gr32 = FREEZE killed [[DEF]]
  ; X86MIR:   [[IMUL32rr:%[0-9]+]]:gr32 = IMUL32rr [[FREEZE]], [[FREEZE]], implicit-def dead $eflags
  ; X86MIR:   [[XOR32rr:%[0-9]+]]:gr32 = XOR32rr [[IMUL32rr]], [[FREEZE]], implicit-def dead $eflags
  ; X86MIR:   $eax = COPY [[XOR32rr]]
  ; X86MIR:   RET 0, $eax
  %y1 = freeze i32 undef
  %t1 = mul i32 %y1, %y1
  %t2 = xor i32 %t1, %y1
  ret i32 %t2
}

define i5 @freeze_int2() {
  ; X86MIR-LABEL: name: freeze_int2
  ; X86MIR: bb.0 (%ir-block.0):
  ; X86MIR:   [[DEF:%[0-9]+]]:gr8 = IMPLICIT_DEF
  ; X86MIR:   [[FREEZE:%[0-9]+]]:gr8 = FREEZE killed [[DEF]]
  ; X86MIR:   $al = COPY [[FREEZE]]
  ; X86MIR:   MUL8r [[FREEZE]], implicit-def $al, implicit-def dead $eflags, implicit-def $ax, implicit $al
  ; X86MIR:   [[COPY:%[0-9]+]]:gr8 = COPY $al
  ; X86MIR:   [[XOR8rr:%[0-9]+]]:gr8 = XOR8rr [[COPY]], [[FREEZE]], implicit-def dead $eflags
  ; X86MIR:   $al = COPY [[XOR8rr]]
  ; X86MIR:   RET 0, $al
  %y1 = freeze i5 undef
  %t1 = mul i5 %y1, %y1
  %t2 = xor i5 %t1, %y1
  ret i5 %t2
}

define float @freeze_float() {
  ; X86MIR-LABEL: name: freeze_float
  ; X86MIR: bb.0 (%ir-block.0):
  ; X86MIR:   [[DEF:%[0-9]+]]:fr32 = IMPLICIT_DEF
  ; X86MIR:   [[FREEZE:%[0-9]+]]:fr32 = FREEZE killed [[DEF]]
  ; X86MIR:   %2:fr32 = nofpexcept ADDSSrr [[FREEZE]], [[FREEZE]], implicit $mxcsr
  ; X86MIR:   $xmm0 = COPY %2
  ; X86MIR:   RET 0, $xmm0
  %y1 = freeze float undef
  %t1 = fadd float %y1, %y1
  ret float %t1
}

define <2 x i32> @freeze_ivec() {
  ; X86MIR-LABEL: name: freeze_ivec
  ; X86MIR: bb.0 (%ir-block.0):
  ; X86MIR:   [[DEF:%[0-9]+]]:vr128 = IMPLICIT_DEF
  ; X86MIR:   [[FREEZE:%[0-9]+]]:vr128 = FREEZE killed [[DEF]]
  ; X86MIR:   [[PADDDrr:%[0-9]+]]:vr128 = PADDDrr [[FREEZE]], [[FREEZE]]
  ; X86MIR:   $xmm0 = COPY [[PADDDrr]]
  ; X86MIR:   RET 0, $xmm0
  %y1 = freeze <2 x i32> undef
  %t1 = add <2 x i32> %y1, %y1
  ret <2 x i32> %t1
}

define i8* @freeze_ptr() {
  ; X86MIR-LABEL: name: freeze_ptr
  ; X86MIR: bb.0 (%ir-block.0):
  ; X86MIR:   [[DEF:%[0-9]+]]:gr64 = IMPLICIT_DEF
  ; X86MIR:   [[FREEZE:%[0-9]+]]:gr64 = FREEZE killed [[DEF]]
  ; X86MIR:   [[ADD64ri8_:%[0-9]+]]:gr64 = ADD64ri8 [[FREEZE]], 4, implicit-def dead $eflags
  ; X86MIR:   $rax = COPY [[ADD64ri8_]]
  ; X86MIR:   RET 0, $rax
  %y1 = freeze i8* undef
  %t1 = getelementptr i8, i8* %y1, i64 4
  ret i8* %t1
}

define i32 @freeze_struct() {
  ; X86MIR-LABEL: name: freeze_struct
  ; X86MIR: bb.0 (%ir-block.0):
  ; X86MIR:   [[DEF:%[0-9]+]]:gr32 = IMPLICIT_DEF
  ; X86MIR:   [[FREEZE:%[0-9]+]]:gr32 = FREEZE killed [[DEF]]
  ; X86MIR:   [[ADD32rr:%[0-9]+]]:gr32 = ADD32rr [[FREEZE]], [[FREEZE]], implicit-def dead $eflags
  ; X86MIR:   $eax = COPY [[ADD32rr]]
  ; X86MIR:   RET 0, $eax
  %y1 = freeze %struct.T undef
  %v1 = extractvalue %struct.T %y1, 0
  %v2 = extractvalue %struct.T %y1, 1
  %t1 = add i32 %v1, %v2
  ret i32 %t1
}

define i32 @freeze_anonstruct() {
  ; X86MIR-LABEL: name: freeze_anonstruct
  ; X86MIR: bb.0 (%ir-block.0):
  ; X86MIR:   [[DEF:%[0-9]+]]:gr32 = IMPLICIT_DEF
  ; X86MIR:   [[FREEZE:%[0-9]+]]:gr32 = FREEZE killed [[DEF]]
  ; X86MIR:   [[ADD32rr:%[0-9]+]]:gr32 = ADD32rr [[FREEZE]], [[FREEZE]], implicit-def dead $eflags
  ; X86MIR:   $eax = COPY [[ADD32rr]]
  ; X86MIR:   RET 0, $eax
  %y1 = freeze {i32, i32} undef
  %v1 = extractvalue {i32, i32} %y1, 0
  %v2 = extractvalue {i32, i32} %y1, 1
  %t1 = add i32 %v1, %v2
  ret i32 %t1
}

define i64 @freeze_array() {
  ; X86MIR-LABEL: name: freeze_array
  ; X86MIR: bb.0 (%ir-block.0):
  ; X86MIR:   [[DEF:%[0-9]+]]:gr64 = IMPLICIT_DEF
  ; X86MIR:   [[FREEZE:%[0-9]+]]:gr64 = FREEZE killed [[DEF]]
  ; X86MIR:   [[ADD64rr:%[0-9]+]]:gr64 = ADD64rr [[FREEZE]], [[FREEZE]], implicit-def dead $eflags
  ; X86MIR:   $rax = COPY [[ADD64rr]]
  ; X86MIR:   RET 0, $rax
  %y1 = freeze [2 x i64] undef
  %v1 = extractvalue [2 x i64] %y1, 0
  %v2 = extractvalue [2 x i64] %y1, 1
  %t1 = add i64 %v1, %v2
  ret i64 %t1
}
