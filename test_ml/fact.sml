fun fact n =
 if n <= 1 then 1
 else n * fact(n-1);

print(Int.toString(fact 5) ^ "\n");
