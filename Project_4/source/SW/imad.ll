define i32 @mul(i32 %a, i32 %b) nounwind {

  %1 = mul i32 %a, %b
  %2 = add i32 %1, %b
  ret i32 %2
}
