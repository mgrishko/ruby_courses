require 'parseexcel'

class ParseExcelDataIntoCounties < ActiveRecord::Migration
  def self.up
    workbook = Spreadsheet::ParseExcel.parse('data/GPC_v2007-12-10_brick_translated_2008-03-12.xls')
    worksheet = workbook.worksheet(0)

    i = 'g'[0] - 'a'[0]
    k = 'i'[0] - 'a'[0]

    1.upto(worksheet.count) do |n|
      Gpc.create(
        :gpc_id => worksheet.cell(n, i).to_i,
        :name => worksheet.cell(n, k).to_s('UTF-8')
      )
    end
  end

  def self.down
    Countries
  end
end
