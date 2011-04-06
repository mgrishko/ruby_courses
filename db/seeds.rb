puts "Making 2 admins (u/p): 1234/1234 & 4321/1234"

User.delete_all
[
   {:id => 1,
    :gln => 1234,
    :password => '1234',
    :password_confirmation => '1234',
    :is_admin => 1,
    :name => 'Продуктовая Компания',
    :role => 'supplier'},
   {:id => 2,
    :gln => 4321,
    :password => '1234',
    :password_confirmation => '1234',
    :is_admin => 1,
    :name => 'Море Вкуса',
    :role => 'retailer'
  }
].each do |user|
  u = User.new(user)
  u.id = user[:id]
  u.save
end
puts "ok"

puts "Making 3 Items"

Item.delete_all
[
  {:id => 1,
  :user_id => 1
  },
  {:id => 2,
  :user_id => 1
  },
  {:id => 3,
  :user_id => 1
  }
].each do |item|
  i = Item.new(item)
  i.id = item[:id]
  i.save
end

puts "Making 3 BI"

BaseItem.delete_all
[{
  :id => 1,
  :gtin => '4607085440385',
  :name	=> 'Nescafe Classic',
  :status => 'piblished',
  :user_id => '1',
  :internal_item_id => '1',
  :item_name_long_ru => 'Кофе Нескафе Классик',
  :item_name_long_en => 'Coffee Nescaffe Classic',
  :despatch_unit    => 1,
  :invoice_unit	  => 0,
  :order_unit => 0,
  :consumer_unit => 0,
  :manufacturer_name => 'Nestle',
  :manufacturer_gln => '1000000000001',
  :content_uom => 'PCE',
  :gross_weight => '1',
  :vat => '57',
  :plu_description => '10',
  :gpc_code => '10000115',
  :country_of_origin_code => 'CH',
  :minimum_durability_from_arrival => '10',
  :packaging_type => 'CX',
  :height => '1',
  :depth => '1',
  :width => '1',
  :content => '1.000',
  :brand  => 'Nestle',
  :subbrand => '',
  :functional => 'N',
  :item_description => '',
  :item_id => 1
}, {
  :id => 2,
  :gtin => '9785249003791',
  :name => 'Nesquick',
  :status => 'published',
  :user_id => '1',
  :internal_item_id => '2',
  :item_name_long_ru => 'Какао Несквик',
  :item_name_long_en => 'Cocoa Nesquick',
  :despatch_unit => '0',
  :invoice_unit => '1',
  :order_unit => '0',
  :consumer_unit => '0',
  :manufacturer_name => 'Nestle',
  :manufacturer_gln => '1000000000001',
  :content_uom => 'PCE',
  :gross_weight => '3',
  :vat => '57',
  :plu_description => '10',
  :gpc_code => '10000179',
  :country_of_origin_code => 'CH',
  :minimum_durability_from_arrival => '11',
  :packaging_type => 'CX',
  :height => '2',
  :depth => '2',
  :width => '2',
  :content => '1.000',
  :brand  => 'Nestle',
  :subbrand => '',
  :functional => 'CN',
  :item_description => '',
  :item_id => 2

}, {
  :id => 3,
  :gtin => '4607003953133',
  :name => 'Brookbond Tea',
  :status => 'published',
  :user_id =>  '2',
  :internal_item_id => '8',
  :item_name_long_ru => 'Чай Брукбонд',
  :item_name_long_en => 'Brookbond Tea',
  :despatch_unit => '0',
  :invoice_unit => '1',
  :order_unit => '0',
  :consumer_unit => '0',
  :manufacturer_name => 'Brook',
  :manufacturer_gln => '1000000000008',
  :content_uom => 'SET',
  :gross_weight => '2',
  :vat => '57',
  :plu_description => '1',
  :gpc_code => '10000116',
  :country_of_origin_code => 'RU',
  :minimum_durability_from_arrival => '4',
  :packaging_type => 'CT',
  :height => '1',
  :depth => '1',
  :width => '1',
  :content => '1.000',
  :brand  => 'Brook Bond',
  :subbrand => '',
  :functional => 'TTT',
  :item_description => '',
  :item_id => 3
}].each do |base_item|
  bi = BaseItem.new(base_item)
  bi.id = base_item[:id]
  bi.save
  puts bi.errors.full_messages
end
puts "ok"


puts "Making 8 PI"
PackagingItem.delete_all

