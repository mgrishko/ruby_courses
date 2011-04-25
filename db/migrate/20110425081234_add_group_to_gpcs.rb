require 'parseexcel'

class AddGroupToGpcs < ActiveRecord::Migration
  def self.up
    add_column :gpcs, :group, :string

    Gpc.reset_column_information
    Gpc.delete_all
    
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

  def self.down
    remove_column :gpcs, :group
  end
end