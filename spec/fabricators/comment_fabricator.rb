Fabricator(:comment) do
  user!
  commentable { Fabricate(:product) }
  body { Faker::Lorem.sentence }
end
