Fabricator(:product) do
  account!
  functional_name { Faker::Product.product_name[0..34] }
  variant         { Faker::Product.product_name[0..34] }
  manufacturer { Faker::Company.name[0..34] }
  country_of_origin "US"
  brand        { Faker::Product.brand }
  sub_brand    { Faker::Product.brand }
  short_description  { Faker::Product.product_name }
  description  { Faker::Lorem.paragraphs }
  visibility   "public"
  gtin "01234567890123"
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

Fabricator(:product_with_tags, from: :product) do
  after_create do |product|
    product.tags << Fabricate(:tag, taggable: product)
  end
end

Fabricator(:private_product, from: :product) do
  visibility "private"
end
