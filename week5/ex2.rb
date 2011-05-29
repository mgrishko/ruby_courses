#The Really Annoying Project Manager (Yes Boss) has made a spec change!
#
#"There will be an amoeba shape on the screen, with the others. When the user clicks on the amoeba, it will rotate like the others, and play a .hif sound file. The other figures like rectangle rotate around the center. I want the amoeba shape to rotate around a point on one end, like a clock hand !"

class Shape
  def initialize(*args)
    puts "I'm #{self.class}"
  end

  def click
    puts "You activate this shape"
    rotate
  end

  def rotate
    puts "I'm rotate"
  end
end

class Polygon < Shape
  def initialize
    super
  end
end

class Amoeba < Shape
  def rotate
    puts "I'm individual rotate"
    music
  end

  def music
    puts "I'm play a .hif sound file"
  end
end

class Triangle < Polygon
  def initialize
    super
  end
end

class Square < Polygon
  def initialize
    super
  end
end

amoeba = Amoeba.new
triangle = Triangle.new
square  = Square.new
amoeba.click
triangle.click
square.click

=begin
   doctest: Create an Amoeba Shape
   >> amoeba = Amoeba.new
   =>I'm  Amoeba
   doctest: An Amoeba plays a .hif file & rotate
   >> amoeba.click
   =>You activate this shape
   =>I'm playing a .hif sound file
   =>I'm individual rotate
   doctest: Create a Square & Triangle
   >>square = Square.new
   >>triangle = Triangle.new
   =>I'm Triangle
   =>I'm Square
   doctest: Polygon rotate
   >>square.click
   >>triangle.click
   =>I'm rotate
   =>I'm rotate
=end
