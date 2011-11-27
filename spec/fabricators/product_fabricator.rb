Fabricator(:product) do
  account!
  name        { Faker::Product.product_name }
  description { Faker::Lorem.paragraphs }
end

Fabricator(:product_with_comments, from: :product) do
  after_build do |product|
    current_user = Fabricate(:user)
    product.comments.build(Fabricate.attributes_for(:comment, commentable: nil))
    product.comments.each { |c| c.user = current_user }
  end
end
