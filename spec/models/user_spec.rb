require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:time_zone) }

  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:first_name) }
  it { should allow_mass_assignment_of(:last_name) }
  it { should allow_mass_assignment_of(:time_zone) }
  it { should allow_mass_assignment_of(:locale) }

  it "should not require password confirmation" do
    user = Fabricate.build(:user, password_confirmation: nil)
    user.should be_valid
  end

  it "should accept nested attributes for account" do
    user = Fabricate.build(:user)
    account_attrs = Fabricate.attributes_for(:account)
    user.accounts.build(account_attrs)
    user.save!
    user.reload
    account = user.accounts.first
    account.subdomain.should == account_attrs[:subdomain]
  end
end
