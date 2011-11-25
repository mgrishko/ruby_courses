require 'spec_helper'

describe MembershipsController do
  it { should be_kind_of(MainController) }
  
  def valid_attributes
    @attrs ||= begin
      attrs = Fabricate.attributes_for(:admin_membership)
      attrs[:user_attributes] = Fabricate.attributes_for(:user)
      attrs.delete(:user)
      attrs.delete(:account)
      attrs
    end
  end

  describe "GET new" do
    login_account_as :admin, account: { subdomain: "company" }

    it "assigns a new membership as @membership" do
      get :new
      assigns(:membership).should be_a_new(MembershipDecorator)
    end
  end

  describe "POST create" do
    login_account_as :admin, account: { subdomain: "company" }

    describe "with valid params" do
      it "creates a new Membership" do
        account = Account.where(subdomain: "company").first
        account.memberships.count.should == 2
        post :create, :membership => valid_attributes
        account.reload.memberships.count.should == 3
      end

      it "sets membership invited by to current user" do
        post :create, :membership => valid_attributes
        assigns(:membership).invited_by.should eql(@current_user)
      end

      it "assigns a newly created membership as @membership" do
        post :create, :membership => valid_attributes
        assigns(:membership).should be_a(MembershipDecorator)
        assigns(:membership).should be_persisted
      end

      it "redirects to the account memberships" do
        post :create, :membership => valid_attributes
        response.should redirect_to(memberships_path)
      end
    end

    describe "with invalid params" do
      before(:each) do
        # Trigger the behavior that occurs when invalid params are submitted
        Membership.any_instance.stub(:save).and_return(false)
        Membership.any_instance.stub_chain(:errors, :empty?).and_return(false)
        controller.stub(:set_already_invited_error)
      end

      it "assigns a newly created but unsaved membership as @membership" do
        post :create, :membership => {}
        assigns(:membership).should be_a_new(MembershipDecorator)
      end

      it "re-renders the 'new' template" do
        post :create, :membership => {}
        response.should render_template("new")
      end
    end
  end

  describe "GET index" do
    login_account_as :admin, account: { subdomain: "company" }

    it "assigns all memberships as @memberships" do
      memberships = MembershipDecorator.decorate(Account.where(subdomain: "company").first.memberships)
      get :index
      assigns(:memberships).should eq(memberships)
    end
    
    it "doesn't show memberships of other account" do
      account = Fabricate(:active_account)
      memberships = MembershipDecorator.decorate(Account.where(subdomain: "company").first.memberships)
      get :index
      assigns(:memberships).should eq(memberships)
    end
  end

  describe "GET edit" do
    login_account_as :admin, account: { subdomain: "company" }
    
    it "assigns the requested non-admin membership as @membership" do
      membership = Account.where(subdomain: "company").first.memberships.first
      get :edit, :id => membership.id
      assigns(:membership).should eq(membership)
    end
  end

  describe "PUT update" do
    login_account_as :admin, account: { subdomain: "company" }

    describe "with valid params" do
      it "redirects to memberships" do
        membership = Fabricate(:admin_membership, account: @current_account)
        put :update, :id => membership.id, :membership => valid_attributes
        response.should redirect_to(memberships_url)
      end

      it "assigns the requested non-admin membership as @membership" do
        membership = Fabricate(:membership, {account: @current_account})
        put :update, id: membership.id, membership: valid_attributes
        assigns(:membership).should eq(membership)
      end
    end

    describe "with invalid params" do
      it "assigns the membership as @membership" do
        membership = Fabricate(:membership, account: @current_account)
        Membership.any_instance.stub(:save).and_return(false)
        Membership.any_instance.stub_chain(:errors, :empty?).and_return(false)
        put :update, :id => membership.id, :membership => {'these' => 'params'}
        assigns(:membership).should eq(membership)
      end

      it "re-renders the 'edit' template" do
        membership = Fabricate(:membership, account: @current_account)
        Membership.any_instance.stub(:save).and_return(false)
        Membership.any_instance.stub_chain(:errors, :empty?).and_return(false)
        put :update, :id => membership.id, :membership => {'these' => 'params'}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    login_account_as :admin, account: { subdomain: "company" }

    it "destroys non-admin membership" do
      membership = Fabricate(:membership, account: @current_account)

      expect {
        delete :destroy, :id => membership.id
      }.to change(@current_account.memberships, :count).by(-1)
    end

    it "redirects to memberships" do
      membership = Fabricate(:membership, account: @current_account)
      delete :destroy, :id => membership.id
      response.should redirect_to(memberships_url)
    end
  end
  
end
