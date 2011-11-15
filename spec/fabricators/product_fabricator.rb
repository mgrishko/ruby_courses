Fabricator(:product) do
  account!
  name        { Faker::Product.product_name }
  description { Faker::Lorem.paragraphs }
end

