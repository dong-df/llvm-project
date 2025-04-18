; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-globals --include-generated-funcs
; Test basic type sanitizer instrumentation.
; RUN: opt -passes='tysan' -S %s | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define i32 @test_load_nsan(ptr %a) {
entry:
  %tmp1 = load i32, ptr %a, align 4, !tbaa !3
  ret i32 %tmp1
}

define void @test_store_nsan(ptr %a) {
entry:
  store i32 42, ptr %a, align 4, !tbaa !3
  ret void
}


!0 = !{!"Simple C++ TBAA"}
!1 = !{!"omnipotent char", !0, i64 0}
!2 = !{!"int", !1, i64 0}
!3 = !{!2, !2, i64 0}
;.
; CHECK: @llvm.global_ctors = appending global [1 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 0, ptr @tysan.module_ctor, ptr null }]
; CHECK: @__tysan_v1_Simple_20C_2b_2b_20TBAA = linkonce_odr constant { i64, i64, [16 x i8] } { i64 2, i64 0, [16 x i8] c"Simple C++ TBAA\00" }, comdat
; CHECK: @__tysan_v1_omnipotent_20char = linkonce_odr constant { i64, i64, ptr, i64, [16 x i8] } { i64 2, i64 1, ptr @__tysan_v1_Simple_20C_2b_2b_20TBAA, i64 0, [16 x i8] c"omnipotent char\00" }, comdat
; CHECK: @__tysan_v1_int = linkonce_odr constant { i64, i64, ptr, i64, [4 x i8] } { i64 2, i64 1, ptr @__tysan_v1_omnipotent_20char, i64 0, [4 x i8] c"int\00" }, comdat
; CHECK: @__tysan_v1_int_o_0 = linkonce_odr constant { i64, ptr, ptr, i64 } { i64 1, ptr @__tysan_v1_int, ptr @__tysan_v1_int, i64 0 }, comdat
; CHECK: @llvm.used = appending global [5 x ptr] [ptr @tysan.module_ctor, ptr @__tysan_v1_Simple_20C_2b_2b_20TBAA, ptr @__tysan_v1_omnipotent_20char, ptr @__tysan_v1_int, ptr @__tysan_v1_int_o_0], section "llvm.metadata"
; CHECK: @__tysan_shadow_memory_address = external global i64
; CHECK: @__tysan_app_memory_mask = external global i64
;.
; CHECK-LABEL: @test_load_nsan(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[APP_MEM_MASK:%.*]] = load i64, ptr @__tysan_app_memory_mask, align 8
; CHECK-NEXT:    [[SHADOW_BASE:%.*]] = load i64, ptr @__tysan_shadow_memory_address, align 8
; CHECK-NEXT:    [[APP_PTR_INT:%.*]] = ptrtoint ptr [[A:%.*]] to i64
; CHECK-NEXT:    [[APP_PTR_MASKED:%.*]] = and i64 [[APP_PTR_INT]], [[APP_MEM_MASK]]
; CHECK-NEXT:    [[APP_PTR_SHIFTED:%.*]] = shl i64 [[APP_PTR_MASKED]], 3
; CHECK-NEXT:    [[SHADOW_PTR_INT:%.*]] = add i64 [[APP_PTR_SHIFTED]], [[SHADOW_BASE]]
; CHECK-NEXT:    [[SHADOW_PTR:%.*]] = inttoptr i64 [[SHADOW_PTR_INT]] to ptr
; CHECK-NEXT:    [[SHADOW_DESC:%.*]] = load ptr, ptr [[SHADOW_PTR]], align 8
; CHECK-NEXT:    [[DESC_SET:%.*]] = icmp eq ptr [[SHADOW_DESC]], null
; CHECK-NEXT:    br i1 [[DESC_SET]], label [[SET_TYPE:%.*]], label [[TMP0:%.*]], !prof [[PROF0:![0-9]+]]
; CHECK:       set.type:
; CHECK-NEXT:    store ptr @__tysan_v1_int_o_0, ptr [[SHADOW_PTR]], align 8
; CHECK-NEXT:    [[SHADOW_BYTE_1_OFFSET:%.*]] = add i64 [[SHADOW_PTR_INT]], 8
; CHECK-NEXT:    [[SHADOW_BYTE_1_PTR:%.*]] = inttoptr i64 [[SHADOW_BYTE_1_OFFSET]] to ptr
; CHECK-NEXT:    store ptr inttoptr (i64 -1 to ptr), ptr [[SHADOW_BYTE_1_PTR]], align 8
; CHECK-NEXT:    [[SHADOW_BYTE_2_OFFSET:%.*]] = add i64 [[SHADOW_PTR_INT]], 16
; CHECK-NEXT:    [[SHADOW_BYTE_2_PTR:%.*]] = inttoptr i64 [[SHADOW_BYTE_2_OFFSET]] to ptr
; CHECK-NEXT:    store ptr inttoptr (i64 -2 to ptr), ptr [[SHADOW_BYTE_2_PTR]], align 8
; CHECK-NEXT:    [[SHADOW_BYTE_3_OFFSET:%.*]] = add i64 [[SHADOW_PTR_INT]], 24
; CHECK-NEXT:    [[SHADOW_BYTE_3_PTR:%.*]] = inttoptr i64 [[SHADOW_BYTE_3_OFFSET]] to ptr
; CHECK-NEXT:    store ptr inttoptr (i64 -3 to ptr), ptr [[SHADOW_BYTE_3_PTR]], align 8
; CHECK-NEXT:    br label [[TMP0]]
; CHECK:       0:
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[A]], align 4, !tbaa [[TBAA1:![0-9]+]]
; CHECK-NEXT:    ret i32 [[TMP1]]
;
;
; CHECK-LABEL: @test_store_nsan(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[APP_MEM_MASK:%.*]] = load i64, ptr @__tysan_app_memory_mask, align 8
; CHECK-NEXT:    [[SHADOW_BASE:%.*]] = load i64, ptr @__tysan_shadow_memory_address, align 8
; CHECK-NEXT:    [[APP_PTR_INT:%.*]] = ptrtoint ptr [[A:%.*]] to i64
; CHECK-NEXT:    [[APP_PTR_MASKED:%.*]] = and i64 [[APP_PTR_INT]], [[APP_MEM_MASK]]
; CHECK-NEXT:    [[APP_PTR_SHIFTED:%.*]] = shl i64 [[APP_PTR_MASKED]], 3
; CHECK-NEXT:    [[SHADOW_PTR_INT:%.*]] = add i64 [[APP_PTR_SHIFTED]], [[SHADOW_BASE]]
; CHECK-NEXT:    [[SHADOW_PTR:%.*]] = inttoptr i64 [[SHADOW_PTR_INT]] to ptr
; CHECK-NEXT:    [[SHADOW_DESC:%.*]] = load ptr, ptr [[SHADOW_PTR]], align 8
; CHECK-NEXT:    [[DESC_SET:%.*]] = icmp eq ptr [[SHADOW_DESC]], null
; CHECK-NEXT:    br i1 [[DESC_SET]], label [[SET_TYPE:%.*]], label [[TMP0:%.*]], !prof [[PROF0]]
; CHECK:       set.type:
; CHECK-NEXT:    store ptr @__tysan_v1_int_o_0, ptr [[SHADOW_PTR]], align 8
; CHECK-NEXT:    [[SHADOW_BYTE_1_OFFSET:%.*]] = add i64 [[SHADOW_PTR_INT]], 8
; CHECK-NEXT:    [[SHADOW_BYTE_1_PTR:%.*]] = inttoptr i64 [[SHADOW_BYTE_1_OFFSET]] to ptr
; CHECK-NEXT:    store ptr inttoptr (i64 -1 to ptr), ptr [[SHADOW_BYTE_1_PTR]], align 8
; CHECK-NEXT:    [[SHADOW_BYTE_2_OFFSET:%.*]] = add i64 [[SHADOW_PTR_INT]], 16
; CHECK-NEXT:    [[SHADOW_BYTE_2_PTR:%.*]] = inttoptr i64 [[SHADOW_BYTE_2_OFFSET]] to ptr
; CHECK-NEXT:    store ptr inttoptr (i64 -2 to ptr), ptr [[SHADOW_BYTE_2_PTR]], align 8
; CHECK-NEXT:    [[SHADOW_BYTE_3_OFFSET:%.*]] = add i64 [[SHADOW_PTR_INT]], 24
; CHECK-NEXT:    [[SHADOW_BYTE_3_PTR:%.*]] = inttoptr i64 [[SHADOW_BYTE_3_OFFSET]] to ptr
; CHECK-NEXT:    store ptr inttoptr (i64 -3 to ptr), ptr [[SHADOW_BYTE_3_PTR]], align 8
; CHECK-NEXT:    br label [[TMP0]]
; CHECK:       0:
; CHECK-NEXT:    store i32 42, ptr [[A]], align 4, !tbaa [[TBAA1]]
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: @tysan.module_ctor(
; CHECK-NEXT:    call void @__tysan_init()
; CHECK-NEXT:    ret void
;
;.
; CHECK: attributes #[[ATTR0:[0-9]+]] = { nounwind }
;.
; CHECK: [[PROF0]] = !{!"branch_weights", i32 1, i32 100000}
; CHECK: [[TBAA1]] = !{[[META2:![0-9]+]], [[META2]], i64 0}
; CHECK: [[META2]] = !{!"int", [[META3:![0-9]+]], i64 0}
; CHECK: [[META3]] = !{!"omnipotent char", [[META4:![0-9]+]], i64 0}
; CHECK: [[META4]] = !{!"Simple C++ TBAA"}
;.
