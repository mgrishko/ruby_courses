class AddFieldsToPackagingItem < ActiveRecord::Migration
  def self.up
    change_table :packaging_items do |t|
      t.integer :number_of_next_lower_item
      t.integer :number_of_bi_items
      t.boolean :despatch_unit
      t.boolean :invoice_unit
      t.boolean :order_unit
      t.boolean :consumer_unit
      t.integer :gross_weight
      t.integer :packaging_type
      t.integer :height
      t.integer :depth
      t.integer :width
    end
  end

  def self.down
    change_table :packaging_items do |t|
      t.remove :number_of_next_lower_item,
               :number_of_bi_items,
               :despatch_unit,
               :invoice_unit,
               :order_unit,
               :consumer_unit,
               :gross_weight,
               :packaging_type,
               :height,
               :depth,
               :width
    end
  end
end
