# == Schema Information
#
# Table name: events
#
#  id           :integer         not null, primary key
#  user_id      :integer         not null
#  content_type :string(32)      not null
#  content_id   :integer         not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :content, :polymorphic => true, :dependent => :destroy

  scope :comments, where(:content_type => "Comment")
  scope :subscriptions, where(:content_type => "Subscription")
  scope :subscription_results, where(:content_type => "SubscriptionResult")
  scope :retailer_attributes, where(:content_type => "RetailerAttribute")

  def self.log user, obj
    Event.create(:user_id => user.id, :content_type => obj.class.to_s, :content_id => obj.id)
  end
end



