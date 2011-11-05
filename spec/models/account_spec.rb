require 'spec_helper'

describe Account do
  let(:account) { Fabricate(:account) }

  it { should validate_presence_of(:subdomain) }
  it { should ensure_length_of(:subdomain).is_at_least(5).is_at_most(20) }
  it { should allow_value("subdomain12").for(:subdomain) }
  it { should allow_value("1subdomain").for(:subdomain) }
  it { should allow_value("UPPERcase").for(:subdomain) }
  it { should_not allow_value("sub domain").for(:subdomain) }
  it { should_not allow_value("sub.domain").for(:subdomain) }
  # Reserved subdomains
  it { should_not allow_value("www").for(:subdomain) }
  it { should_not allow_value("app").for(:subdomain) }
  it { should_not allow_value("secured").for(:subdomain) }
  it { should_not allow_value("admin").for(:subdomain) }
  it { should_not allow_value("dashboard").for(:subdomain) }
  it { should allow_mass_assignment_of(:subdomain) }

  it { should validate_presence_of(:company_name) }
  it { should ensure_length_of(:company_name).is_at_most(50) }
  it { should allow_mass_assignment_of(:company_name) }

  it { should validate_presence_of(:country) }
  it { should allow_value("US").for(:country) }
  it { should_not allow_value("ZZZ").for(:country) }
  it { should allow_mass_assignment_of(:country) }

  it { should validate_presence_of(:time_zone) }
  it { should_not allow_value("Invalid").for(:time_zone) }
  it { should allow_mass_assignment_of(:time_zone) }

  it { should allow_mass_assignment_of(:locale) }
  it { should_not allow_mass_assignment_of(:state) }

  context "uniqueness validation" do
    before(:each) { Fabricate(:account, subdomain: "taken") }

    it "should validate uniqueness of subdomain case insensitive" do
      new_account = Fabricate.build(:account, subdomain: "TAKEN")
      new_account.should_not be_valid
      new_account.should have_at_least(1).error_on(:subdomain)
      new_account.subdomain = "newsubdomain"
      new_account.should be_valid
    end
  end

  it "should have and belong to many users" do
    user = account.users.build
    user.accounts.should include(account)
  end

  describe "default values" do
    before(:each) do
      @user = Fabricate(:user, time_zone: "Auckland", locale: "de")
      @user.accounts.build(Fabricate.attributes_for(:account))
      @account = @user.accounts.first
      @account.save!
    end

    it "time zone should equal to the first user time zone" do
      @account.time_zone.should == @user.time_zone
    end

    it "locale should equal user to the first locale" do
      @account.locale.should == @user.locale
    end
  end

  describe "subdomain" do
    it "should be downcased before validation" do
      account.subdomain = "VALID"
      account.should be_valid
      account.subdomain.should == "valid"
    end
  end

  describe "state" do
    it "should be pending by default" do
      account.should be_pending
    end

    it "should be changed to active after activate event" do
      account.activate
      account.should be_active
    end
  end
end
