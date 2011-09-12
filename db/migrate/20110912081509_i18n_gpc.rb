class I18nGpc < ActiveRecord::Migration
  def self.up
    rename_column :gpcs, :name, :brick_en
    rename_column :gpcs, :segment_description, :segment_description_en
    rename_column :gpcs, :description, :class_description_en
    rename_column :gpcs, :group, :family_description_en
    add_column :gpcs, :brick_ru, :string
    add_column :gpcs, :segment_description_ru, :string
    add_column :gpcs, :class_description_ru, :string
    add_column :gpcs, :family_description_ru, :string
  end

  def self.down
    remove_column :gpcs, :family_description_ru
    remove_column :gpcs, :class_description_ru
    remove_column :gpcs, :segment_description_ru
    remove_column :gpcs, :brick_ru
    rename_column :gpcs, :family_description_en, :group
    rename_column :gpcs, :class_description_en, :description
    rename_column :gpcs, :segment_description_en, :segment_description
    rename_column :gpcs, :brick_en, :name
  end
end
