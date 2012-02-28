require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open("http://satishtalim.github.com/webruby/chapter3.html"))
  num = doc.text.scan(/\bthe\b/i).count
puts num
