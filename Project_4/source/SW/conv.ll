; ModuleID = 'conv.c'
source_filename = "conv.c"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown"

@in = dso_local global [30 x i32] zeroinitializer, align 4
@wgt = dso_local global [10 x i32] zeroinitializer, align 4
@out = dso_local global [100 x i32] zeroinitializer, align 4

; Function Attrs: noinline nounwind optnone
define dso_local i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %bias = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  store i32 2, i32* %bias, align 4
  store i32 0, i32* %i, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %0, 30
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %i, align 4
  %arrayidx = getelementptr inbounds [30 x i32], [30 x i32]* @in, i32 0, i32 %1
  store i32 3, i32* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %2 = load i32, i32* %i, align 4
  %inc = add nsw i32 %2, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond, !llvm.loop !5

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc5, %for.end
  %3 = load i32, i32* %i, align 4
  %cmp2 = icmp slt i32 %3, 10
  br i1 %cmp2, label %for.body3, label %for.end7

for.body3:                                        ; preds = %for.cond1
  %4 = load i32, i32* %i, align 4
  %arrayidx4 = getelementptr inbounds [10 x i32], [10 x i32]* @wgt, i32 0, i32 %4
  store i32 2, i32* %arrayidx4, align 4
  br label %for.inc5

for.inc5:                                         ; preds = %for.body3
  %5 = load i32, i32* %i, align 4
  %inc6 = add nsw i32 %5, 1
  store i32 %inc6, i32* %i, align 4
  br label %for.cond1, !llvm.loop !7

for.end7:                                         ; preds = %for.cond1
  store i32 0, i32* %i, align 4
  br label %for.cond8

for.cond8:                                        ; preds = %for.inc12, %for.end7
  %6 = load i32, i32* %i, align 4
  %cmp9 = icmp slt i32 %6, 100
  br i1 %cmp9, label %for.body10, label %for.end14

for.body10:                                       ; preds = %for.cond8
  %7 = load i32, i32* %i, align 4
  %arrayidx11 = getelementptr inbounds [100 x i32], [100 x i32]* @out, i32 0, i32 %7
  store i32 0, i32* %arrayidx11, align 4
  br label %for.inc12

for.inc12:                                        ; preds = %for.body10
  %8 = load i32, i32* %i, align 4
  %inc13 = add nsw i32 %8, 1
  store i32 %inc13, i32* %i, align 4
  br label %for.cond8, !llvm.loop !8

for.end14:                                        ; preds = %for.cond8
  %9 = load i32, i32* %bias, align 4
  call void @conv(i32 %9) #1
  ret i32 0
}

; Function Attrs: noinline nounwind optnone
define dso_local void @conv(i32 %bias) #0 {
entry:
  %bias.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 %bias, i32* %bias.addr, align 4
  store i32 0, i32* %i, align 4
  store i32 0, i32* %j, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc10, %entry
  %0 = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %0, 30
  br i1 %cmp, label %for.body, label %for.end12

for.body:                                         ; preds = %for.cond
  store i32 0, i32* %j, align 4
  br label %for.cond1

for.cond1:                                        ; preds = %for.inc, %for.body
  %1 = load i32, i32* %j, align 4
  %cmp2 = icmp slt i32 %1, 10
  br i1 %cmp2, label %for.body3, label %for.end

for.body3:                                        ; preds = %for.cond1
  %2 = load i32, i32* %i, align 4
  %3 = load i32, i32* %j, align 4
  %add = add nsw i32 %2, %3
  %arrayidx = getelementptr inbounds [30 x i32], [30 x i32]* @in, i32 0, i32 %add
  %4 = load i32, i32* %arrayidx, align 4
  %5 = load i32, i32* %j, align 4
  %arrayidx4 = getelementptr inbounds [10 x i32], [10 x i32]* @wgt, i32 0, i32 %5
  %6 = load i32, i32* %arrayidx4, align 4
  %mul = mul nsw i32 %4, %6
  %7 = load i32, i32* %i, align 4
  %arrayidx5 = getelementptr inbounds [100 x i32], [100 x i32]* @out, i32 0, i32 %7
  %8 = load i32, i32* %arrayidx5, align 4
  %add6 = add nsw i32 %mul, %8
  %9 = load i32, i32* %i, align 4
  %arrayidx7 = getelementptr inbounds [100 x i32], [100 x i32]* @out, i32 0, i32 %9
  store i32 %add6, i32* %arrayidx7, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body3
  %10 = load i32, i32* %j, align 4
  %inc = add nsw i32 %10, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond1, !llvm.loop !9

