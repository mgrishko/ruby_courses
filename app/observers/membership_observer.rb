class MembershipObserver < Mongoid::Observer
  def after_create(membership)
    event = membership.account.log_event(membership.account.memberships.first, "create", membership)
  end
end