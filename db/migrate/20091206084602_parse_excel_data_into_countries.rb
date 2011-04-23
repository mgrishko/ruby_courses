require 'parseexcel'

class ParseExcelDataIntoCountries < ActiveRecord::Migration
  def self.up

    workbook = Spreadsheet::ParseExcel.parse('data/country_codelist_2009-12-05.xls')
    worksheet = workbook.worksheet(0)

    i = 'a'[0] - 'a'[0]
    k = 'b'[0] - 'a'[0]

    ActiveRecord::Base.transaction do
      1.upto(worksheet.count - 1) do |n|
        Country.create(
          :code => worksheet.cell(n, i).to_s('UTF-8'),
          :description => worksheet.cell(n, k).to_s('UTF-8')
        )
      end
    end

  end

  def self.down
    Country.delete_all
  end
end
