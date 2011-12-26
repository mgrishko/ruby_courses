Fabricator(:event) do
  user!
  action_name "create"
  account!
  trackable { |e| Fabricate(:product, account: e.account) }
  eventable { |e| e.trackable }
end
