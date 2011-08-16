require 'parseexcel'
class GpcCountryData
  def initialize
  end
  def run
    country
    gpc
  end
  def country
    puts 'Filling countries'
    workbook = Spreadsheet::ParseExcel.parse('data/country_codelist_2009-12-05.xls')
    worksheet = workbook.worksheet(0)
    skip = 1
    ActiveRecord::Base.transaction do
      worksheet.each(skip) do |row|
        country = Country.create(:code => row.at(0).to_s('UTF-8'))
        I18n.locale = :ru
        country.update_attributes(:description => row.at(1).to_s('UTF-8'))
        I18n.locale = :en
        country.update_attributes(:description => row.at(2).to_s('UTF-8'))
      end
    end
  end
  def gpc
    puts 'Filling GPC'
    workbook = Spreadsheet::ParseExcel.parse('data/gpc_2010-12-01.xls')
    worksheet = workbook.worksheet(0)
    skip = 1
    ActiveRecord::Base.transaction do
      worksheet.each(skip) do |row|
        Gpc.create(
          :code => row.at(6).to_i,
          :name => row.at(7).to_s('UTF-8'),
          :group => row.at(3).to_s('UTF-8'),
          :description => row.at(5).to_s('UTF-8'),
          :segment_description => row.at(1).to_s('UTF-8')
        )
      end
    end
  end
end
