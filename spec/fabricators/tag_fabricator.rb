Fabricator(:tag) do
  taggable { Fabricate(:product) }
  name     { Faker::Name.first_name }
end
