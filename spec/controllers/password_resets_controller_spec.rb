require 'spec_helper'

describe PasswordResetsController do

  def mock_user(stubs={})
    (@mock_user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET new" do
    it "renders the 'new' template" do
      get :new
      response.should render_template("new")
    end
  end

  describe "GET edit" do
    describe "with valid params" do
      before :each do
        User.should_receive(:find_using_perishable_token).with('37').and_return(mock_user)
      end

      it "assigns the found user as @user" do
        get :edit, :id => "37"
        assigns(:user).should be(mock_user)
      end

      it "renders the 'edit' template" do
        get :edit, :id => "37"
        response.should render_template("edit")
      end
    end

    describe "with invalid params" do
      before :each do
        User.should_receive(:find_using_perishable_token).with('37').and_return(nil)
      end

      it "redirects to the root_path" do
        get :edit, :id => "37"
        response.should redirect_to(root_path)
      end
    end
  end


  describe "POST create" do

    describe "with valid params" do
      before :each do
        User.should_receive(:find_by_email).with('a@b.com').and_return(mock_user)
        mock_user.should_receive(:deliver_password_reset_instructions!)
      end

      it "finds the user by email" do
        post :create, :email => 'a@b.com'
        assigns(:user).should be(mock_user)
      end

      it "redirects to the login_path" do
        post :create, :email => 'a@b.com'
        response.should redirect_to(login_path)
      end
    end

    describe "with invalid params" do
      before :each do
        User.should_receive(:find_by_email).with('a@b.com').and_return(nil)
      end

      it "re-renders the 'new' template" do
        post :create, :email => 'a@b.com'
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      before :each do
        User.should_receive(:find_using_perishable_token).with('37').and_return(mock_user({
          :password= => true,
          :password_confirmation= => true,
          :save => true
        }))
      end

      it "updates the requested password_reset" do
        mock_user.should_receive(:password=).with('pass')
        mock_user.should_receive(:password_confirmation=).with('conf')
        put :update, :id => "37", :password => 'pass', :password_confirmation => 'conf'
      end

      it "assigns the found user as @user" do
        put :update, :id => "37"
        assigns(:user).should be(mock_user)
      end

      it "redirects to the user" do
        put :update, :id => "37"
        response.should redirect_to(user_url(mock_user))
      end
    end

    describe "with wrong :id" do
      before :each do
        User.should_receive(:find_using_perishable_token).with('37').and_return(nil)
      end

      it "redirects to the root_path" do
        put :update, :id => "37"
        response.should redirect_to(root_path)
      end
    end

    describe "with invalid params" do
      before :each do
        User.should_receive(:find_using_perishable_token).with('37').and_return(mock_user({
          :password= => true,
          :password_confirmation= => true,
          :save => false
        }))
      end

      it "assigns the found user as @user" do
        put :update, :id => "37"
        assigns(:user).should be(mock_user)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => "37"
        response.should render_template("edit")
      end
    end

  end

end
