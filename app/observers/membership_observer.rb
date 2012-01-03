class MembershipObserver < Mongoid::Observer
  def after_create(membership)
    if Membership.current && !membership.invited_by.nil?
      membership.account.log_event(Membership.current, "create", membership)
    end
  end
end