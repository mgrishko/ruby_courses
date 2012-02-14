require 'spec_helper'

describe Account do
  let(:account) { Fabricate(:account) }

  it { should validate_presence_of(:subdomain) }
  it { should ensure_length_of(:subdomain).is_at_least(3).is_at_most(32) }
  it { should allow_value("subdomain12").for(:subdomain) }
  it { should allow_value("1subdomain").for(:subdomain) }
  it { should allow_value("UPPERcase").for(:subdomain) }
  it { should_not allow_value("sub domain").for(:subdomain) }
  it { should_not allow_value("sub.domain").for(:subdomain) }
  # Reserved or censored subdomains
  it { should_not allow_value("www").for(:subdomain) }
  it { should_not allow_value(Settings.app_subdomain).for(:subdomain) }
  it { should_not allow_value("secured").for(:subdomain) }
  it { should_not allow_value("admin").for(:subdomain) }
  it { should_not allow_value("dashboard").for(:subdomain) }
  it { should_not allow_value("status").for(:subdomain) }
  it { should_not allow_value("api").for(:subdomain) }
  it { should_not allow_value("blog").for(:subdomain) }
  it { should_not allow_value("feedback").for(:subdomain) }
  it { should_not allow_value("support").for(:subdomain) }
  it { should_not allow_value("signin").for(:subdomain) }
  it { should_not allow_value("signup").for(:subdomain) }
  it { should_not allow_value("login").for(:subdomain) }
  it { should_not allow_value("test").for(:subdomain) }
  it { should_not allow_value("beta").for(:subdomain) }
  it { should_not allow_value("demo").for(:subdomain) }
  it { should_not allow_value("community").for(:subdomain) }
  it { should_not allow_value("help").for(:subdomain) }
  it { should_not allow_value("mail").for(:subdomain) }
  it { should_not allow_value("fuck").for(:subdomain) }
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

  it { should validate_presence_of(:owner) }
  it { should_not allow_mass_assignment_of(:owner) }

  it { should_not validate_presence_of(:website) }
  it { should ensure_length_of(:website).is_at_most(50) }
  it { should allow_mass_assignment_of(:website) }

  it { should_not validate_presence_of(:about_company) }
  it { should ensure_length_of(:about_company).is_at_most(250) }
  it { should allow_mass_assignment_of(:about_company) }

  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }
  
  it { should normalize_attribute(:subdomain).from(" subdomain ").to("subdomain") }
  it { should normalize_attribute(:company_name).from(" Com  pany ").to("Com pany") }
  it { should normalize_attribute(:website).from(" www.yandex.ru ").to("www.yandex.ru") }

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

  it "should belong to owner" do
    user = Fabricate(:user)
    account = user.accounts.build
    account.owner.should eql(user)
  end

  it "should embed many memberships" do
    membership = account.memberships.build
    membership.account.should eql(account)
  end

  it "should have many products" do
    product = account.products.build
    product.account.should eql(account)
  end
  
  it "should have many events" do
    event = account.events.build
    event.account.should eql(account)
  end
  
  it "should have name" do
    account.name.should == account.subdomain
  end

  describe "default values" do
    before(:each) do
      @user = Fabricate(:user, time_zone: "Auckland", locale: "de")
      @user.accounts.build(Fabricate.attributes_for(:account))
      @account = @user.accounts.first
    end

    it "time zone should equal to the first user time zone" do
      @account.save!
      @account.time_zone.should == @user.time_zone
    end

    it "locale should equal user to the first locale" do
      @account.save!
      @account.locale.should == @user.locale
    end

    it "first user should have an admin membership" do
      @account.save!
      membership = @account.memberships.first
      membership.user.should eql(@user)
      membership.role.should == "admin"
    end

    it "should create only one membership for owner" do
      @account.subdomain = nil
      @account.should_not be_valid
      @account.subdomain = "valid"
      @account.save
      @account.memberships.count.should == 1
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
