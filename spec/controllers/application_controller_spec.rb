require 'spec_helper'
require 'active_resource/exceptions'

describe ApplicationController do
  describe "#current_account" do
    before(:each) { @account = Fabricate(:account, subdomain: "company") }

    it "returns account if account with current subdomain exists" do
      @account.activate!
      request.host = 'company.domain.com'
      controller.send(:current_account).should eql(@account)
    end

    it "returns nil if account with current subdomain does not exist" do
      request.host = 'unknown.domain.com'
      controller.send(:current_account).should be_nil
    end

    it "returns nil if account is not active" do
      request.host = 'company.domain.com'
      controller.send(:current_account).should be_nil
    end
  end

  describe "#current_membership" do
    before(:each) do
      @user1 = Fabricate(:user)
      @account1 = Fabricate(:account, owner: @user1, subdomain: "company1")
      @account1.activate!
      @membership1 = @account1.memberships.first

      @user2 = Fabricate(:user)
      @account2 = Fabricate(:account, owner: @user2, subdomain: "company2")
      @account2.activate!
      @membership2 = Fabricate(:membership, account: @account2, user: @user1, role: "editor")
    end

    it "returns current user membership with admin role" do
      controller.stub(:current_user).and_return(@user1)
      request.host = 'company1.domain.com'
      controller.send(:current_membership).should eql(@membership1)
      controller.send(:current_membership).role.should == "admin"
    end

    it "returns current user membership with editor role" do
      controller.stub(:current_user).and_return(@user1)
      request.host = 'company2.domain.com'
      controller.send(:current_membership).should eql(@membership2)
      controller.send(:current_membership).role.should == "editor"
    end

    it "returns nil if user has no membership" do
      controller.stub(:current_user).and_return(@user2)
      request.host = 'company1.domain.com'
      controller.send(:current_membership).should be_nil
    end
  end

  describe "#current_ability" do
    it "should be kind of MembershipAbility" do
      controller.stub(:current_membership).and_return(nil)
      controller.send(:current_ability).should be_kind_of(MembershipAbility)
    end
  end
  
  describe "rescue AccessDenied exception" do
    controller do
      def index
        raise CanCan::AccessDenied.new("Some access denied exception message.")
      end
    end

    login_account_as :viewer

    before(:each) { @account = Account.first }

    it "sets flash alert message" do
      get :index, subdomain: @account.subdomain
      flash[:alert].should eq("Some access denied exception message.")
    end

    it "redirects to account home page" do
      get :index, subdomain: @account.subdomain
      response.should redirect_to(home_url(subdomain: @account.subdomain))
    end
  end

  describe "rescue BSON::InvalidObjectId" do
    controller do
      def index
        raise BSON::InvalidObjectId.new("illegal ObjectId format: 34235625625")
      end
    end

    it "raises ResourceNotFound Error" do
      lambda { get :index }.should raise_exception(ActiveResource::ResourceNotFound)
    end
  end
end
