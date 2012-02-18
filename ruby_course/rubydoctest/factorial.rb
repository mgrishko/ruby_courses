def factorial(n)
  if n == 0
     1
  else
     n * factorial(n-1)
  end
end
=begin
doctest: fact
>> factorial(0)
=> 1
=end
