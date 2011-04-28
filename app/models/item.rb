class Item < ActiveRecord::Base
  include AASM

  has_many :base_items
  belongs_to :user
  has_many :comments, :conditions => '#{Comment.table_name}.user_id = #{self.send(:user_id)}'
  has_many :tags, :through => :clouds
  has_many :clouds

  has_many :retailer_attributes
  has_many :receivers

  aasm_column :status
  aasm_initial_state :add

  aasm_state :add
  aasm_state :change

  aasm_event :change do
    transitions :to => :change, :from => :add, :guard => :not_new?
  end

  def not_new?
    if self.base_items.count(:conditions => {:status => 'published'}) > 1
      return true
    else
      return nil
    end
  end

  def last_bi
    BaseItem.find_by_sql(
      "select a.* from base_items as a where a.id = (select b.id from base_items b where a.item_id = b.item_id and b.status='published' and b.item_id = #{self.id} order by created_at desc limit 1) order by a.created_at desc limit 1"
    )
  end
end

# == Schema Information
#
# Table name: items
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      not null
#  created_at :datetime
#  updated_at :datetime
#  status     :string(255)     default("new"), not null
#

