# == Schema Information
#
# Table name: packaging_items
#
#  id                                       :integer         not null, primary key
#  base_item_id                             :integer
#  parent_id                                :integer
#  gtin                                     :string(255)
#  item_name_long_ru                        :string(255)
#  created_at                               :datetime
#  updated_at                               :datetime
#  user_id                                  :integer
#  number_of_next_lower_item                :integer
#  number_of_bi_items                       :integer
#  despatch_unit                            :boolean         default(FALSE)
#  invoice_unit                             :boolean         default(FALSE)
#  order_unit                               :boolean         default(FALSE)
#  consumer_unit                            :boolean         default(FALSE)
#  gross_weight                             :integer
#  packaging_type                           :string(255)
#  height                                   :integer
#  depth                                    :integer
#  width                                    :integer
#  published                                :boolean         default(FALSE)
#  rgt                                      :integer
#  lft                                      :integer
#  level_cache                              :integer         default(0)
#  quantity_of_layers_per_pallet            :integer         default(1)
#  quantity_of_trade_items_per_pallet_layer :integer         default(1)
#  stacking_factor                          :integer         default(1)
#

# encoding = utf-8

class PackagingItem < ActiveRecord::Base
  acts_as_nested_set :scope => :base_item, :depth_column => 'level_cache'
  default_scope :order => 'lft'

  belongs_to :base_item
  belongs_to :user
  attr_accessor :packaging_name
  validates :gtin, :presence => true,
                   :numericality => {:only_integer => true}#,
                   #:gtin_format => true
  validate :check_gtin
  validates :packaging_type,
            :presence => true, :length => { :maximum => 3 }

  validates_number_length_of :number_of_next_lower_item, 6, :presence => true
  validates_number_length_of :number_of_bi_items, 6, :presence => true
  validates_number_length_of :gross_weight, 7, :presence => true
  validates_number_length_of :height, 5, :presence => true
  validates_number_length_of :depth, 5, :presence => true
  validates_number_length_of :width, 5, :presence => true

  validates_numericality_of :quantity_of_layers_per_pallet, :greater_than => 0, :less_than_or_equal_to => 999, :if => :pallet?
  validates_numericality_of :quantity_of_trade_items_per_pallet_layer, :greater_than => 0, :less_than_or_equal_to => 999, :if => :pallet?
  validates_numericality_of :stacking_factor, :greater_than => 0, :less_than_or_equal_to => 999, :if => :pallet?

  validates_length_of :item_name_long_ru, :maximum => 35, :allow_nil => true

  def check_gtin
    unless self.gtin == '00000000000000'
      errors.add(:gtin, I18n.t('item.already_exists')) if PackagingItem.joins(:base_item).where("base_items.item_id != ? and packaging_items.user_id = ? and packaging_items.gtin = ? and base_items.status = 'published'", self.base_item.item_id, self.user_id, self.gtin).count() > 0 # versions
      errors.add(:gtin, I18n.t('item.already_exists')) if PackagingItem.where("base_item_id=? and id != ? and gtin = ?", self.base_item_id, self.id, self.gtin).count() > 0 # same PI tree
      errors.add(:gtin, I18n.t('item.already_exists')) if BaseItem.where(:user_id => self.user_id, :gtin => self.gtin, :status => 'published').count() > 0 # bi
      errors.add(:gtin, I18n.t('item.already_exists')) if self.gtin.to_s == self.base_item.gtin.to_s
    end
  end

  def gross_weight_validation
    parent_item = parent || base_item
    items_number = parent ? number_of_next_lower_item : number_of_bi_items
    if items_number && gross_weight && (gross_weight.to_f < (0.96*parent_item.gross_weight * items_number ).to_f)
      errors.add('gross_weight', "must be greater or equal #{(0.96*parent_item.gross_weight * items_number)}")
    end
  end

  validate :package_volume_validation
  def package_volume_validation
#    parent_item = parent || base_item
#    items_number = parent ? number_of_next_lower_item : number_of_bi_items
#    volume = width * height * depth if width && height && depth
#    parent_volume = parent_item.width * parent_item.height * parent_item.depth
#    if items_number && volume && volume < parent_volume * items_number
#      errors.add_to_base("Volume of package must be greater or equal #{parent_volume * items_number}")
#    end
    parent_item = parent || base_item
    volume = width * height * depth if width && height && depth
    parent_volume = parent_item.width * parent_item.height * parent_item.depth
    if volume and (volume < parent_volume)
      errors.add_to_base("Volume of package must be greater or equal #{parent_volume}")
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
    update_attributes(:level_cache => level)
  end

  def set_number_of_bi_items
    self.number_of_bi_items = ancestors.inject(1) { |product, pi| product * pi.number_of_next_lower_item } * number_of_next_lower_item if number_of_next_lower_item
    #self.number_of_bi_items = ancestors.inject(1) { |product, pi| product * pi.number_of_next_lower_item } * number_of_next_lower_item if number_of_next_lower_item && number_of_next_lower_item_changed?
  end


  def calculate_packaging_type
    pt = BaseItem.packaging_types.detect{|pt| pt[:code]== packaging_type}
    pt.present? ? pt[:name] : packaging_type
  end

  # methods calculate_* for view (highlighting)
  def calculate_quantity
    "#{number_of_next_lower_item},#{number_of_bi_items}"
  end

  #actually used to compare previous and new versions values. and highlight if changed
  def calculate_pallet
    "#{quantity_of_layers_per_pallet},#{quantity_of_trade_items_per_pallet_layer},#{stacking_factor}"
  end

  def calculate_number
    self.lft
  end

  #actually used to compare previous and new versions values.  and highlight if changed
#  def calculate_weights
#    "#{gross_weight},#{net_weight}"
#  end

  #actually used to compare previous and new versions values.  and highlight if changed
 # def calculate_dimensions
 #   "#{height}x#{width}x#{depth}"
 # end

  # calculates net_weight for PackagingItem based on base_item.net_weight and quantity of pi
  def net_weight
    base_item.net_weight.to_i* number_of_bi_items
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

  def self.get_base_width(pi)
    if pi.children.any?
      c = 0
      pi.children.each{|child|c+=get_base_width(child)}
      c
    else
      1
    end
  end

  #hide packaging code from user and show name instead
  def packaging_name= value
    self.packaging_type = value
    #self.packaging_type = BaseItem.packaging_types.detect{|pt| pt[:code] == value}[:code] if value.present?
    #@packaging_name = BaseItem.packaging_types.detect{|pt| pt[:code] == value}[:name] if value.present?
    #@packaging_name = value
  end

  def packaging_name
    BaseItem.packaging_types.detect{|pt| pt[:code] == packaging_type}[:name] if packaging_type.present?
  end
end

