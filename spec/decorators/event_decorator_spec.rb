require 'spec_helper'

describe EventDecorator do
  before { ApplicationController.new.set_current_view_context }

  context "for product added" do
    before(:each) do    
      @product = Fabricate(:product)
      @user = Fabricate(:user)
    
      @event = stub_model(Event, 
        created_at: DateTime.parse("2011-01-01"),
        type: "added",
        trackable: @product,
        user: @user
      )
      @decorator = EventDecorator.decorate(@event)
    end

    describe "decorates" do
      it "#formatted_date" do
        @decorator.formatted_date.should == "Jan 01, 2011"
      end
      
      it "#user_name" do
        @decorator.user_name.should == @user.full_name
      end
      
      it "#display_name" do
        @decorator.display_name.should == "Product Added"
      end

      it "#show_link" do
        product_decorator = ProductDecorator.decorate(@product)
        product_decorator.h.stub(:can?).and_return(true)
        @decorator.show_link.should == product_decorator.show_link
      end
    end
  end
  
  context "for product updated" do
    before(:each) do    
      @product = Fabricate(:product)
      @user = Fabricate(:user)
    
      @event = stub_model(Event, 
        created_at: DateTime.parse("2011-01-01"),
        type: "updated",
        trackable: @product,
        user: @user
      )
      @decorator = EventDecorator.decorate(@event)
    end

    describe "decorates" do
      it "#formatted_date" do
        @decorator.formatted_date.should == "Jan 01, 2011"
      end
      
      it "#user_name" do
        @decorator.user_name.should == @user.full_name
      end
      
      it "#display_name" do
        @decorator.display_name.should == "Product Updated"
      end

      it "#show_link" do
        product_decorator = ProductDecorator.decorate(@product)
        product_decorator.h.stub(:can?).and_return(true)
        @decorator.show_link.should == product_decorator.show_link
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
        type: "destroyed",
        trackable: @product,
        user: @user
      )
      @decorator = EventDecorator.decorate(@event)
    end

    describe "decorates" do
      before(:each) do    
        
      end
      
      it "#formatted_date" do
        @decorator.formatted_date.should == "Jan 01, 2011"
      end
      
      it "#user_name" do
        @decorator.user_name.should == @user.full_name
      end
      
      it "#display_name" do
        @decorator.display_name.should == "Product Deleted"
      end

      it "#show_link" do
        @product.destroy
        @product = Product.deleted.find(@product.id)
        
        @event = stub_model(Event, 
          created_at: DateTime.parse("2011-01-01"),
          type: "destroyed",
          trackable: @product,
          user: @user
        )
        
        @decorator = EventDecorator.decorate(@event)
        @decorator.show_link.should == @product.name
      end
    end
  end
  
  context " for comment added" do
    before(:each) do    
      @comment = Fabricate(:comment)
      @user = Fabricate(:user)
    
      @event = stub_model(Event, 
        created_at: DateTime.parse("2011-01-01"),
        type: "added",
        trackable: @comment,
        user: @user
      )
      @decorator = EventDecorator.decorate(@event)
    end

    describe "decorates" do
      it "#formatted_date" do
        @decorator.formatted_date.should == "Jan 01, 2011"
      end
      
      it "#user_name" do
        @decorator.user_name.should == @user.full_name
      end
      
      it "#display_name" do
        @decorator.display_name.should == "Comment Added"
      end

      it "#show_link" do
        comment_decorator = CommentDecorator.decorate(@comment)
        comment_decorator.h.stub(:can?).and_return(true)
        @decorator.show_link.should == comment_decorator.show_link
        #puts comment_decorator.show_link
      end
    end
  end
  
=begin
  describe "#invitation_link" do
    context "when user can invite a new member" do
      it "renders link" do
        @decorator.h.stub(:can?).and_return(true)
        MembershipDecorator.invitation_link.should_not be_blank
      end
    end

    context "when user cannot invite a new member" do
      it "should return empty string" do
        @decorator.h.stub(:can?).and_return(false)
        MembershipDecorator.invitation_link.should be_blank
      end
    end
  end
=end
end