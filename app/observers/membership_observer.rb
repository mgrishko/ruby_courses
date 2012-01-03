class MembershipObserver < Mongoid::Observer
  def after_create(membership)
    membership.log_event(membership, "create") unless membership.invited_by.nil?
  end
end