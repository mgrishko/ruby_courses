


Factory.define :country do |f|
  f.description 'Country name'
  f.code 'RU'
end

Factory.define :user do |f|
  f.password  ''
end

Factory.define :administrator, :parent => :user do |f|
  f.gln '1234'
  f.password  '1234'
  f.name "Administrator"
  f.password_confirmation '1234'
  f.roles ['admin']
end

Factory.define :supplier, :parent => :user do |f|
  f.gln '1234'
  f.password  '1234'
  f.name "Supplier"
  f.password_confirmation '1234'
  f.roles ['global_supplier']
end

Factory.define :another_supplier, :parent => :user do |f|
  f.gln '12345'
  f.password  '1234'
  f.name "Another Supplier"
  f.password_confirmation '1234'
  f.roles ['global_supplier']
end

Factory.define :retailer, :parent => :user do |f|
  f.gln '4321'
  f.password  '1234'
  f.name "Retailer"
  f.password_confirmation '1234'
  f.roles ['retailer']
end

Factory.define :another_retailer, :parent => :user do |f|
  f.gln '5678'
  f.password '1234'
  f.name "Another Retailer"
  f.password_confirmation '1234'
  f.roles ['retailer']
end

Factory.define :gpc do |f|
  f.code '10000115'
  f.name 'Some Name'
end

Factory.define :subscription do |f|
  f.association :retailer, :factory => :user
  f.association :supplier, :factory => :user
end

Factory.define :subscription_result do |f|
  f.association :subscription
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
  f.association :user, :factory => :supplier
  f.country_of_origin_code Factory(:country).code
  f.minimum_durability_from_arrival '10'
  f.packaging_type 'CN'
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

