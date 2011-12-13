require 'spec_helper'

describe Admin::AdminsController do
  login :admin

  def valid_attributes
    @attr ||= Fabricate.attributes_for(:admin)
  end

  describe "GET edit" do
    it "assigns the requested admin as @adimn" do
      admin = Admin.first
      get :edit, id: admin.id, subdomain: Settings.app_subdomain
      assigns(:admin).should eq(admin)
    end
  end

  describe "PUT update" do

    before(:each) do
      @admin = Admin.first
    end

    describe "with valid params" do
      it "updates the requested admin" do
        Admin.any_instance.should_receive(:update_with_password).with({'these' => 'params'})
        put :update, id: @admin.id, subdomain: Settings.app_subdomain, :admin => {'these' => 'params'}
      end

      it "assigns the requested admin as @admin" do
        put :update, id: @admin, subdomain: Settings.app_subdomain, :admin => valid_attributes
        assigns(:admin).should eq(@admin)
      end

      #it "redirects to the admin" do
        #put :update, id: @admin.id, subdomain: Settings.app_subdomain, :admin => valid_attributes
        #response.should redirect_to(edit_admin_profile_url(@admin, subdomain: Settings.app_subdomain))
      #end
    end

    #describe "with invalid params" do
      #it "assigns the admin as @admin" do
        #Admin.any_instance.stub(:save).and_return(false)
        #Admin.any_instance.stub_chain(:errors, :empty?).and_return(false)
        #put :update, id: @admin.id, subdomain: Settings.app_subdomain, :admin => {}
        #assigns(:admin).should eq(@admin)
      #end

      #it "re-renders the 'edit' template" do
        #Admin.any_instance.stub(:save).and_return(false)
        #Admin.any_instance.stub_chain(:errors, :empty?).and_return(false)
        #put :update, id: @admin.id, subdomain: Settings.app_subdomain, :admin => {}
        #response.should render_template("edit")
      #end
    #end
  end

  #describe "GET index" do
    #it "assigns all admins as @admins" do
      #admin = Profile.create! valid_attributes
      #get :index
      #assigns(:admins).should eq([admin])
    #end
  #end

  #describe "GET show" do
    #it "assigns the requested admin as @admin" do
      #admin = Profile.create! valid_attributes
      #get :show, :id => admin.id
      #assigns(:admin).should eq(admin)
    #end
  #end

  #describe "GET new" do
    #it "assigns a new admin as @admin" do
      #get :new
      #assigns(:admin).should be_a_new(Profile)
    #end
  #end

  #describe "POST create" do
    #describe "with valid params" do
      #it "creates a new Profile" do
        #expect {
          #post :create, :admin => valid_attributes
        #}.to change(Profile, :count).by(1)
      #end

      #it "assigns a newly created admin as @admin" do
        #post :create, :admin => valid_attributes
        #assigns(:admin).should be_a(Profile)
        #assigns(:admin).should be_persisted
      #end

      #it "redirects to the created admin" do
        #post :create, :admin => valid_attributes
        #response.should redirect_to(Profile.last)
      #end
    #end

    #describe "with invalid params" do
      #it "assigns a newly created but unsaved admin as @admin" do
        ## Trigger the behavior that occurs when invalid params are submitted
        #Profile.any_instance.stub(:save).and_return(false)
        #post :create, :admin => {}
        #assigns(:admin).should be_a_new(Profile)
      #end

      #it "re-renders the 'new' template" do
        ## Trigger the behavior that occurs when invalid params are submitted
        #Profile.any_instance.stub(:save).and_return(false)
        #post :create, :admin => {}
        #response.should render_template("new")
      #end
    #end
  #end

  #describe "DELETE destroy" do
    #it "destroys the requested admin" do
      #admin = Profile.create! valid_attributes
      #expect {
        #delete :destroy, :id => admin.id
      #}.to change(Profile, :count).by(-1)
    #end

    #it "redirects to the admins list" do
      #admin = Profile.create! valid_attributes
      #delete :destroy, :id => admin.id
      #response.should redirect_to(admins_url)
    #end
  #end

end
