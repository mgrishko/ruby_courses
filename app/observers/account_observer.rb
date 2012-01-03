class AccountObserver < Mongoid::Observer
  def after_create(account)
    account.log_event(account.memberships.first, "create")
  end
end