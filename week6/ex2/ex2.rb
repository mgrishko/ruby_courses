#Exercise2. Write a Ruby program that analyzes an MP3 file. Many MP3
#files have a 128-byte data structure at the end called an ID3 tag. These 128 bytes are literally packed with information about the song: its name, the artist, which album it's from, and so on. You can parse this data structure by opening an MP3 file and doing a series of reads from a position near the end of the file. According to the ID3 standard, if you start from the 128th-to-last byte of an MP3 file and read three bytes, you should get the string TAG. If you don't, there's no ID3 tag for this MP3 file, and nothing to do. If there is an ID3 tag present, then the 30 bytes after TAG contain the name of the song, the 30 bytes after that contain the name of the artist, and so on. A sample song.mp3 file is available to test your program. Use Symbols, wherever possible.
class MP3_INFO
  def dir_entries
    current_dir = Dir.pwd
    arr_non_filter = Dir.entries(current_dir).sort
    arr_filter = arr_non_filter.drop_while{|i| i !~ /\w+/}
    hash = {}
    arr_filter.each_with_index{|v,k| hash[k]=v}
    hash
  end

  def choice_file
    dir_entries.each {|number, filename| puts "#{number}: #{filename}"}
    print "Input number file for analize: "
    file = gets.chomp.to_i
    dir_entries[file]
  end

  def encoding
    hash = {}
    puts choice_file.inspect
    File.open(choice_file) do |f|
      f.seek(-128, IO::SEEK_END)
      if f.read(3) == "TAG"
        hash[:track] = f.read(30)
        hash[:artist] = f.read(30)
        hash[:album] = f.read(30)
        hash[:year] = f.read(4)
        hash[:comment] = f.read(30)
        hash[:genre] = f.read(1)
      else
        puts "no ID3 tag for this mp3"
      end
      puts hash
    end
  end
end
m = MP3_INFO.new
m.dir_entries
m.encoding
