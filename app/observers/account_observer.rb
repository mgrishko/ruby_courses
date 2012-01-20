class AccountObserver < Mongoid::Observer
  def after_create(account)
    #account.log_event("create")
  end
end