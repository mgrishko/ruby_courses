require 'spreadsheet'
class GpcData
  def initialize
  end
  def run
    gpc
  end
  def gpc
    puts 'Filling GPC' unless Rails.env.cucumber?  or Rails.env.test?
    Gpc.delete_all
    Gpc.reset_column_information
    book = Spreadsheet.open('data/gpc_pack.xls')
    worksheet = book.worksheet(0)
    skip = 1
    ActiveRecord::Base.transaction do
      worksheet.each(skip) do |row|
        Gpc.create(
          :code => row.at(6).to_i,
          :name => row.at(7).to_s,
          :group => row.at(3).to_s,
          :description => row.at(5).to_s,
          :segment_description => row.at(1).to_s
        )
      end
    end
  end
end
