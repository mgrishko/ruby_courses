


Factory.define :country do |f|
  f.description ''
  f.code 'RU'
end

Factory.define :user do |f|
  f.password  ''
  f.role ''
end

Factory.define :supplier, :parent => :user do |f|
  f.gln '1234'
  f.password  '1234'
  f.password_confirmation '1234'
  f.role 'supplier'
end

Factory.define :retailer, :parent => :user do |f|
  f.gln '4321'
  f.password  '1234'
  f.password_confirmation '1234'
  f.role 'retailer'
end

Factory.define :another_retailer, :parent => :user do |f|
  f.gln '5678'
  f.password '1234'
  f.password_confirmation '1234'
  f.role 'retailer'
end

Factory.define :gpc do |f|
  f.code '10000115'
  f.name 'Some Name'
end


Factory.define :base_item do |f|
  f.gtin  '4607085440385'
  f.item_description 'Nescafe Classic'
  f.status  'published'
  f.internal_item_id  '1'
  f.despatch_unit     1
  f.invoice_unit	   0
  f.order_unit 0
  f.consumer_unit 0
  f.manufacturer_name 'Nestle'
  f.manufacturer_gln '1000000000001'
  f.content_uom 'PCE'
  f.gross_weight '1'
  f.vat '57'
  f.gpc Factory(:gpc)# '10000115'
  f.user_id Factory(:supplier).id
  f.country_of_origin_code Factory(:country).code
  f.minimum_durability_from_arrival '10'
  f.packaging_type 'CX'
  f.height '1'
  f.depth '1'
  f.width '1'
  f.content '1.000'
  f.brand  'Nestle'
  f.subbrand  ''
  f.functional  'N'
  f.item_id  1
  f.net_weight 1
end

