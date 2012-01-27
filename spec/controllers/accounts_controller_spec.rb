require 'spec_helper'

describe AccountsController do
  it { should be_kind_of(MainController) }

  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:account)
  end

  describe "GET edit" do
    login_account_as :owner

    it "assigns the requested account as @account" do
      account = Account.first
      get :edit, subdomain: "company"
      assigns(:account).should eq(account)
    end

    it "doesn't get access to the other account" do
      account = Account.where(subdomain: "other company").first
      get :edit, subdomain: "other company"
      assigns(:account).should_not eq(account)
    end
  end

  describe "PUT update" do
    login_account_as :owner

    before(:each) do
      @account = Account.first
    end

    describe "with valid params" do
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
        response.should redirect_to edit_account_url(subdomain: valid_attributes[:subdomain])
      end
    end

    describe "with invalid params" do
      it "assigns the account as @account" do
        # Trigger the behavior that occurs when invalid params are submitted
        Account.any_instance.stub(:save).and_return(false)
        Account.any_instance.stub_chain(:errors, :empty?).and_return(false)
        put :update, :account => {}
        assigns(:account).should eq(@account)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Account.any_instance.stub(:save).and_return(false)
        Account.any_instance.stub_chain(:errors, :empty?).and_return(false)
        put :update, :account => {}
        response.should render_template("edit")
      end
    end
  end
end
