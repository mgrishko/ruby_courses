class AddTranslatesToCountries < ActiveRecord::Migration
  def self.up
    Country.reset_column_information
    drop_table :countries
    create_table :countries do |t|
      t.string :code, :limit => 2
      t.timestamps
    end
    Country.create_translation_table! :description => :string


    workbook = Spreadsheet::ParseExcel.parse('data/country_codelist_2009-12-05.xls')
    worksheet = workbook.worksheet(0)

    skip = 1
    ActiveRecord::Base.transaction do
      worksheet.each(skip) do |row|
        I18n.locale = :en
        country = Country.create(
          :code => row.at(0).to_s('UTF-8'),
          :description => row.at(2).to_s('UTF-8')
        )
        I18n.locale = :ru
        country.update_attributes(:description => row.at(1).to_s('UTF-8'))
      end
    end
  end

  def self.down
    Country.drop_translation_table!
  end
end
