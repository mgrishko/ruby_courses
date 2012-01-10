class MembershipObserver < Mongoid::Observer
  def after_create(membership)
    if membership.invited_by && Membership.current != membership.user
      membership.log_event("create")
    end
  end
end