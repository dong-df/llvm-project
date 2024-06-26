; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64 %s -start-before=x86-isel -o - | FileCheck %s

define i32 @add_shl_or_disjoint(i32 %x) {
; CHECK-LABEL: add_shl_or_disjoint:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    leal 165036822(,%rdi,4), %eax
; CHECK-NEXT:    retq
  %or = or disjoint i32 %x, 4027584529
  %shl = shl i32 %or, 2
  %add = add i32 %shl, 1234567890
  ret i32 %add
}

