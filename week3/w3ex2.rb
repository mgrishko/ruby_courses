# open somefile
# Write a clever but readable Ruby program
# that updates this file and the final contents become like this:
# test test test
# test inserted word test
# test test test

filename = 'plaintext.txt'
File.open(filename, 'r+') do |file|
  line = file.readlines.to_s
  line['word']= 'inserted word'
  file.puts line
end

