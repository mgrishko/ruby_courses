# require 'xml2xls/core_ext/string'
# require 'spreadsheet'
require 'tempfile'
module Xml2xls
  def self.make_stylesheet doc, filename
    tf = Tempfile.new(filename)
    tf.puts '<?xml version="1.0" encoding="utf-8"?><?mso-application progid="Excel.Sheet"?>' + doc
    tf.close
    return tf
  end
end