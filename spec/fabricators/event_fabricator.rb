Fabricator(:event) do
  user!
  action_name "create"
  trackable { Fabricate(:product) }
end
