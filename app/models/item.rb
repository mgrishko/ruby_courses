# == Schema Information
#
# Table name: items
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      not null
#  created_at :datetime
#  updated_at :datetime
#  status     :string(255)     default(""), not null
#

class Item < ActiveRecord::Base
  include AASM

  has_one :event, :as => :content
  has_many :base_items
  belongs_to :user
  has_many :comments , :conditions => "#{Comment.table_name}.root_id is null", :order => "id desc"
  has_many :item_comments, :class_name => 'Comment', :foreign_key => :item_id,:conditions => "#{Comment.table_name}.root_id is null", :order => "id desc"
  has_many :tags, :through => :clouds
  has_many :clouds
  has_many :retailer_attributes
  has_many :item_retailer_attributes, :class_name => 'RetailerAttribute', :foreign_key => :item_id

  aasm_column :status
  aasm_initial_state :add

  aasm_state :add
  aasm_state :change

  aasm_event :change do
    transitions :to => :change, :from => :add, :guard => :not_new?
  end

  def not_new?
    if self.base_items.where(:status => 'published').count() > 1
      return true
    else
      return nil
    end
  end

  # Strange behaviour: logically should return 1 last base item but in code used as returning array
  def last_bi
    self.base_items.where( :status => "published").order("id desc")
  end

  def subscribers
    sns = self.user.subscribers #subscriptions
    sns.collect {|s| s.retailer if (s.specific && s.find_in_details(self.id)) || (!s.specific)}.compact
  end

  def image_url suffix=nil
    image = Image.find(:first, :conditions => {:item_id => self.id}, :order => "id desc")
    return "/data/#{image.id}#{suffix.to_s}.jpg" if image
    "/images/item_image#{suffix.to_s}.jpg"
  end

end
