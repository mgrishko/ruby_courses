class Admin::PackagingItemsController < Terbium::Controller::Base
  before_filter :require_admin

  index do
    field :gtin
    field 'parent.gtin'
    field 'user.gln'
    field :item_name_long_ru
    field :number_of_next_lower_item
    field :number_of_bi_items
    field :published
  end

  form do
    field :base_item, :fields => [:gtin, :name]
    field :parent, :fields => [:gtin, :item_name_long_ru]
    field :gtin
    field :item_name_long_ru
    field :user, :fields => [:gln]
    field :number_of_next_lower_item
    field :despatch_unit
    field :invoice_unit
    field :order_unit
    field :consumer_unit
    field :gross_weight
    field :packaging_type
    field :height
    field :depth
    field :width
    field :number_of_bi_items
    field :published
  end

end
