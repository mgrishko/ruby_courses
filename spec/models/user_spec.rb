require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }

  it { should validate_presence_of(:first_name) }
  it { should ensure_length_of(:first_name).is_at_most(50) }
  it { should allow_mass_assignment_of(:first_name) }

  it { should validate_presence_of(:last_name) }
  it { should ensure_length_of(:last_name).is_at_most(50) }
  it { should allow_mass_assignment_of(:last_name) }

  it { should validate_presence_of(:email) }
  it { should ensure_length_of(:email).is_at_most(50) }
  it { should_not allow_value("a@a.r").for(:email) }
  it { should allow_value("a@a.ru").for(:email) }
  it { should allow_value("a.b@a.ru").for(:email) }
  it { should allow_value("A.b@a.ru").for(:email) }
  it { should allow_mass_assignment_of(:email) }

  it { should validate_presence_of(:time_zone) }
  it { should_not allow_value("Invalid").for(:time_zone) }
  it { should allow_mass_assignment_of(:time_zone) }

  it { should allow_mass_assignment_of(:password) }
  it { should ensure_length_of(:password).is_at_least(5).is_at_most(20) }

  it { should allow_mass_assignment_of(:locale) }

  context "uniqueness validation" do
    before(:each) { Fabricate(:user, email: "taken@email.com") }

    it "should validate uniqueness of email case insensitive" do
      new_user = Fabricate.build(:user, email: "TAKEN@email.com")
      new_user.should_not be_valid
      new_user.should have_at_least(1).error_on(:email)
      new_user.email = "new@email.com"
      new_user.should be_valid
    end
  end

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