for.end:                                          ; preds = %for.cond1
  %11 = load i32, i32* %bias.addr, align 4
  %12 = load i32, i32* %i, align 4
  %arrayidx8 = getelementptr inbounds [100 x i32], [100 x i32]* @out, i32 0, i32 %12
  %13 = load i32, i32* %arrayidx8, align 4
  %add9 = add nsw i32 %13, %11
  store i32 %add9, i32* %arrayidx8, align 4
  br label %for.inc10

for.inc10:                                        ; preds = %for.end
  %14 = load i32, i32* %i, align 4
  %add11 = add nsw i32 %14, 1
  store i32 %add11, i32* %i, align 4
  br label %for.cond, !llvm.loop !10

for.end12:                                        ; preds = %for.cond
  ret void
}

; Function Attrs: noinline nounwind optnone
define dso_local i32 @loop_test(i32 %bias) #0 {
entry:
  %bias.addr = alloca i32, align 4
  %result = alloca i32, align 4
  %a = alloca [64 x i32], align 4
  %i = alloca i32, align 4
  %i1 = alloca i32, align 4
  store i32 %bias, i32* %bias.addr, align 4
  store i32 1, i32* %result, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %0, 64
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load i32, i32* %i, align 4
  %arrayidx = getelementptr inbounds [64 x i32], [64 x i32]* %a, i32 0, i32 %1
  store i32 10, i32* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %2 = load i32, i32* %i, align 4
  %add = add nsw i32 %2, 1
  store i32 %add, i32* %i, align 4
  br label %for.cond, !llvm.loop !11

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %i1, align 4
  br label %for.cond2

for.cond2:                                        ; preds = %for.inc7, %for.end
  %3 = load i32, i32* %i1, align 4
  %cmp3 = icmp slt i32 %3, 64
  br i1 %cmp3, label %for.body4, label %for.end9

for.body4:                                        ; preds = %for.cond2
  %4 = load i32, i32* %result, align 4
  %5 = load i32, i32* %i1, align 4
  %arrayidx5 = getelementptr inbounds [64 x i32], [64 x i32]* %a, i32 0, i32 %5
  %6 = load i32, i32* %arrayidx5, align 4
  %mul = mul nsw i32 %4, %6
  %7 = load i32, i32* %bias.addr, align 4
  %add6 = add nsw i32 %mul, %7
  store i32 %add6, i32* %result, align 4
  br label %for.inc7

for.inc7:                                         ; preds = %for.body4
  %8 = load i32, i32* %i1, align 4
  %add8 = add nsw i32 %8, 1
  store i32 %add8, i32* %i1, align 4
  br label %for.cond2, !llvm.loop !12

for.end9:                                         ; preds = %for.cond2
  %9 = load i32, i32* %result, align 4
  ret i32 %9
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "min-legal-vector-width"="0" "no-builtins" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-features"="+m,+relax,-save-restore" }
attributes #1 = { nobuiltin "no-builtins" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"ilp32"}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{i32 1, !"SmallDataLimit", i32 8}
!4 = !{!"clang version 14.0.0 (https://github.com/llvm/llvm-project.git a45d72e0247d080eb9437736bb6cadfc27e4c065)"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = distinct !{!7, !6}
!8 = distinct !{!8, !6}
!9 = distinct !{!9, !6}
!10 = distinct !{!10, !6}
!11 = distinct !{!11, !6}
!12 = distinct !{!12, !6}
