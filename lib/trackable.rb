module Trackable
  def log_event current_user, action_name
    return log_added(current_user) if action_name == "create"
    return log_updated(current_user) if action_name == "update"
    return log_destroyed(current_user) if action_name == "destroy"
  end
  
  def log_added(current_user)
    Event.create(account: self.account, user: current_user, type: "added", trackable: self) unless self.new_record?
  end
  
  def log_updated(current_user)
    Event.create(account: self.account, user: current_user, type: "updated", trackable: self) unless self.new_record?
  end
  
  def log_destroyed(current_user)
    Event.create(account: self.account, user: current_user, type: "destroyed", trackable: self) if self.destroyed?
  end
end