FILEMANAGER = {
#  "xslt" => File.join(File.dirname(__FILE__), '..', 'lib', 'xslt'),
  "xml" => File.join(File.dirname(__FILE__), 'xml'),
  "xls" => File.join(File.dirname(__FILE__), 'xls')
}
require 'test/unit'
require 'xml2xls'

class Xml2xlsTest < Test::Unit::TestCase
  def test_7continent
    puts "\ntesting 7continent"
    Dir.entries(FILEMANAGER["xml"]).each do |file|
      next if file == "." or file == ".."
      puts "testing #{file}"
      f = File.basename(file, '.xml')
      xml = File.read File.join(FILEMANAGER["xml"], file)
      f_xls = Xml2xls.convert(xml, '7continent', "#{f}_7continent")
      xls = File.read f_xls[0].path
      true_xls = File.read File.join(FILEMANAGER["xls"], "#{f}_7continent.xls")
      assert_equal true, xls == true_xls
      puts "done."
    end
  rescue StandardError => e
    puts e
    puts e.backtrace
    exit  
  end

  def test_auchan
    puts "\ntesting auchan"
    Dir.entries(FILEMANAGER["xml"]).each do |file|
      next if file == "." or file == ".."
      puts "testing #{file}"
      f = File.basename(file, '.xml')
      xml = File.read File.join(FILEMANAGER["xml"], file)
      f_xls = Xml2xls.convert(xml, 'auchan', "#{f}_auchan")
      xls = File.read f_xls[0].path
      true_xls = File.read File.join(FILEMANAGER["xls"], "#{f}_auchan.xls")
      assert_equal true, xls == true_xls
      puts "done."
    end
  rescue StandardError => e
    puts e
    puts e.backtrace
    exit
  end

  def test_general
    puts "\ntesting general"
    Dir.entries(FILEMANAGER["xml"]).each do |file|
      next if file == "." or file == ".."
      puts "testing #{file}"
      f = File.basename(file, '.xml')
      xml = File.read File.join(FILEMANAGER["xml"], file)
      f_xls = Xml2xls.convert(xml, 'general', "#{f}_general")
      xls = File.read f_xls[0].path
      true_xls = File.read File.join(FILEMANAGER["xls"], "#{f}_general.xls")
      assert_equal true, xls == true_xls
      puts "done."
    end
  rescue StandardError => e
    puts e
    puts e.backtrace
    exit
  end
  def test_globus
    puts "\ntesting globus"
    Dir.entries(FILEMANAGER["xml"]).each do |file|
      next if file == "." or file == ".."
      puts "testing #{file}"
      f = File.basename(file, '.xml')
      xml = File.read File.join(FILEMANAGER["xml"], file)
      f_xls = Xml2xls.convert(xml, 'globus', "#{f}_globus")
      xls = File.read f_xls[0].path
      true_xls = File.read File.join(FILEMANAGER["xls"], "#{f}_globus.xls")
      assert_equal true, xls == true_xls
      puts "done."
    end
  rescue StandardError => e
    puts e
    puts e.backtrace
    exit
  end

  def test_lenta_all_attrs
    puts "\ntesting lenta"
    Dir.entries(FILEMANAGER["xml"]).each do |file|
      next if file == "." or file == ".."
      next if file !~ /^test/
      puts "testing #{file}"
      f = File.basename(file, '.xml')
      xml = File.read File.join(FILEMANAGER["xml"], file)
      f_xls = Xml2xls.convert(xml, 'lenta', "#{f}_lenta")
      assert_equal f_xls.empty?, true
      puts "done."
    end
  rescue StandardError => e
    puts e
    puts e.backtrace
    exit
  end
  def test_lenta_kraft
    puts "\ntesting lenta"
    Dir.entries(FILEMANAGER["xml"]).each do |file|
      next if file == "." or file == ".."
      next if file !~ /^kraft/
      puts "testing #{file}"
      f = File.basename(file, '.xml')
      xml = File.read File.join(FILEMANAGER["xml"], file)
      f_xls = Xml2xls.convert(xml, 'lenta', "#{f}_lenta")
      xls = File.read f_xls[0].path
      true_xls = File.read File.join(FILEMANAGER["xls"], "#{f}_lenta.xls")
      assert_equal true, xls == true_xls
      assert_equal f_xls.size, 50
      puts "done."
    end
  rescue StandardError => e
    puts e
    puts e.backtrace
    exit
  end
  
  def test_lenta_nestle
    puts "\ntesting lenta"
    Dir.entries(FILEMANAGER["xml"]).each do |file|
      next if file == "." or file == ".."
      next if file !~ /^Nestle/
      puts "testing #{file}"
      f = File.basename(file, '.xml')
      xml = File.read File.join(FILEMANAGER["xml"], file)
      f_xls = Xml2xls.convert(xml, 'lenta', "#{f}_lenta")
      xls = File.read f_xls[0].path
      true_xls = File.read File.join(FILEMANAGER["xls"], "#{f}_lenta.xls")
      assert_equal true, xls == true_xls
      assert_equal f_xls.size, 30
      puts "done."
    end
  rescue StandardError => e
    puts e
    puts e.backtrace
    exit
  end

  def test_lenta_with_comments_all_attrs
    puts "\ntesting lenta_with_comments"
    Dir.entries(FILEMANAGER["xml"]).each do |file|
      next if file == "." or file == ".."
      next if file !~ /^test/
      puts "testing #{file}"
      f = File.basename(file, '.xml')
      xml = File.read File.join(FILEMANAGER["xml"], file)
      f_xls = Xml2xls.convert(xml, 'lenta_with_comments', "#{f}_lenta_with_comments")
      assert_equal f_xls.empty?, true
      puts "done."
    end
  rescue StandardError => e
    puts e
    puts e.backtrace
    exit
  end
  def test_lenta_with_comments_kraft
    puts "\ntesting lenta_with_comments"
    Dir.entries(FILEMANAGER["xml"]).each do |file|
      next if file == "." or file == ".."
      next if file !~ /^kraft/
      puts "testing #{file}"
      f = File.basename(file, '.xml')
      xml = File.read File.join(FILEMANAGER["xml"], file)
      f_xls = Xml2xls.convert(xml, 'lenta_with_comments', "#{f}_lenta_with_comments")
      xls = File.read f_xls[0].path
      true_xls = File.read File.join(FILEMANAGER["xls"], "#{f}_lenta_with_comments.xls")
      assert_equal true, xls == true_xls
      assert_equal f_xls.size, 50
      puts "done."
    end
  rescue StandardError => e
    puts e
    puts e.backtrace
    exit
  end

  def test_lenta_with_comments_nestle
    puts "\ntesting lenta_with_comments"
    Dir.entries(FILEMANAGER["xml"]).each do |file|
      next if file == "." or file == ".."
      next if file !~ /^Nestle/
      puts "testing #{file}"
      f = File.basename(file, '.xml')
      xml = File.read File.join(FILEMANAGER["xml"], file)
      f_xls = Xml2xls.convert(xml, 'lenta_with_comments', "#{f}_lenta_with_comments")
      xls = File.read f_xls[0].path
      true_xls = File.read File.join(FILEMANAGER["xls"], "#{f}_lenta_with_comments.xls")
      assert_equal true, xls == true_xls
      assert_equal f_xls.size, 30
      puts "done."
    end
  rescue StandardError => e
    puts e
    puts e.backtrace
    exit
  end

  def test_magnit
    puts "\ntesting magnit"
    Dir.entries(FILEMANAGER["xml"]).each do |file|
      next if file == "." or file == ".."
      puts "testing #{file}"
      f = File.basename(file, '.xml')
      xml = File.read File.join(FILEMANAGER["xml"], file)
      f_xls = Xml2xls.convert(xml, 'magnit', "#{f}_magnit")
      xls = File.read f_xls[0].path
      true_xls = File.read File.join(FILEMANAGER["xls"], "#{f}_magnit.xls")
      assert_equal true, xls == true_xls
      puts "done."
    end
  rescue StandardError => e
    puts e
    puts e.backtrace
    exit
  end

  def test_x5
    puts "\ntesting x5"
    Dir.entries(FILEMANAGER["xml"]).each do |file|
      next if file == "." or file == ".."
      puts "testing #{file}"
      f = File.basename(file, '.xml')
      xml = File.read File.join(FILEMANAGER["xml"], file)
      f_xls = Xml2xls.convert(xml, 'x5', "#{f}_x5")
      xls = File.read f_xls[0].path
      true_xls = File.read File.join(FILEMANAGER["xls"], "#{f}_x5.xls")
      assert_equal true, xls == true_xls
      puts "done."
    end
  rescue StandardError => e
    puts e
    puts e.backtrace
    exit
  end
end
