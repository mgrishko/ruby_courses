require 'spec_helper'

describe Product do
  let(:product) { Fabricate(:product) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_least(1).is_at_most(70) }
  it { should allow_mass_assignment_of(:name) }
  
  it { should validate_presence_of(:description) }
  it { should ensure_length_of(:description).is_at_least(5).is_at_most(1000) }
  it { should allow_mass_assignment_of(:description) }

  it { should validate_presence_of(:account) }
  it { should_not allow_mass_assignment_of(:account) }

  it "should belong to account" do
    account = Fabricate(:account)
    product = account.products.build
    product.account.should eql(account)
  end
end
