class Admin::BaseItemsController < Terbium::Controller::Base
  before_filter :require_admin

  index do
    field :gtin
    field :name
    field :status
    field 'user.gln'
    field 'gpc.name'
    field 'country_of_origin.description'
  end

  form do
    field :gtin
    field :name
    field :status
    field :user, :fields => [:gln]
    field :internal_item_id
    field :item_name_long_ru
    field :item_name_long_en
    field :despatch_unit
    field :invoice_unit
    field :order_unit
    field :consumer_unit
    field :manufacturer_name
    field :manufacturer_gln
    field :content_uom
    field :gross_weight
    field :vat
    field :plu_description
    field :gpc, :fields => [:code, :name]
    field :country_of_origin, :fields => [:code, :description]
    field :minimum_durability_from_arrival
    field :packaging_type
    field :height
    field :depth
    field :width
    field :content
  end

end
