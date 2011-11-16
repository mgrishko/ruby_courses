require 'spec_helper'

describe MembershipsController do
  it { should be_kind_of(MainController) }
  
  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:admin_membership)
  end

  context "as an account owner" do
    login_account_as :admin, account: { subdomain: "company" }
    
    describe "GET index" do
      it "assigns account memberships as @memberships" do
        memberships = MembershipDecorator.decorate(Account.where(subdomain: "company").first.memberships)
        get :index
        assigns(:memberships).should eq(memberships)
      end
      
      it "can't load memberships from other accounts" do
        another_account = Fabricate(:account, subdomain: "another")
        memberships = MembershipDecorator.decorate(Account.where(subdomain: "company").first.memberships)
        get :index
        assigns(:memberships).should eq(memberships)
      end
    end

    describe "GET edit" do
      it "redirects to home when edits his own membership" do
        membership = Account.where(subdomain: "company").first.memberships.first
        get :edit, :id => membership.id
        response.should redirect_to(root_url(subdomain: "company"))
      end
      
      it "can't edit memberships from another account" do
        another_account = Fabricate(:account, subdomain: "another")
        membership = another_account.memberships.first
        lambda { get :edit, :id => membership.id }.should raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "redirects to home when updates his own membership" do
          membership = Account.where(subdomain: "company").first.memberships.first
          put :update, :id => membership.id, :membership => {'role' => 'editor'}
          response.should redirect_to(root_url(subdomain: "company"))
        end

        it "can't update his own membership" do
          membership = Account.where(subdomain: "company").first.memberships.first
          put :update, :id => membership.id, :membership => {'role' => 'editor'}
          Account.where(subdomain: "company").first.memberships.first.role.should_not eq('editor')
        end
      end
    end

    describe "DELETE destroy" do
      it "doesn't destroy his own membership" do
        account = Account.where(subdomain: "company").first
        membership = account.memberships.first
        
        expect {
          delete :destroy, :id => membership.id
        }.to_not change(account.memberships, :count)
      end

      it "redirects to the home" do
        membership = Account.where(subdomain: "company").first.memberships.first
        delete :destroy, :id => membership.id
        response.should redirect_to(root_url(subdomain: "company"))
      end
    end
  end
  
  context "as an account admin" do
    login_account_as :admin, account: { subdomain: "company" }
    
    # Make current user the owner of the current account and make another user in the account an editor
    before(:each) do
      @current_account.owner = @current_user
      @current_account.memberships.select{|m|m.user == @current_user}.first.role = "admin"
      @current_account.memberships.select{|m|m.user != @current_user}.first.role = "editor"
      @current_account.save!
    end
    
    describe "GET index" do
      it "assigns all memberships as @memberships" do
        memberships = MembershipDecorator.decorate(Account.where(subdomain: "company").first.memberships)
        get :index
        assigns(:memberships).should eq(memberships)
      end
    end

    describe "GET edit" do
      it "assigns the requested non-admin membership as @membership" do
        membership = Account.where(subdomain: "company").first.memberships.first
        get :edit, :id => membership.id
        assigns(:membership).should eq(membership)
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "redirects to memberships" do
          membership = Account.where(subdomain: "company").first.memberships.first
          put :update, :id => membership.id, :membership => {'role' => 'editor'}
          response.should redirect_to(memberships_url)
        end

        it "assigns the requested non-admin membership as @membership" do
          membership = Account.where(subdomain: "company").first.memberships.first
          put :update, :id => membership.id, :membership => valid_attributes
          assigns(:membership).should eq(membership)
        end

        it "can update non-admin membership" do
          membership = Account.where(subdomain: "company").first.memberships.first
          put :update, :id => membership.id, :membership => {'role' => 'viewer'}
          Account.where(subdomain: "company").first.memberships.first.role.should eq('viewer')
        end
      end

      describe "with invalid params" do
        it "assigns the membership as @membership" do
          membership = Account.where(subdomain: "company").first.memberships.first
          Membership.any_instance.stub(:save).and_return(false)
          put :update, :id => membership.id, :membership => {}
          assigns(:membership).should eq(membership)
        end

        it "re-renders the 'edit' template" do
          membership = Account.where(subdomain: "company").first.memberships.first
          Membership.any_instance.stub(:save).and_return(false)
          put :update, :id => membership.id, :membership => {}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys non-admin membership" do
        account = Account.where(subdomain: "company").first
        membership = account.memberships.first
        
        expect {
          delete :destroy, :id => membership.id
        }.to change(account.memberships, :count).by(-1)
      end

      it "redirects to memberships" do
        membership = Account.where(subdomain: "company").first.memberships.first
        delete :destroy, :id => membership.id
        response.should redirect_to(memberships_url)
      end
    end
  end
  
  context "as an editor" do
    login_account_as :editor, account: { subdomain: "company" }
    
    describe "GET index" do
      it "redirects to the home" do
        memberships = MembershipDecorator.decorate(Account.where(subdomain: "company").first.memberships)
        get :index
        response.should redirect_to(root_url(subdomain: "company"))
      end
    end

    describe "GET edit" do
      it "redirects to the home" do
        membership = Account.where(subdomain: "company").first.memberships.first
        get :edit, :id => membership.id
        response.should redirect_to(root_url(subdomain: "company"))
      end
    end

    describe "PUT update" do
      describe "redirects to the home" do
        it "updates the requested membership" do
          membership = Account.where(subdomain: "company").first.memberships.first
          put :update, :id => membership.id, :membership => {'role' => 'editor'}
          response.should redirect_to(root_url(subdomain: "company"))
        end
      end
      
      it "can update non-admin membership" do
        membership = Account.where(subdomain: "company").first.memberships.first
        put :update, :id => membership.id, :membership => {'role' => 'viewer'}
        Account.where(subdomain: "company").first.memberships.first.role.should_not eq('viewer')
      end
    end

    describe "DELETE destroy" do
      it "doesn't destroy a membership" do
        account = Account.where(subdomain: "company").first
        membership = account.memberships.first
        
        expect {
          delete :destroy, :id => membership.id
        }.to_not change(account.memberships, :count)
      end

      it "redirects to the home" do
        membership = Account.where(subdomain: "company").first.memberships.first
        delete :destroy, :id => membership.id
        response.should redirect_to(root_url(subdomain: "company"))
      end
    end
  end
end
