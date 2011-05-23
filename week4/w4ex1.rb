#Write a class called Dog, that has name as an instance variable and the 
#following methods:

#bark(), eat(), chase_cat()
#I shall create the Dog object as follows:
#d = Dog.new('Leo')

class Dog
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def bark()
    "gav-gav"
  end

  def eat()
    "nam-nam"
  end

  def chase_cat()
    "grrr"
  end
end
