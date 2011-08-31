require 'spreadsheet'
class CountryData
  def initialize
  end
  def run
    country
  end
  def country
    puts 'Filling countries' unless Rails.env.cucumber?  or Rails.env.test?
    Country.delete_all
    Country.reset_column_information
    book = Spreadsheet.open('data/country_codelist_2009-12-05.xls')
    worksheet = book.worksheet(0)
    skip = 1
    ActiveRecord::Base.transaction do
      worksheet.each(skip) do |row|
        Country.create(
          :code => row.at(0).to_s,
          :description => row.at(2).to_s
        )
      end
    end
  end
end
