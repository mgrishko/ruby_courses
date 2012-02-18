#Write a class called Person that has balance as an instance variable and make it readable via an accessor.
class Person
  attr_reader :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end
end

person = Person.new("MikhailAleksandrovi4", 1_000_999)
puts person.balance
