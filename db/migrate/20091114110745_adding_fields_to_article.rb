class AddingFieldsToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :internal_item_id, :string
    add_column :articles, :item_name_long_ru, :string
    add_column :articles, :item_name_long_en, :string
    add_column :articles, :despatch_unit, :boolean
    add_column :articles, :invoice_unit, :boolean
    add_column :articles, :order_unit, :boolean
    add_column :articles, :consumer_unit, :boolean
    add_column :articles, :manufacturer_name, :string
    add_column :articles, :manufacturer_gln, :integer
    add_column :articles, :content, :decimal, :precision => 9, :scale => 3
    add_column :articles, :content_uom, :integer
    add_column :articles, :gross_weight, :integer
    add_column :articles, :vat, :integer
    add_column :articles, :plu_description, :string
    add_column :articles, :gpc, :integer
    add_column :articles, :country_of_origin, :integer
    add_column :articles, :minimum_durability_from_arrival, :integer
    add_column :articles, :packaging_type, :integer
    add_column :articles, :height, :integer
    add_column :articles, :depth, :integer
    add_column :articles, :width, :integer
  end

  def self.down
    remove_column :articles, :internal_item_id
    remove_column :articles, :item_name_long_ru
    remove_column :articles, :item_name_long_en
    remove_column :articles, :despatch_unit
    remove_column :articles, :invoice_unit
    remove_column :articles, :order_unit
    remove_column :articles, :consumer_unit
    remove_column :articles, :manufacturer_name
    remove_column :articles, :manufacturer_gln
    remove_column :articles, :content
    remove_column :articles, :content_uom
    remove_column :articles, :gross_weight
    remove_column :articles, :vat
    remove_column :articles, :plu_description
    remove_column :articles, :gpc
    remove_column :articles, :country_of_origin
    remove_column :articles, :minimum_durability_from_arrival
    remove_column :articles, :packaging_type
    remove_column :articles, :height
    remove_column :articles, :depth
    remove_column :articles, :width
  end
end
