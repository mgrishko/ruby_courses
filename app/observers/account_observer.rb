class AccountObserver < Mongoid::Observer
  def after_create(account)
    event = account.log_event(account.memberships.first, "create")
  end
end