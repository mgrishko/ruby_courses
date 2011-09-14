class AddBrickDefinitionToGpcs < ActiveRecord::Migration
  def self.up
    add_column :gpcs, :brick_definition_en, :text
    add_column :gpcs, :brick_definition_ru, :text
  end

  def self.down
    remove_column :gpcs, :brick_definition_ru
    remove_column :gpcs, :brick_definition_en
  end
end
