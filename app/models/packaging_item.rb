class PackagingItem < ActiveRecord::Base
  acts_as_nested_set :scope => :base_item
  default_scope :order => 'lft'

  belongs_to :base_item
  belongs_to :user

  #validates_presence_of :gtin
  #validates_gtin :gtin
  #validates_uniqueness_of :gtin, :scope => :user_id

  validates_number_length_of :number_of_next_lower_item, 6
  validates_number_length_of :number_of_bi_items, 6
  validates_number_length_of :gross_weight, 7
  validates_number_length_of :height, 5
  validates_number_length_of :depth, 5
  validates_number_length_of :width, 5

  validates_length_of :item_name_long_ru, :maximum => 35, :allow_nil => true

  validate :gross_weight_validation
  def gross_weight_validation
    parent_item = parent || base_item
    items_number = parent ? number_of_next_lower_item : number_of_bi_items
    errors.add('gross_weight', "must be greater or equal #{parent_item.gross_weight * items_number}") if items_number && gross_weight && gross_weight < parent_item.gross_weight * items_number
  end
  
  validate :package_volume_validation
  def package_volume_validation
    parent_item = parent || base_item
    items_number = parent ? number_of_next_lower_item : number_of_bi_items
    volume = width * height * depth if width && height && depth
    parent_volume = parent_item.width * parent_item.height * parent_item.depth
    errors.add_to_base("Volume of package must be greater or equal #{parent_volume * items_number}") if items_number && volume && volume < parent_volume * items_number
  end
  
  validate :children_dependencies
  def children_dependencies
    brutto = gross_weight
    volume = height*depth*width
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

  #after_save :set_descendants_number_of_bi_items
  #def set_descendants_number_of_bi_items
    #descendants.each do |item|
      #item.update_attribute(:number_of_bi_items, item.self_and_ancestors.inject(1) { |product, pi| product * pi.number_of_next_lower_item })
    #end if number_of_next_lower_item_changed?
  #end
end
