Fabricator(:event) do
  user!
  type "create"
  trackable { Fabricate(:product) }
end
