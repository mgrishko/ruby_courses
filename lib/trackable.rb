module Trackable
  def log_event current_user, action_name
    return log_added(current_user) if action_name == "create"
    return log_updated(current_user) if action_name == "update"
    return log_destroyed(current_user) if action_name == "destroy"
  end
  
  def log_added(current_membership)
    Event.create(account: current_membership.account, user: current_membership.user, type: "added", trackable: self)
  end
  
  def log_updated(current_membership)
    Event.create(account: current_membership.account, user: current_membership.user, type: "updated", trackable: self)
  end
  
  def log_destroyed(current_membership)
    Event.create(account: current_membership.account, user: current_membership.user, type: "destroyed", trackable: self)
  end
end