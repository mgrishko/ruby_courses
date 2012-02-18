#Exercise1. Write a class UnpredictableString which is a sub-class of String. This sub-class should have a method called scramble() which randomly rearranges any string as follows:
#
#>ruby unpredictablestring.rb
#
#daano.r n sdt a htIsw taikmgy r
#
#>Exit code: 0
#
## the original string was: "It was a dark and stormy night."
#Don't forget that you will be using < and so must, I repeat must, remember to replace the < with &lt;. You will end up posting code that doesn't work as expected if you do not.

class UnpredictableString < String
  def initialize(str)
    @str = str
  end
  def scramble
    @str.split(//).shuffle.join
  end
end
#2 variant
#class UnpredictableString < String
#def scramble
# self.split(//).shuffle.join
#end
#end
str = UnpredictableString.new("this method must work")
puts str.scramble
