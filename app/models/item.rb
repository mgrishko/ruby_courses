class Item < ActiveRecord::Base
  include AASM

  has_many :base_items
  belongs_to :user
  has_many :comments, :conditions => '#{Comment.table_name}.user_id = #{self.send(:user_id)}'
  has_many :tags, :through => :clouds
  has_many :clouds

  has_many :retailer_attributes

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
end
