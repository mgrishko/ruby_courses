Fabricator(:tag) do
  tagable { Fabricate(:product) }
  name    { Faker::Name.first_name }
end
