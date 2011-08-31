require 'rubygems'
require 'nokogiri'
require 'spreadsheet'

#Copiyng old file to gpc_pack_full.xml
if File.exist?('gpc_pack.xml')
  File.rename('gpc_pack.xml', 'gpc_pack_backup.xml')
else
  puts "First created file"
end

#You should use file size about 6 - 10 mb
file = File.open("gpc_pack.xml")
doc = Nokogiri::XML(file)
file.close

#Information about node
puts "segment - " + doc.xpath("//segment").size.to_s
puts "family - "  + doc.xpath("//family").size.to_s
puts "class - "   + doc.xpath("//class").size.to_s
puts "brick - "   + doc.xpath("//brick").size.to_s

#Initialize arrays
segment_code, segment_description, family_code,
family_description, class_code, class_description, brick_code,
brick_description, brick_definition = Array.new(9) { [] }

#Parse
puts 'Please wait until parsing xml (core2duo-2.3Ggz, about 30 min)'
doc.xpath('//brick').each do |element|
  segment_code        << element.ancestors(selector = 'segment').attribute('code')
  segment_description << element.ancestors(selector = 'segment').attribute('text')
  family_code         << element.ancestors(selector = 'family').attribute('code')
  family_description  << element.ancestors(selector = 'family').attribute('text')
  class_code          << element.ancestors(selector = 'class').attribute('code')
  class_description   << element.ancestors(selector = 'class').attribute('text')
  brick_code          << element.attribute('code')
  brick_description   << element.attribute('text')
  brick_definition    << element.attribute('definition')
end

puts 'Parsing complited'

if brick_code.size != doc.xpath('//brick').size
  puts 'You have incorrect or broken xml file, please be careful, size of brick attributes must match'
else
  #Create xls document
  book = Spreadsheet::Workbook.new
  worksheet = book.create_worksheet
  worksheet.name = 'GPC reference book'
  worksheet.row(0).concat %w{Segment_Code Segment_Description Family_Code Family_Description Class_Code Class_Description
                             Brick_Code Brick_Description Brick_Definition Segment_Code_Ru Segment_Description_Ru
                             Family_Code_Ru Family_Description_Ru Class_Code_Ru Class_Description_Ru Brick_Code_Ru
                             Brick_Description_Ru Brick_Definition_Ru}
  #Filling xls
  number_row = 0
  while brick_code.any?  do
    number_row +=1
    worksheet.row(number_row).insert 0, segment_code.shift.to_s
    worksheet.row(number_row).insert 1, segment_description.shift.to_s
    worksheet.row(number_row).insert 2, family_code.shift.to_s
    worksheet.row(number_row).insert 3, family_description.shift.to_s
    worksheet.row(number_row).insert 4, class_code.shift.to_s
    worksheet.row(number_row).insert 5, class_description.shift.to_s
    worksheet.row(number_row).insert 6, brick_code.shift.to_s
    worksheet.row(number_row).insert 7, brick_description.shift.to_s
    worksheet.row(number_row).insert 8, brick_definition.shift.to_s
  end

#Add some Formatting for flavour:
worksheet.row(0).height = 16
format = Spreadsheet::Format.new :color  => :blue,
                                 :weight => :bold,
                                 :size   => 10
worksheet.row(0).default_format = format

#And finally, write the Excel File:
book.write 'gpc_pack.xls'
end
