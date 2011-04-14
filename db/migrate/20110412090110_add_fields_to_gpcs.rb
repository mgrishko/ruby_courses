require 'parseexcel'

class AddFieldsToGpcs < ActiveRecord::Migration
  def self.up
    add_column :gpcs, :segment_description, :string
    add_column :gpcs, :description, :string
    
    Gpc.reset_column_information
    Gpc.delete_all
    
    workbook = Spreadsheet::ParseExcel.parse('data/gpc_2010-12-01.xls')
    worksheet = workbook.worksheet(0)

    skip = 1
    worksheet.each(skip) do |row|
      Gpc.create(
        :code => row.at(6).to_i,
        :name => row.at(7).to_s('UTF-8'),
        :description => row.at(3).to_s('UTF-8') + ' ' + row.at(5).to_s('UTF-8'),
        :segment_description => row.at(1).to_s('UTF-8')
      )
    end
  end

  def self.down
    remove_column :gpcs, :description
    remove_column :gpcs, :segment_description
  end
end