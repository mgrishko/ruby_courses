require 'spec_helper'

describe Users::AccountsController do
  with_subdomain Settings.app_subdomain

  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:account)
  end

  context "when authenticated user" do
    login :user

    describe "GET index" do
      #it "assigns all accounts as @accounts" do
      #  account = Fabricate(:active_account)
      #  get :index
      #  assigns(:accounts).should include(account)
      #end
      #
      ## ToDo We should show here all accounts where has membership (including owner membership).
      #it "shows only current user accounts" do
      #  account = Fabricate(:active_account, owner: @current_user)
      #  other_account = Fabricate(:active_account)
      #  get :index
      #  assigns(:accounts).should include(account)
      #  assigns(:accounts).should_not include(other_account)
      #end
      #
      #it "shows only active accounts" do
      #  account = Fabricate(:active_account, owner: @current_user)
      #  pending_account = Fabricate(:account, owner: @current_user)
      #  get :index
      #  assigns(:accounts).should include(account)
      #  assigns(:accounts).should_not include(pending_account)
      #end
    end

    describe "GET new" do
      it "assigns a new account as @account" do
        get :new
        assigns(:account).should be_a_new(Account)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Account" do
          expect {
            post :create, :account => valid_attributes
          }.to change(Account, :count).by(1)
        end

        it "assigns a newly created account as @account" do
          post :create, :account => valid_attributes
          assigns(:account).should be_a(Account)
          assigns(:account).should be_persisted
        end

        it "sets current user as account owner" do
          post :create, :account => valid_attributes
          assigns(:account).owner.should eql(@current_user)
        end

        it "sets flash notice message" do
          post :create, :account => valid_attributes
          flash[:notice].should eq("Invitation request was sent successfully.")
        end

        it "redirects to acknowledgement" do
          post :create, :account => valid_attributes
          response.should redirect_to(signup_acknowledgement_url(subdomain: Settings.app_subdomain))
        end
      end

      describe "with invalid params" do
        before(:each) do
          # Trigger the behavior that occurs when invalid params are submitted
          Account.any_instance.stub(:save).and_return(false)
          Account.any_instance.stub_chain(:errors, :empty?).and_return(false)
        end

        it "assigns a newly created but unsaved account as @account" do
          post :create, :account => {}
          assigns(:account).should be_a_new(Account)
        end

        it "re-renders the 'new' template" do
          post :create, :account => {}
          response.should render_template("new")
        end
      end
    end
  end

  context "when unauthenticated user" do
    logout :user

    describe "GET index" do
      before(:each) { get :index }

      it { should redirect_to(new_user_session_url(subdomain: Settings.app_subdomain)) }
    end

    describe "GET new" do
      before(:each) { get :new }

      it { should redirect_to(new_user_session_url(subdomain: Settings.app_subdomain)) }
    end

    describe "POST create" do
      before(:each) { post :create, :account => valid_attributes }

      it { should redirect_to(new_user_session_url(subdomain: Settings.app_subdomain)) }
    end
  end
end
