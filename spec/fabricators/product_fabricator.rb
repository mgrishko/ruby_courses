Fabricator(:product) do
  account!
  name         { Faker::Product.product_name }
  manufacturer { Faker::Company.name[0..34] }
  brand        { Faker::Product.brand }
  description  { Faker::Lorem.paragraphs }
  visibility   "public"
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

Fabricator(:product_without_photo, from: :product) do
end

Fabricator(:product_with_photo, from: :product) do
  after_create do |product|
    product.photos << Fabricate(:photo, product: product)
  end
end
