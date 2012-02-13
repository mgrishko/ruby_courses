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
  it { should_not allow_value("a@a.comm").for(:email) }
  it { should_not allow_value("a@a.ru").for(:email) }
  it { should_not allow_value("a@a.ru").for(:email) }
  it { should_not allow_value("a@a.r").for(:email) }
  it { should allow_value("aaa@aa.ru").for(:email) }
  it { should allow_value("a.b@aa.ru").for(:email) }
  it { should allow_value("A.b@aa.ru").for(:email) }
  it { should allow_mass_assignment_of(:email) }

  it { should validate_presence_of(:time_zone) }
  it { should_not allow_value("Invalid").for(:time_zone) }
  it { should allow_mass_assignment_of(:time_zone) }

  it { should validate_presence_of(:password) }
  it { should ensure_length_of(:password).is_at_least(6).is_at_most(128) }
  it { should allow_mass_assignment_of(:password) }

  it { should allow_mass_assignment_of(:locale) }
  
  it { should normalize_attribute(:first_name).from(" Jo  hn ").to("Jo hn") }
  it { should normalize_attribute(:last_name).from(" Smi  th ").to("Smi th") }

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
    account_attrs = Fabricate.attributes_for(:account, owner: user )
    user.accounts.build(account_attrs)
    user.save!
    user.reload
    account = user.accounts.first
    account.subdomain.should == account_attrs[:subdomain]
  end

  describe "#full_name" do
    it "should combine first and last name" do
      user = Fabricate(:user, first_name: "John", last_name: "Bon Jovi")
      user.full_name.should == "John Bon Jovi"
    end
  end

  describe "#short_name" do
    it "should combine first and first letter of last name" do
      user = Fabricate(:user, first_name: "John", last_name: "Cash")
      user.short_name.should == "John C."
    end
  end

  it "should have many events" do
    event = user.events.build
    event.user.should eql(user)
  end

  describe "#generate_password!" do
    before(:each) { user.generate_password! }

    it "generates password 8 characters length" do
      user.password.length.should == 8
    end

    it "uses only latin letters and digits" do
      user.password.should match(/^[A-Za-z0-9]+$/)
    end

    it "should have at least one digit" do
      user.password.should match(/(?=.*\d)/)
    end

    it "should have at least one upper case letter" do
      user.password.should match(/(?=.*[A-Z])/)
    end

    it "should have al least one lower case letter" do
      user.password.should match(/(?=.*[a-z])/)
    end
  end

  describe "#memberships" do
    before(:each) do
      account = Fabricate(:account)
      @owner_membership = account.memberships.first
      @user = @owner_membership.user
      @viewer_membership = Fabricate(:viewer_membership, user: @user)
    end

    it "should return all user memberships" do
      @user.memberships.should eq([@owner_membership, @viewer_membership])
    end

    it "should not return other user memberships" do
      other_membership = Fabricate(:membership)
      @user.memberships.should_not include(other_membership)
    end

  end
end
