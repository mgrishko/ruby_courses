class ChangeContentPrecision < ActiveRecord::Migration
  def self.up
    change_column :base_items, :content, :decimal, :precision => 9, :scale => 3
  end

  def self.down
    change_column :base_items, :content, :decimal, :precision => 6, :scale => 3
  end
end
