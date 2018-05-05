; RUN: llvm-as < %s | llvm-dis > %t.orig
; RUN: llvm-as < %s | llvm-c-test --echo > %t.echo
; RUN: diff -w %t.orig %t.echo

define i32 @f(i32 %arg, <2 x i32> %arg2, float %arg3, <2 x float> %arg4) {
  %1 = freeze i32 %arg
  %2 = freeze i32 10
  %3 = freeze i32 %1
  %4 = freeze <2 x i32> %arg2
  %5 = freeze float %arg3
  %6 = freeze <2 x float> %arg4
  ret i32 %1
}
