require 'spec_helper'

describe Package do

  let(:package) { Fabricate(:package) }

  it "should be embedded in product" do
    product = Fabricate(:product)
    package = product.packages.build
    package.product.should eql(product)
  end

  it "should embeds many dimensions" do
    dimension = package.dimensions.build
    dimension.package.should eql(package)
  end

  it "should embeds many weights" do
    weight = package.weights.build
    weight.package.should eql(package)
  end

  it "should embeds many contents" do
    content = package.contents.build
    content.package.should eql(package)
  end
end