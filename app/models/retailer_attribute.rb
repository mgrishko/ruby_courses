class RetailerAttribute < ActiveRecord::Base
  has_one :event, :as => :content

  belongs_to :user
  belongs_to :item
end

# == Schema Information
#
# Table name: retailer_attributes
#
#  id                        :integer(4)      not null, primary key
#  user_id                   :integer(4)      not null
#  item_id                   :integer(4)      not null
#  retailer_article_id       :integer(4)
#  retailer_classification   :string(255)
#  retailer_item_description :string(178)
#  retailer_comment          :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#

