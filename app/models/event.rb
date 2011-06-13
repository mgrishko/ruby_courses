# == Schema Information
#
# Table name: events
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)      not null
#  content_type :string(32)      not null
#  content_id   :integer(4)      not null
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

  def url(current_user)
    "<a href='#{self.content.get_url(current_user)}' title='#{self.content.get_title}'>#{self.content.get_description}</a>".html_safe
  end
end

