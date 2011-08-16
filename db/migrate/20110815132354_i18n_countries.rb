class I18nCountries < ActiveRecord::Migration
  def self.up
    remove_column :countries, :description
    Country.create_translation_table! :description => :string
  end

  def self.down
    Country.drop_translation_table!
    add_column :countries, :description, :string
  end
end
