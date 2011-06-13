class RetailerAttribute < ActiveRecord::Base
  has_one :event, :as => :content, :dependent => :destroy

  belongs_to :user
  belongs_to :item
  belongs_to :base_item

  def get_url(current_user)
    if current_user.retailer?
      "/base_items/#{self.base_item_id}?view=true"
    else
      "/base_items/#{self.base_item_id}"
    end
  end

  def get_title
    self.base_item.item_description
  end

  def get_description
    r = ''
    r = r + "#{self.retailer_article_id}" if self.retailer_article_id.to_s.length > 0
    r = r + ", #{self.retailer_item_description}" if self.retailer_item_description.to_s.length > 0
    r = r + ", #{self.retailer_classification}" if self.retailer_classification.to_s.length > 0
  end

end

