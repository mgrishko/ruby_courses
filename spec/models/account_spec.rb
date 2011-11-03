require 'spec_helper'

describe Account do
  let(:account) { Fabricate(:account) }

  it { should validate_presence_of(:subdomain) }
  it { should validate_presence_of(:company_name) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:time_zone) }

  it { should allow_mass_assignment_of(:subdomain) }
  it { should allow_mass_assignment_of(:company_name) }
  it { should allow_mass_assignment_of(:country) }
  it { should allow_mass_assignment_of(:time_zone) }
  it { should allow_mass_assignment_of(:locale) }
  it { should_not allow_mass_assignment_of(:state) }

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
