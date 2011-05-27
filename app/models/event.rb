class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :content, :polymorphic => true, :dependent => :destroy
  
  def self.log user, obj
    Event.create(:user_id => user.id, :content_type => obj.class.to_s, :content_id => obj.id)
  end

  def url(current_user)
    "<a href='#{self.content.get_url(current_user)}' title='#{self.content.get_title}'>#{self.content.get_description}</a>"
  end
end
