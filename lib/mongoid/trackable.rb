module Mongoid::Trackable
  
  # Creates Event object that stores the information about 
  # an action that was performed with the trackable object
  def log_event(current_membership, action_name, child_object = nil)
    Event.create(account: current_membership.account, 
      user: current_membership.user, 
      type: action_name, 
      trackable: self,
      trackable_child_type: child_object.nil? ? nil : child_object.class.name
    )
  end
end