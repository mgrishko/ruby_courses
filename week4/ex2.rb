#Exercise2. Write a Rectangle class. I shall use your class as follows:
#
#r = Rectangle.new(23.45, 34.67)
#puts "Area is = #{r.area()}"
#puts "Perimeter is = #{r.perimeter}"

class Rectangle
  def initialize(a, b)
    @a, @b = a, b
  end
  
  def area
    @s = @a * @b
  end

  def perimeter
    @p = @a + @b
  end
end
