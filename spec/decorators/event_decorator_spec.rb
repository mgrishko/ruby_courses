require 'spec_helper'

describe EventDecorator do
  before { ApplicationController.new.set_current_view_context }

  context "for product added" do
    before(:each) do    
      @product = Fabricate(:product)
      @user = Fabricate(:user)
    
      @event = stub_model(Event, 
        created_at: DateTime.parse("2011-01-01"),
        action_name: "create",
        name: "A product",
        trackable: @product,
        eventable: @product,
        user: @user
      )
      @decorator = EventDecorator.decorate(@event)
    end

    describe "decorates" do
      it "#trackable_name" do
        @decorator.trackable_name.should == "Product"
      end
      
      it "#trackable_link" do
        product_decorator = ProductDecorator.decorate(@product)
        product_decorator.h.stub(:can?).and_return(true)
        @decorator.trackable_link.should == "<a href=\"/products/#{@product.id}\">#{@event.name}</a>"
      end
      
      it "#description" do
        @decorator.description.should == "Created by #{@user.full_name}"
      end
      
      it "#date" do
        @decorator.date.should == "Jan 01, 2011"
      end
    end
  end
  
  context "for product updated" do
    before(:each) do    
      @product = Fabricate(:product)
      @user = Fabricate(:user)
    
      @event = stub_model(Event, 
        created_at: DateTime.parse("2011-01-01"),
        action_name: "update",
        name: "A product",
        eventable: @product,
        trackable: @product,
        user: @user
      )
      @decorator = EventDecorator.decorate(@event)
    end

    describe "decorates" do
      it "#trackable_name" do
        @decorator.trackable_name.should == "Product"
      end
      
      it "#trackable_link" do
        product_decorator = ProductDecorator.decorate(@product)
        product_decorator.h.stub(:can?).and_return(true)
        @decorator.trackable_link.should == "<a href=\"/products/#{@product.id}\">#{@event.name}</a>"
      end
      
      it "#description" do
        @decorator.description.should == "Updated by #{@user.full_name}"
      end
      
      it "#date" do
        @decorator.date.should == "Jan 01, 2011"
      end
    end
  end
  
  context "for product destroyed" do
    before(:each) do    
      @product = Fabricate(:product)
      @product.destroy
      @user = Fabricate(:user)
    
      @event = stub_model(Event,
        created_at: DateTime.parse("2011-01-01"),
        action_name: "destroy",
        name: "A product",
        eventable: @product,
        trackable: @product,
        user: @user
      )
      @decorator = EventDecorator.decorate(@event)
    end

    describe "decorates" do
      it "#trackable_name" do
        @decorator.trackable_name.should == "Product"
      end
      
      it "#trackable_link" do
        @decorator.h.stub(:can?).and_return(false)
        @decorator.trackable_link.should == @event.name
      end
      
      it "#description" do
        @decorator.description.should == "Deleted by #{@user.full_name}"
      end
      
      it "#date" do
        @decorator.date.should == "Jan 01, 2011"
      end
    end
  end
  
  context "for comment added" do
    before(:each) do    
      @product = Fabricate(:product)
      @user = Fabricate(:user)
      @comment = @product.comments.create body: "Some content"
      
      @event = stub_model(Event, 
        created_at: DateTime.parse("2011-01-01"),
        action_name: "create",
        name: "A product",
        trackable: @product,
        eventable: @comment,
        user: @user
      )
      @decorator = EventDecorator.decorate(@event)
    end

    describe "decorates" do
      it "#trackable_name" do
        @decorator.trackable_name.should == "Product"
      end
      
      it "#trackable_link" do
        @decorator.h.stub(:can?).and_return(false)
        @decorator.trackable_link.should == @event.name
      end
      
      it "#description" do
        @decorator.description.should == "Commented by #{@user.full_name}"
      end
      
      it "#date" do
        @decorator.date.should == "Jan 01, 2011"
      end
    end
  end
end