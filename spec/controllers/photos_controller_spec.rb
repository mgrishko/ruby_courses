require 'spec_helper'

describe PhotosController do

  it { should be_kind_of(MainController) }

  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:photo, image: nil, product: nil)
  end

  describe "POST create" do
    login_account_as :editor, account: { subdomain: "company" }

    before(:each) do
      account = Account.first
      @product = Fabricate(:product, account: account)
    end

    describe "with valid params" do
      it "assigns a newly created photo as @photo" do
        post :create, product_id: @product.id, :photo => valid_attributes, format: :js
        assigns(:photo).should be_a(PhotoDecorator)
      end

      it "redirects to the product page" do
        post :create, product_id: @product.id, :photo => valid_attributes, format: :js
        response.should render_template("create")
      end
      
      it "logs create event" do
        Photo.any_instance.stub_chain(:errors, "empty?".to_sym).and_return(true)
        Photo.any_instance.stub(:save).and_return(true)
        
        Product.any_instance.should_receive(:log_event)
        post :create, product_id: @product.id, :photo => valid_attributes, format: :js
      end
    end

    describe "with invalid params" do
      before(:each) do
        # Trigger the behavior that occurs when invalid params are submitted
        Photo.any_instance.stub(:save).and_return(false)
        Photo.any_instance.stub_chain(:errors, :empty?).and_return(false)
      end

      it "assigns a newly created but unsaved photo as @photo" do
        post :create, product_id: @product.id, :photo => {}, format: :js
        assigns(:photo).should be_a_new(PhotoDecorator)
      end

      it "redirects to the product page" do
        post :create, product_id: @product.id, :photo => {}, format: :js
        response.should render_template("create")
      end
      
      it "doesn't create create event" do
        expect {
          post :create, product_id: @product.id, :photo => valid_attributes, format: :js
        }.to change(Event, :count).by(0)
      end
    end
  end

  describe "DELETE destroy" do
    login_account_as :editor, account: { subdomain: "company" }

    before(:each) do
      account = Account.first
      @product = Fabricate(:product, account: account)
      @photo = Fabricate(:photo, product: @product)
    end

    it "destroys the requested photo" do
      @product.photos.count.should == 1
      delete :destroy, product_id: @product.id, :id => @photo.id, format: :js
      @product.reload.photos.count.should == 0
    end

    it "redirects to the product page" do
      delete :destroy, product_id: @product.id, :id => @photo.id, format: :js
      response.should render_template("destroy")
    end
    
    it "creates destroyed event" do
      expect {
        delete :destroy, product_id: @product.id, :id => @photo.id, format: :js
      }.to change(Event, :count).by(1)
      
      event = Event.desc(:created_at).first
      event.action_name.should == "destroy"
      event.trackable eq(@photo)
    end

    it "assigns a new photo as @photo" do
      delete :destroy, product_id: @product.id, :id => @photo.id, format: :js
      assigns(:photo).should be_a_new(Photo)
    end
  end
end
