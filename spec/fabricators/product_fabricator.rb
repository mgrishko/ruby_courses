Fabricator(:product) do
  account!
  name        { Faker::Product.product_name }
  description { Faker::Lorem.paragraphs }
end

Fabricator(:product_with_comments, from: :product) do
  after_build do |product|
    current_user = Fabricate(:user)
    comment = Comment.new(Fabricate.attributes_for(:comment, commentable: nil))
    comment.created_at = Time.now
    comment.user = current_user
    product.comments << comment
  end
end
