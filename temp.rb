print "Input temperature and scale (C or F): "
str = gets.chomp!
exit if (str.nil? || str.empty?)
temp, scale = str.split
temp = temp.to_f

def to_fahrenheit(temp)
  f = 1.8*temp + 32
end

def to_celsius(temp)
  c = (5.0/9)*(temp - 32)
end

def to_kelvin(temp)
  k = temp + 273
end

case scale.upcase
  when "C"
    print "#{temp} in celsius is "
    print format("%.2f fahrenheit", to_fahrenheit(temp))
    puts format(" and %.2f kelvin", to_kelvin(temp))
  when "F"
    print "#{temp} in fahrenheit is "
    print format("%.2f celsius", c = to_celsius(temp))
    puts format(" and %.2f kelvin", to_kelvin(c))
  when "K"
    print "#{temp} in kelvin is "
    print format("%.2f celsius", c = (temp - 273) )
    puts format(" and %.2f fahrenheit", to_fahrenheit(c))
else
  exit
end
