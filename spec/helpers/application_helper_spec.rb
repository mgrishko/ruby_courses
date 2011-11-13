require 'spec_helper'

describe ApplicationHelper do
  describe "#title" do
    it "sets content for head title" do
      helper.title "Home"
      helper.content_for(:head_title).should == 'Home'
    end

    it "sets content for body title" do
      helper.title "Home", :body => true
      helper.content_for(:body_title).should == "<h2>Home</h2>"
    end
  end

  describe "#current_account" do
    before(:each) { @account = Fabricate(:account, subdomain: "company") }

    it "returns account if account with current subdomain exists" do
      @account.activate!
      controller.request.host = 'company.domain.com'
      helper.current_account.should eql(@account)
    end

    it "returns nil if account with current subdomain does not exist" do
      controller.request.host = 'unknown.domain.com'
      helper.current_account.should be_nil
    end

    it "returns nil if account is not active" do
      controller.request.host = 'company.domain.com'
      helper.current_account.should be_nil
    end
  end

  describe "#current_membership" do
    before(:each) do
      @user1 = Fabricate(:user)
      @account1 = @user1.accounts.create(Fabricate.attributes_for(:account, subdomain: "company1"))
      @account1.activate!
      @membership1 = @account1.memberships.first

      @user2 = Fabricate(:user)
      @account2 = @user2.accounts.create(Fabricate.attributes_for(:account, subdomain: "company2"))
      @account2.activate!
      @membership2 = @account2.memberships.create(user: @user1, role: "editor")
    end

    it "returns current user membership with admin role" do
      helper.stub(:current_user).and_return(@user1)
      controller.request.host = 'company1.domain.com'
      helper.current_membership.should eql(@membership1)
      helper.current_membership.role.should == "admin"
    end

    it "returns current user membership with editor role" do
      controller.stub(:current_user).and_return(@user1)
      controller.request.host = 'company2.domain.com'
      helper.current_membership.should eql(@membership2)
      helper.current_membership.role.should == "editor"
    end

    it "returns nil if user has no membership" do
      controller.stub(:current_user).and_return(@user2)
      controller.request.host = 'company1.domain.com'
      helper.current_membership.should be_nil
    end
  end

  describe "#current_ability" do
    it "should be kind of MembershipAbility" do
      helper.stub(:current_membership).and_return(nil)
      helper.current_ability.should be_kind_of(MembershipAbility)
    end
  end
end