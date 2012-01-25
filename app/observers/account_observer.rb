class AccountObserver < Mongoid::Observer
  def after_create(account)
    Membership.current = account.memberships.first
    account.log_event("create")
  end
end