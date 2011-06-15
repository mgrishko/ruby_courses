# == Schema Information
#
# Table name: packaging_items
#
#  id                                       :integer(4)      not null, primary key
#  base_item_id                             :integer(4)
#  parent_id                                :integer(4)
#  gtin                                     :string(255)
#  item_name_long_ru                        :string(255)
#  created_at                               :datetime
#  updated_at                               :datetime
#  user_id                                  :integer(4)
#  number_of_next_lower_item                :integer(4)
#  number_of_bi_items                       :integer(4)
#  despatch_unit                            :boolean(1)      default(FALSE)
#  invoice_unit                             :boolean(1)      default(FALSE)
#  order_unit                               :boolean(1)      default(FALSE)
#  consumer_unit                            :boolean(1)      default(FALSE)
#  gross_weight                             :integer(4)
#  packaging_type                           :string(255)
#  height                                   :integer(4)
#  depth                                    :integer(4)
#  width                                    :integer(4)
#  published                                :boolean(1)      default(FALSE)
#  rgt                                      :integer(4)
#  lft                                      :integer(4)
#  level_cache                              :integer(4)      default(0)
#  quantity_of_layers_per_pallet            :integer(4)      default(1)
#  quantity_of_trade_items_per_pallet_layer :integer(4)      default(1)
#  stacking_factor                          :integer(4)      default(1)
#

class PackagingItem < ActiveRecord::Base
  acts_as_nested_set :scope => :base_item
  default_scope :order => 'lft'

  belongs_to :base_item
  belongs_to :user

  #validates_presence_of :gtin
  #validates_gtin :gtin
  #validates_uniqueness_of :gtin, :scope => :user_id

  validate :check_gtin

  validates_number_length_of :number_of_next_lower_item, 6
  validates_number_length_of :number_of_bi_items, 6
  validates_number_length_of :gross_weight, 7
  validate :gross_weight_validation
  validates_number_length_of :height, 5
  validates_number_length_of :depth, 5
  validates_number_length_of :width, 5

  validates_numericality_of :quantity_of_layers_per_pallet, :greater_than => 0, :less_than_or_equal_to => 999, :if => :pallet?
  validates_numericality_of :quantity_of_trade_items_per_pallet_layer, :greater_than => 0, :less_than_or_equal_to => 999, :if => :pallet?
  validates_numericality_of :stacking_factor, :greater_than => 0, :less_than_or_equal_to => 999, :if => :pallet?

  validates_length_of :item_name_long_ru, :maximum => 35, :allow_nil => true

  def check_gtin
    errors.add(:gtin, "Уже существует") if PackagingItem.joins(:base_item).where("base_items.item_id != ? and packaging_items.user_id = ? and packaging_items.gtin = ? and base_items.status = 'published'", self.base_item.item_id, self.user_id, self.gtin).count() > 0 # versions
    errors.add(:gtin, "Уже существует") if PackagingItem.where("base_item_id=? and id != ? and gtin = ?", self.base_item_id, self.id, self.gtin).count() > 0 # same PI tree
    errors.add(:gtin, "Уже существует") if BaseItem.where(:user_id => self.user_id, :gtin => self.gtin, :status => 'published').count() > 0 # bi
    errors.add(:gtin, "Уже существует") if self.gtin.to_s == self.base_item.gtin.to_s
  end

  def gross_weight_validation
    parent_item = parent || base_item
    items_number = parent ? number_of_next_lower_item : number_of_bi_items
    if items_number && gross_weight && gross_weight < parent_item.gross_weight * items_number
      errors.add('gross_weight', "must be greater or equal #{parent_item.gross_weight * items_number}")
    end
  end

  validate :package_volume_validation
  def package_volume_validation
    parent_item = parent || base_item
    items_number = parent ? number_of_next_lower_item : number_of_bi_items
    volume = width * height * depth if width && height && depth
    parent_volume = parent_item.width * parent_item.height * parent_item.depth
    if items_number && volume && volume < parent_volume * items_number
      errors.add_to_base("Volume of package must be greater or equal #{parent_volume * items_number}")
    end
  end

  validate :children_dependencies
  def children_dependencies
    brutto = gross_weight||0
    volume = (height||0)*(depth||0)*(width||0)
    children.each do |child|
      if child.number_of_next_lower_item*brutto > child.gross_weight
      	errors.add_to_base("Gross Weight is more than child gross weight")
      end
      if child.number_of_next_lower_item*volume > child.height*child.depth*child.width
	      errors.add_to_base("Volume is more than child volume")
      end
    end
  end

  before_validation :set_number_of_bi_items
  after_create :move_to_parent#, :attach_to_user
  after_move :set_level_cache

  def move_to_parent
    move_to_child_of parent_id if parent_id
  end

  #def attach_to_user
    #update_attribute(:user_id, base_item.user_id)
  #end

  def set_level_cache
    update_attribute(:level_cache, level)
  end

  def set_number_of_bi_items
    puts "set_number_of_bi_items"
    self.number_of_bi_items = ancestors.inject(1) { |product, pi| product * pi.number_of_next_lower_item } * number_of_next_lower_item if number_of_next_lower_item
    #self.number_of_bi_items = ancestors.inject(1) { |product, pi| product * pi.number_of_next_lower_item } * number_of_next_lower_item if number_of_next_lower_item && number_of_next_lower_item_changed?
  end

  # methods calculate_* for view (highlighting)
  def calculate_quantity
    "#{number_of_next_lower_item},#{number_of_bi_items}"
  end

  def calculate_pallet
    "#{quantity_of_layers_per_pallet},#{quantity_of_trade_items_per_pallet_layer},#{stacking_factor}"
  end

  def calculate_weights
    "#{gross_weight},#{net_weight}"

  end

  def calculate_dimensions
    "#{height}x#{width}x#{depth}"
  end

  def net_weight
    base_item.net_weight* number_of_bi_items
  end

  def first?
    parent.nil? or parent.lft==self.lft-1
  end

  def last?
    parent.nil? or parent.rgt==self.rgt+1
  end

  def pallet?
    packaging_type == 'PX'
  end

  #after_save :set_descendants_number_of_bi_items
  #def set_descendants_number_of_bi_items
    #descendants.each do |item|
      #item.update_attribute(:number_of_bi_items, item.self_and_ancestors.inject(1) { |product, pi| product * pi.number_of_next_lower_item })
    #end if number_of_next_lower_item_changed?
  #end
end

