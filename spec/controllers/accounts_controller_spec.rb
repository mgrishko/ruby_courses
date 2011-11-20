require 'spec_helper'

describe AccountsController do

  it { should be_kind_of(MainController) }

  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:account, owner: nil)
  end

  describe "GET edit" do

    describe "success" do
      login_account_as :owner, account: { subdomain: "company" }

      it "assigns the requested account as @account" do
        get :edit, subdomain: "company"
        assigns(:account).should eq(@current_account)
      end
    end
  end

  #describe "PUT update" do
    #describe "with valid params" do
      #it "updates the requested account" do
        #account = Account.create! valid_attributes
        ## Assuming there are no other accounts in the database, this
        ## specifies that the Account created on the previous line
        ## receives the :update_attributes message with whatever params are
        ## submitted in the request.
        #Account.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        #put :update, :id => account.id, :account => {'these' => 'params'}
      #end

      #it "assigns the requested account as @account" do
        #account = Account.create! valid_attributes
        #put :update, :id => account.id, :account => valid_attributes
        #assigns(:account).should eq(account)
      #end

      #it "redirects to the account" do
        #account = Account.create! valid_attributes
        #put :update, :id => account.id, :account => valid_attributes
        #response.should redirect_to(account)
      #end
    #end

    #describe "with invalid params" do
      #it "assigns the account as @account" do
        #account = Account.create! valid_attributes
        ## Trigger the behavior that occurs when invalid params are submitted
        #Account.any_instance.stub(:save).and_return(false)
        #put :update, :id => account.id, :account => {}
        #assigns(:account).should eq(account)
      #end

      #it "re-renders the 'edit' template" do
        #account = Account.create! valid_attributes
        ## Trigger the behavior that occurs when invalid params are submitted
        #Account.any_instance.stub(:save).and_return(false)
        #put :update, :id => account.id, :account => {}
        #response.should render_template("edit")
      #end
    #end
  #end

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
