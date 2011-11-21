require 'spec_helper'

describe AccountsController do
  it { should be_kind_of(MainController) }

  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:account)
  end

  describe "GET edit" do

    describe "success" do
      login_account_as :owner, account: { subdomain: "company" }

      it "assigns the requested account as @account" do
        account = Account.where(subdomain: "company").first
        get :edit, subdomain: "company"
        assigns(:account).should eq(account)
      end
    end
  end

  describe "PUT update" do

    before(:each) do
      @account = Account.create! valid_attributes
    end

    describe "with valid params" do
      login_account_as :owner, account: { subdomain: "company" }
      it "updates the requested account" do
        Account.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :account => {'these' => 'params'}
      end

      it "assigns the requested account as @account" do
        put :update, :account => valid_attributes
        assigns(:account).should eq(@account)
      end

      it "redirects to the account" do
        put :update, :account => valid_attributes
        response.should redirect_to(@account)
      end
    end

    describe "with invalid params" do
      it "assigns the account as @account" do
        # Trigger the behavior that occurs when invalid params are submitted
        Account.any_instance.stub(:save).and_return(false)
        put :update, :account => {}
        assigns(:account).should eq(@account)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Account.any_instance.stub(:save).and_return(false)
        put :update, :account => {}
        response.should render_template("edit")
      end
    end
  end

  #describe "GET index" do
    #it "assigns all accounts as @accounts" do
      #account = Account.create! valid_attributes
      #get :index
      #assigns(:accounts).should eq([account])
    #end
  #end

  #describe "GET show" do
    #it "assigns the requested account as @account" do
      #account = Account.create! valid_attributes
      #get :show, :id => account.id
      #assigns(:account).should eq(account)
    #end
  #end

  #describe "GET new" do
    #it "assigns a new account as @account" do
      #get :new
      #assigns(:account).should be_a_new(Account)
    #end
  #end

  #describe "POST create" do
    #describe "with valid params" do
      #it "creates a new Account" do
        #expect {
          #post :create, :account => valid_attributes
        #}.to change(Account, :count).by(1)
      #end

      #it "assigns a newly created account as @account" do
        #post :create, :account => valid_attributes
        #assigns(:account).should be_a(Account)
        #assigns(:account).should be_persisted
      #end

      #it "redirects to the created account" do
        #post :create, :account => valid_attributes
        #response.should redirect_to(Account.last)
      #end
    #end

    #describe "with invalid params" do
      #it "assigns a newly created but unsaved account as @account" do
        ## Trigger the behavior that occurs when invalid params are submitted
        #Account.any_instance.stub(:save).and_return(false)
        #post :create, :account => {}
        #assigns(:account).should be_a_new(Account)
      #end

      #it "re-renders the 'new' template" do
        ## Trigger the behavior that occurs when invalid params are submitted
        #Account.any_instance.stub(:save).and_return(false)
        #post :create, :account => {}
        #response.should render_template("new")
      #end
    #end
  #end

  #describe "DELETE destroy" do
    #it "destroys the requested account" do
      #account = Account.create! valid_attributes
      #expect {
        #delete :destroy, :id => account.id
      #}.to change(Account, :count).by(-1)
    #end

    #it "redirects to the accounts list" do
      #account = Account.create! valid_attributes
      #delete :destroy, :id => account.id
      #response.should redirect_to(accounts_url)
    #end
  #end

end
