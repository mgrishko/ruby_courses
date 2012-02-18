#Modify your TextAnalyzer program to add the logging feature.
 
require 'logger'
 
class TextAnalizer
  def initialize
    $LOG = Logger.new('TextAnalizer.log', 'weekly')
    @lines = IO.readlines(choice_file)
    @text = @lines.join
    $LOG.info "New object created"
  end

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

  def line_count
    @lines.size
  end

  def all_characters
    @text.length
  end

  def all_characters_without_spaces
    @text.gsub(/\s*/, '').length
  end

  def all_words
    @text.scan(/\w+/).size
  end

  def sentence_count
    @text.scan(/\.|\?|!\.../).size
  end

  def paragraph_count
    @text.scan(/\n\n/).size
  end

  def average_sentences_per_paragraph
    begin
      sentence_count/paragraph_count
      rescue ZeroDivisionError
        $LOG.error "Division on null"
        puts "You don't have any paragraph's on your text"
      ensure
        puts "Please input correct text file"
    end
  end

  def average_words_in_sentences
    begin
      all_words/sentence_count
      rescue ZeroDivisionError
        $LOG.error "Division on null"
        puts "You don't have any sentence on your text"
      ensure
        puts "Please input correct text file"
    end
  end
end
t = TextAnalizer.new
t.dir_entries
puts t.all_words
puts t.average_sentences_per_paragraph
puts t.average_words_in_sentences

