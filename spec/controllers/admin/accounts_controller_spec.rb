require 'spec_helper'

describe Admin::AccountsController do
  login :admin

  before(:each) do
    @account = Fabricate(:account)
    @account_decorator = Admin::AccountDecorator.decorate(@account)
  end

  describe "GET index" do
    it "assigns all accounts as @account_decorators" do
      get :index, subdomain: Settings.app_subdomain
      assigns(:accounts).first.should eq(@account_decorator)
    end
  end

  describe "GET show" do
    it "assigns the requested account as @account_decorator" do
      get :show, id: @account.id, subdomain: Settings.app_subdomain
      assigns(:account).should eq(@account_decorator)
    end
  end

  describe "GET activate" do
    it "assigns the activating account as @account_decorator" do
      get :activate, id: @account.id, subdomain: Settings.app_subdomain
      assigns(:account).should eq(@account_decorator)
    end

    it "activates the @account_decorator" do
      get :activate, id: @account.id, subdomain: Settings.app_subdomain
      @account.reload
      @account.should be_active
    end

    it "sends account activation email" do
      AccountMailer.stub_chain(:activation_email, :deliver)
      message = mock(Mail::Message)
      AccountMailer.should_receive(:activation_email).and_return(message)
      message.should_receive(:deliver)
      get :activate, id: @account.id, subdomain: Settings.app_subdomain
    end

    it "renders show template" do
      get :activate, id: @account.id, subdomain: Settings.app_subdomain
      response.should render_template(:show)
    end
  end

  #describe "GET new" do
  #  it "assigns a new account as @account_decorator" do
  #    get :new
  #    assigns(:account).should be_a_new(Admin::Account)
  #  end
  #end
  #
  #describe "GET edit" do
  #  it "assigns the requested account as @account_decorator" do
  #    account = Admin::Account.create! valid_attributes
  #    get :edit, :id => account.id
  #    assigns(:account).should eq(account)
  #  end
  #end
  #
  #describe "POST create" do
  #  describe "with valid params" do
  #    it "creates a new Admin::Account" do
  #      expect {
  #        post :create, :account => valid_attributes
  #      }.to change(Admin::Account, :count).by(1)
  #    end
  #
  #    it "assigns a newly created account as @account_decorator" do
  #      post :create, :account => valid_attributes
  #      assigns(:account).should be_a(Admin::Account)
  #      assigns(:account).should be_persisted
  #    end
  #
  #    it "redirects to the created account" do
  #      post :create, :account => valid_attributes
  #      response.should redirect_to(Admin::Account.last)
  #    end
  #  end
  #
  #  describe "with invalid params" do
  #    it "assigns a newly created but unsaved account as @account_decorator" do
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      Admin::Account.any_instance.stub(:save).and_return(false)
  #      post :create, :account => {}
  #      assigns(:account).should be_a_new(Admin::Account)
  #    end
  #
  #    it "re-renders the 'new' template" do
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      Admin::Account.any_instance.stub(:save).and_return(false)
  #      post :create, :account => {}
  #      response.should render_template("new")
  #    end
  #  end
  #end
  #
  #describe "PUT update" do
  #  describe "with valid params" do
  #    it "updates the requested account" do
  #      account = Admin::Account.create! valid_attributes
  #      # Assuming there are no other admin_accounts in the database, this
  #      # specifies that the Admin::Account created on the previous line
  #      # receives the :update_attributes message with whatever params are
  #      # submitted in the request.
  #      Admin::Account.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
  #      put :update, :id => account.id, :account => {'these' => 'params'}
  #    end
  #
  #    it "assigns the requested account as @account_decorator" do
  #      account = Admin::Account.create! valid_attributes
  #      put :update, :id => account.id, :account => valid_attributes
  #      assigns(:account).should eq(account)
  #    end
  #
  #    it "redirects to the account" do
  #      account = Admin::Account.create! valid_attributes
  #      put :update, :id => account.id, :account => valid_attributes
  #      response.should redirect_to(account)
  #    end
  #  end
  #
  #  describe "with invalid params" do
  #    it "assigns the account as @account_decorator" do
  #      account = Admin::Account.create! valid_attributes
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      Admin::Account.any_instance.stub(:save).and_return(false)
  #      put :update, :id => account.id, :account => {}
  #      assigns(:account).should eq(account)
  #    end
  #
  #    it "re-renders the 'edit' template" do
  #      account = Admin::Account.create! valid_attributes
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      Admin::Account.any_instance.stub(:save).and_return(false)
  #      put :update, :id => account.id, :account => {}
  #      response.should render_template("edit")
  #    end
  #  end
  #end
  #
  #describe "DELETE destroy" do
  #  it "destroys the requested account" do
  #    account = Admin::Account.create! valid_attributes
  #    expect {
  #      delete :destroy, :id => account.id
  #    }.to change(Admin::Account, :count).by(-1)
  #  end
  #
  #  it "redirects to the admin_accounts list" do
  #    account = Admin::Account.create! valid_attributes
  #    delete :destroy, :id => account.id
  #    response.should redirect_to(admin_accounts_url)
  #  end
  #end

end
