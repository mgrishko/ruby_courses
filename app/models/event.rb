class Event < ActiveRecord::Base
  belongs_to :content, :polymorphic => true, :dependent => :destroy
  
  def self.log user, obj
    Event.create(:user_id => user.id, :content_type => obj.class.to_s, :content_id => obj.id)
  end
end
