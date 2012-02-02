require 'spec_helper'

describe ProductsController do

  it { should be_kind_of(MainController) }

  def valid_attributes
    @attrs ||= Fabricate.attributes_for(:product, account: nil)
  end

  describe "GET index" do
    login_account_as :viewer, account: { subdomain: "company" }

    it "assigns all products as @products" do
      account = Account.where(subdomain: "company").first
      product = account.products.create! valid_attributes
      get :index
      assigns(:products).should eq([product])
    end

    it "does not show other account products" do
      account = Fabricate(:account, subdomain: "other")
      account.products.create! valid_attributes
      get :index
      assigns(:products).should be_empty
    end

    describe "filters" do
      before(:each) do
        @account = Account.where(subdomain: "company").first

        @product1 = Fabricate(:product, account: @account, brand: "Brand 1", manufacturer: "Manufacturer 1")
        @product2 = Fabricate(:product, account: @account, brand: "Brand 2", manufacturer: "Manufacturer 2")
        @product3 = Fabricate(:product, account: @account, brand: "Brand 1", manufacturer: "Manufacturer 3")

        2.times { |i| @product1.tags.create(name: "Tag #{i + 1}") }
        3.times { |i| @product2.tags.create(name: "Tag #{i + 1}") }
        1.times { |i| @product3.tags.create(name: "Tag #{i + 1}") }
      end

      it "should filter products by brand" do
        get :index, by_brand: "brand 2"
        assigns(:products).should eq([@product2])
      end

      it "should filter products by manufacturer" do
        get :index, by_manufacturer: "manufacturer 1"
        assigns(:products).should eq([@product1])
      end

      it "should filter products by tag" do
        get :index, by_tag: "tag 2"
        assigns(:products).should eq([@product1, @product2])
      end

      it "should apply all filters" do
        get :index, by_tag: "tag 1", by_brand: "brand 1"
        assigns(:products).should eq([@product1, @product3])
      end
    end
  end

  describe "GET show" do
    login_account_as :viewer, account: { subdomain: "company" }

    it "assigns the requested product as @product" do
      account = Account.where(subdomain: "company").first
      product = account.products.create! valid_attributes
      get :show, :id => product.id
      assigns(:product).should eq(product)
    end
    
    it "loads the specified version" do
      account = Account.where(subdomain: "company").first
      product = account.products.create! valid_attributes
      (2..3).each { product.update_attributes(valid_attributes.merge(brand: Faker::Product.brand)) }
      
      get :show, id: product.id, version: 1
      assigns(:product_version).version.should == 1
    end

    it "does not show other account product" do
      account = Fabricate(:account, subdomain: "other")
      product = account.products.create! valid_attributes
      lambda { get :show, :id => product.id }.should raise_error(Mongoid::Errors::DocumentNotFound)
    end

    it "assigns a new comment as @comment" do
      account = Account.where(subdomain: "company").first
      product = account.products.create! valid_attributes
      get :show, :id => product.id
      assigns(:comment).should be_a_new(Comment)
    end

    it "assigns a new photo as @photo" do
      account = Account.where(subdomain: "company").first
      product = account.products.create! valid_attributes
      get :show, :id => product.id
      assigns(:photo).should be_a_new(Photo)
    end
  end

  describe "GET new" do
    login_account_as :editor, account: { subdomain: "company" }

    it "assigns a new product as @product" do
      get :new
      assigns(:product).should be_a_new(ProductDecorator)
    end
  end

  describe "GET edit" do
    login_account_as :editor, account: { subdomain: "company" }

    it "assigns the requested product as @product" do
      account = Account.where(subdomain: "company").first
      product = account.products.create! valid_attributes
      get :edit, :id => product.id
      assigns(:product).should eq(product)
    end

    it "does not allow to edit other account product" do
      account = Fabricate(:account, subdomain: "other")
      product = account.products.create! valid_attributes
      lambda { get :edit, :id => product.id }.should raise_error(Mongoid::Errors::DocumentNotFound)
    end

    it "assigns a new photo as @photo" do
      account = Account.where(subdomain: "company").first
      product = account.products.create! valid_attributes
      get :edit, :id => product.id
      assigns(:photo).should be_a_new(Photo)
    end
  end

  describe "POST create" do
    login_account_as :editor, account: { subdomain: "company" }

    describe "with valid params" do
      it "creates a new Product" do
        expect {
          post :create, :product => valid_attributes
        }.to change(Product, :count).by(1)
      end

      it "assigns a newly created product as @product" do
        post :create, :product => valid_attributes
        assigns(:product).should be_a(ProductDecorator)
        assigns(:product).should be_persisted
      end

      it "creates the first version of the product" do
        post :create, :product => valid_attributes
        assigns(:product).version.should == 1
        assigns(:product).should be_persisted
      end
      
      it "redirects to the created product" do
        post :create, :product => valid_attributes
        response.should redirect_to(Product.last)
      end
      
      it "creates system comment" do
        post :create, :product => valid_attributes
        assigns(:product).comments.count.should == 1
        assigns(:product).comments.first.event.should_not be_nil
      end
      
      it "creates created event" do
        expect {
          post :create, :product => valid_attributes
        }.to change(Event, :count).by(1)
        
        event = Event.desc(:created_at).first
        event.action_name.should == "create"
        event.trackable eq(@product)
      end
    end

    describe "with invalid params" do
      before(:each) do
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        Product.any_instance.stub_chain(:errors, :empty?).and_return(false)

        # ToDo We should test situation when product is valid and comment is not valid
      end

      it "assigns a newly created but unsaved product as @product" do
        post :create, :product => {}
        assigns(:product).should be_a_new(ProductDecorator)
      end

      it "re-renders the 'new' template" do
        post :create, :product => {}
        response.should render_template("new")
      end
      
      it "doesn't create added event" do
        expect {
          post :create, :product => {}
        }.to change(Event, :count).by(0)
      end
    end
  end

  describe "PUT update" do
    login_account_as :editor, account: { subdomain: "company" }

    before(:each) do
      account = Account.where(subdomain: "company").first
      @product = account.products.create! valid_attributes
    end

    describe "with valid params" do
      it "updates the requested product" do
        # Assuming there are no other products in the database, this
        # specifies that the Product created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Product.any_instance.should_receive(:attributes=).with({'these' => 'params'})
        Product.any_instance.should_receive(:save)
        put :update, :id => @product.id, :product => {'these' => 'params'}
      end

      it "assigns the requested product as @product" do
        put :update, :id => @product.id, :product => valid_attributes
        assigns(:product).should eq(@product)
      end

      it "increments product version number" do
        Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
          put :update, :id => @product.id, :product => valid_attributes.merge(brand: Faker::Product.brand)
        end
        Timecop.return
        assigns(:product).version.should == 2
      end

      it "redirects to the product" do
        put :update, :id => @product.id, :product => valid_attributes
        response.should redirect_to(@product)
      end

      it "does not allow to update other account product" do
        account = Fabricate(:account, subdomain: "other")
        product = account.products.create! valid_attributes
        lambda { put :update, :id => product.id, :product => valid_attributes }.
            should raise_error(Mongoid::Errors::DocumentNotFound)
      end
      
      it "creates updated event" do
        expect {
          put :update, :id => @product.id, :product => valid_attributes
        }.to change(Event, :count).by(1)
        
        event = Event.desc(:created_at).first
        event.action_name.should == "update"
        event.trackable eq(@product)
      end
      
      it "creates updated comment" do
        Timecop.travel(Time.now + (Settings.events.collapse_timeframe + 1).minutes) do
          expect {
            put :update, :id => @product.id, :product => valid_attributes
          }.to change(@product.comments, :count).by(1)
          @product.comments.first.event.should_not be_nil
        end
        Timecop.return
        comment = @product.comments.desc(:created_at).first
        comment.commentable eq(@product)
      end
    end

    describe "with invalid params" do
      before(:each) do
        # Trigger the behavior that occurs when invalid params are submitted
        Product.any_instance.stub(:save).and_return(false)
        Product.any_instance.stub_chain(:errors, :empty?).and_return(false)

        # ToDo We should test situation when product is valid and comment is not valid
      end

      it "assigns the product as @product" do
        put :update, :id => @product.id, :product => {}
        assigns(:product).should eq(@product)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => @product.id, :product => {}
        response.should render_template("edit")
      end
      
      it "doesn't create updated event" do
        expect {
          put :update, :id => @product.id, :product => {}
        }.to change(Event, :count).by(0)
      end

      it "assigns a new photo as @photo" do
        put :update, :id => @product.id, :product => {}
        assigns(:photo).should be_a_new(Photo)
      end
    end
  end

  describe "DELETE destroy" do
    login_account_as :editor, account: { subdomain: "company" }

    before(:each) do
      account = Account.where(subdomain: "company").first
      @product = account.products.create! valid_attributes
    end

    it "destroys the requested product" do
      expect {
        delete :destroy, :id => @product.id
      }.to change(Product, :count).by(-1)
    end

    it "redirects to the products list" do
      delete :destroy, :id => @product.id
      response.should redirect_to(products_url)
    end
    
    it "creates destroyed event" do
      expect {
        delete :destroy, :id => @product.id
      }.to change(Event, :count).by(1)
      
      event = Event.desc(:created_at).first
      event.action_name.should == "destroy"
      event.trackable eq(@product)
    end

    it "does not allow to destroy other account product" do
      account = Fabricate(:account, subdomain: "other")
      product = account.products.create! valid_attributes
      lambda { delete :destroy, :id => product.id }.should raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end

  describe "GET autocomplete" do
    login_account_as :editor, account: { subdomain: "company" }

    before(:each) do
      account = Account.where(subdomain: "company").first
      account.products.create! valid_attributes.merge(brand: "Pepsi")
    end

    it "returns data for auto complete" do
      get :autocomplete, field: "brand", query: "pep", format: :json
      assigns(:values).should == [{ "id" => "Pepsi", "name" => "Pepsi" }]
    end

    it "does not return data from other account data" do
      account = Fabricate(:account, subdomain: "other")
      account.products.create! valid_attributes.merge(brand: "Coca Cola")
      get :autocomplete, field: "brand", query: "Coca", format: :json
      assigns(:values).should be_empty
    end
  end
end