[
'|  1 |            1 |      NULL | 4607085440385 | Кофе Нескафе Классик | 2011-03-27 12:17:17 | 2011-03-27 12:17:17 |       1 |                         1 |                  1 |             1 |            0 |          0 |             0 |1| CX             |      1 |     2 |     2 |         0 |    6 |    1 |           0 | ',
'|  2 |            1 |         1 | 9785985032666 | Кофе Нескафе Классик | 2011-03-27 12:21:18 | 2011-03-27 12:21:18 |       1 |                         1 |                  1 |             1 |            0 |          0 |             0 |            1 | CX             |      2 |     2 |     2 |         0 |    5 |    2 |           1 | 
',
'|  3 |            1 |         2 | 9785945824898 | Кофе Нескафе Классик | 2011-03-27 12:22:20 | 2011-03-27 12:22:20 |       1 |                         1 |                  1 |             0 |            0 |          0 |             0 |            1 | CX             |      4 |     4 |     4 |         0 |    4 |    3 |           2 | 
',
'|  4 |            1 |      NULL | 9785402000049 | Кофе Нескафе Классик | 2011-03-27 12:23:14 | 2011-03-27 12:23:14 |       1 |                         2 |                  2 |             0 |            1 |          0 |             0 |            6 | BX             |      6 |     6 |     6 |         0 |    8 |    7 |           0 | 
',
'|  5 |            2 |      NULL | 9785249003791 | Какао Несквик              | 2011-03-27 12:31:46 | 2011-03-27 12:31:46 |       1 |                         1 |                  1 |             0 |            0 |          0 |             1 |            4 | BME            |      1 |     3 |     8 |         0 |    4 |    1 |           0 | 
',
'|  6 |            2 |         5 | 9785802919729 | Какао Несквик              | 2011-03-27 12:32:48 | 2011-03-27 12:32:48 |       1 |                         1 |                  1 |             0 |            0 |          1 |             0 |            6 | BK             |      3 |     3 |     3 |         0 |    3 |    2 |           1 | 
',
'|  7 |            3 |      NULL | 4607003953133 | Чай Брукбонд                | 2011-03-27 12:39:42 | 2011-03-27 12:39:42 |       2 |                         1 |                  1 |             0 |            0 |          0 |             1 |            2 | CT             |      1 |     1 |     1 |         0 |    4 |    1 |           0 | 
',
'|  8 |            3 |         7 | 4660000860286 | Чай Брукбонд                | 2011-03-27 12:42:24 | 2011-03-27 12:42:24 |       2 |                        10 |                 10 |             0 |            0 |          1 |             0 |           20 | PX             |      3 |     6 |     4 |         0 |    3 |    2 |           1 | 
'].each do |pi|
  start, id, base_item_id, parent_id, gtin, item_name_long_ru, created_at, updated_at, user_id, number_of_next_lower_item, number_of_bi_items, despatch_unit, invoice_unit, order_unit, consumer_unit, gross_weight, packaging_type, height, depth, width, published, rgt, lft, level_cache, finish = pi.chomp.split("|").map {|val| val.strip}
  #puts "GW: #{gross_weight}"
  #@base_item = User.find(user_id).base_items.find(base_item_id)
  #@packaging_item = @base_item.packaging_items.new(:base_item_id => base_item_id, :parent_id => parent_id ? parent_id : nil, :gtin => gtin, :item_name_long_ru => item_name_long_ru, :created_at => created_at, :updated_at => updated_at, :user_id => user_id, :number_of_next_lower_item => number_of_next_lower_item, :number_of_bi_items => number_of_bi_items, :despatch_unit => despatch_unit, :invoice_unit => invoice_unit, :order_unit => order_unit, :consumer_unit => consumer_unit, :gross_weight => gross_weight, :packaging_type => packaging_type, :height => height, :depth => depth, :width => width, :published => published, :rgt => rgt, :lft => lft, :level_cache => level_cache)
  #@packaging_item.user = current_user

  #@packaging_item.save

  p = PackagingItem.new(:id => id, :base_item_id => base_item_id, :parent_id => parent_id, :gtin => gtin, :item_name_long_ru => item_name_long_ru, :created_at => created_at, :updated_at => updated_at, :user_id => user_id, :number_of_next_lower_item => number_of_next_lower_item, :number_of_bi_items => number_of_bi_items, :despatch_unit => despatch_unit, :invoice_unit => invoice_unit, :order_unit => order_unit, :consumer_unit => consumer_unit, :gross_weight => gross_weight, :packaging_type => packaging_type, :height => height, :depth => depth, :width => width, :published => published, :rgt => rgt, :lft => lft, :level_cache => level_cache)
  if (p.parent_id == 0) 
    p.parent_id = nil
  end
  p.id = id
  #puts p.inspect
  p.save
end

puts "ok"

=begin
*************************** 1. row ***************************
id: 1
base_item_id: 1
parent_id: NULL
gtin: 4607085440385
item_name_long_ru: Кофе Нескафе Классик
created_at: 2011-03-27 12:17:17
updated_at: 2011-03-27 12:17:17
user_id: 1
number_of_next_lower_item: 1
number_of_bi_items: 1
despatch_unit: 1
invoice_unit: 0
order_unit: 0
consumer_unit: 0
gross_weight: 1
packaging_type: CX
height: 1
depth: 2
width: 2
published: 0
rgt: 6
lft: 1
level_cache: 0
*************************** 2. row ***************************
id: 2
base_item_id: 1
parent_id: 1
gtin: 9785985032666
item_name_long_ru: Кофе Нескафе Классик
created_at: 2011-03-27 12:21:18
updated_at: 2011-03-27 12:21:18
user_id: 1
number_of_next_lower_item: 1
number_of_bi_items: 1
despatch_unit: 1
invoice_unit: 0
order_unit: 0
consumer_unit: 0
gross_weight: 1
packaging_type: CX
height: 2
depth: 2
width: 2
published: 0
rgt: 5
lft: 2
level_cache: 1
*************************** 3. row ***************************
id: 3
base_item_id: 1
parent_id: 2
gtin: 9785945824898
item_name_long_ru: Кофе Нескафе Классик
created_at: 2011-03-27 12:22:20
updated_at: 2011-03-27 12:22:20
user_id: 1
number_of_next_lower_item: 1
number_of_bi_items: 1
despatch_unit: 0
invoice_unit: 0
order_unit: 0
consumer_unit: 0
gross_weight: 1
packaging_type: CX
height: 4
depth: 4
width: 4
published: 0
rgt: 4
lft: 3
level_cache: 2
*************************** 4. row ***************************
id: 4
base_item_id: 1
parent_id: NULL
gtin: 9785402000049
item_name_long_ru: Кофе Нескафе Классик
created_at: 2011-03-27 12:23:14
updated_at: 2011-03-27 12:23:14
user_id: 1
number_of_next_lower_item: 2
number_of_bi_items: 2
despatch_unit: 0
invoice_unit: 1
order_unit: 0
consumer_unit: 0
gross_weight: 6
packaging_type: BX
height: 6
depth: 6
width: 6
published: 0
rgt: 8
lft: 7
level_cache: 0
*************************** 5. row ***************************
id: 5
base_item_id: 2
parent_id: NULL
gtin: 9785249003791
item_name_long_ru: Какао Несквик
created_at: 2011-03-27 12:31:46
updated_at: 2011-03-27 12:31:46
user_id: 1
number_of_next_lower_item: 1
number_of_bi_items: 1
despatch_unit: 0
invoice_unit: 0
order_unit: 0
consumer_unit: 1
gross_weight: 4
packaging_type: BME
height: 1
depth: 3
width: 8
published: 0
rgt: 4
lft: 1
level_cache: 0
*************************** 6. row ***************************
id: 6
base_item_id: 2
parent_id: 5
gtin: 9785802919729
item_name_long_ru: Какао Несквик
created_at: 2011-03-27 12:32:48
updated_at: 2011-03-27 12:32:48
user_id: 1
number_of_next_lower_item: 1
number_of_bi_items: 1
despatch_unit: 0
invoice_unit: 0
order_unit: 1
consumer_unit: 0
gross_weight: 6
packaging_type: BK
height: 3
depth: 3
width: 3
published: 0
rgt: 3
lft: 2
level_cache: 1
*************************** 7. row ***************************
id: 7
base_item_id: 3
parent_id: NULL
gtin: 4607003953133
item_name_long_ru: Чай Брукбонд
created_at: 2011-03-27 12:39:42
updated_at: 2011-03-27 12:39:42
user_id: 2
number_of_next_lower_item: 1
number_of_bi_items: 1
despatch_unit: 0
invoice_unit: 0
order_unit: 0
consumer_unit: 1
gross_weight: 2
packaging_type: CT
height: 1
depth: 1
width: 1
published: 0
rgt: 4
lft: 1
level_cache: 0
*************************** 8. row ***************************
id: 8
base_item_id: 3
parent_id: 7
gtin: 4660000860286
item_name_long_ru: Чай Брукбонд 
created_at: 2011-03-27 12:42:24
updated_at: 2011-03-27 12:42:24
user_id: 2
number_of_next_lower_item: 10
number_of_bi_items: 10
despatch_unit: 0
invoice_unit: 0
order_unit: 1
consumer_unit: 0
gross_weight: 20
packaging_type: PX
height: 3
depth: 6
width: 4
published: 0
rgt: 3
lft: 2
level_cache: 1
=end

