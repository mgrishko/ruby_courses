#The Really Annoying Project Manager (Yes Boss) has made a spec change!
#
#"There will be an amoeba shape on the screen, with the others. When the user clicks on the amoeba, it will rotate like the others, and play a .hif sound file. The other figures like rectangle rotate around the center. I want the amoeba shape to rotate around a point on one end, like a clock hand !"

class Shape
  def name
    self.class
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
  def initialize(sides)
    @sides = sides
    puts "I'm a #{name} and I have #{@sides} sides"
  end
end

class Amoeba < Shape
  def rotate
    puts "I'm individual rotate"
    music
  end

  def music
    puts "play some music"
  end
end

class Triangle < Polygon
  def initialize(sides = 3)
    super
  end
end

class Square < Polygon
  def initialize(sides = 4)
    super
  end
end

amoeba = Amoeba.new
triangle = Triangle.new
square  = Square.new
amoeba.click
triangle.click
square.click
