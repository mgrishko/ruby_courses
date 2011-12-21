require 'spec_helper'

describe ProductCode do

  let(:product_code) { Fabricate(:product_code) }

  it { should validate_presence_of(:name) }
  it { should allow_value("FOR_INTERNAL_USE_1").for(:name) }
  it { should_not allow_value("unknown").for(:name) }
  it { should allow_mass_assignment_of(:name) }

  it { should validate_presence_of(:value) }
  it { should ensure_length_of(:value).is_at_least(1).is_at_most(80) }
  it { should allow_mass_assignment_of(:value) }

  it "should be embedded in product" do
    product = Fabricate(:product)
    product_code = product.product_codes.build
    product_code.product.should eql(product)
  end
end