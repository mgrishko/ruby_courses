require 'spec_helper'

describe EventDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @product = Fabricate(:product)
    @user = Fabricate(:user)
  end
  
  describe "decorates" do
    it "#account_subdomain" do
      event = Fabricate(:event, action_name: "create", trackable: @product, eventable: @product)
      decorator = EventDecorator.decorate(event)
      decorator.account_subdomain.should == event.account.subdomain
    end
    
    it "trackable_name" do
      product_decorator = ProductDecorator.decorate(@product)
      ProductDecorator.stub(:decorate).and_return(product_decorator)
      product_decorator.h.stub(:can?).and_return(true)
      
      event = Fabricate(:event, action_name: "create", trackable: @product, eventable: @product)
      decorator = EventDecorator.decorate(event)
      decorator.trackable_name.should == event.name
    end
  end
  
  describe "#action_label" do
    context "when product" do
      specify "added" do
        event = Fabricate(:event, action_name: "create", trackable: @product, eventable: @product)
        decorator = EventDecorator.decorate(event)
        decorator.action_label.should == "<span class=\"label success\">New</span>"
      end

      specify "updated" do
        event = Fabricate(:event, action_name: "update", trackable: @product, eventable: @product)
        decorator = EventDecorator.decorate(event)
        decorator.action_label.should == "<span class=\"label warning\">Update</span>"
      end

      specify "deleted" do
        event = Fabricate(:event, action_name: "destroy", trackable: @product, eventable: @product)
        @product.destroy
        event.reload
        decorator = EventDecorator.decorate(event)
        decorator.action_label.should == "<span class=\"label important\">Deleted</span>"
      end
    end

    context "when comment" do
      before(:each) do
        @comment = Fabricate(:comment)
      end

      specify "added" do
        event = Fabricate(:event, action_name: "create", trackable: @product, eventable: @comment)
        decorator = EventDecorator.decorate(event)
        decorator.action_label.should == "<span class=\"label\">Comment</span>"
      end

      specify "deleted" do
        event = Fabricate(:event, action_name: "destroy", trackable: @product, eventable: @comment)
        @comment.destroy
        event.reload
        decorator = EventDecorator.decorate(event)
        decorator.action_label.should == "<span class=\"label\">Comment</span>"
      end
    end

    context "when product photo" do
      before(:each) do
        @photo = Fabricate(:photo)
      end

      specify "added" do
        event = Fabricate(:event, action_name: "create", trackable: @product, eventable: @photo)
        decorator = EventDecorator.decorate(event)
        decorator.action_label.should == "<span class=\"label notice\">Image</span>"
      end

      specify "deleted" do
        event = Fabricate(:event, action_name: "destroy", trackable: @product, eventable: @photo)
        @photo.destroy
        event.reload
        decorator = EventDecorator.decorate(event)
        decorator.action_label.should == "<span class=\"label notice\">Image</span>"
      end
    end
  end

  describe "#trackable_link" do
    before(:each) do
      product_decorator = ProductDecorator.decorate(@product)
      ProductDecorator.stub(:decorate).and_return(product_decorator)
      product_decorator.h.stub(:can?).and_return(true)
    end

    context "when product" do
      specify "added" do
        event = Fabricate(:event, action_name: "create", trackable: @product, eventable: @product)
        decorator = EventDecorator.decorate(event)
        decorator.trackable_link.should == "<a href=\"/products/#{@product.id}\">#{event.name}</a>"
      end

      specify "updated" do
        event = Fabricate(:event, action_name: "update", trackable: @product, eventable: @product)
        decorator = EventDecorator.decorate(event)
        decorator.trackable_link.should == "<a href=\"/products/#{@product.id}\">#{event.name}</a>"
      end

      specify "deleted" do
        event = Fabricate(:event, action_name: "destroy", trackable: @product, eventable: @product)
        @product.destroy
        event.reload
        decorator = EventDecorator.decorate(event)
        decorator.trackable_link.should == "<span class=\"deleted\">#{event.name}</span>"
      end

      specify "added for lately deleted" do
        event = Fabricate(:event, action_name: "create", trackable: @product, eventable: @product)
        @product.destroy
        event.reload
        decorator = EventDecorator.decorate(event)
        decorator.trackable_link.should == "#{event.name}"
      end
    end

    context "when comment" do
      before(:each) do
        @comment = Fabricate(:comment)
      end

      specify "added" do
        event = Fabricate(:event, action_name: "create", trackable: @product, eventable: @comment)
        decorator = EventDecorator.decorate(event)
        decorator.trackable_link.should == "<a href=\"/products/#{@product.id}##{@comment.id}\">#{event.name}</a>"
      end

      specify "deleted" do
        event = Fabricate(:event, action_name: "destroy", trackable: @product, eventable: @comment)
        @comment.destroy
        event.reload
        decorator = EventDecorator.decorate(event)
        decorator.trackable_link.should ==
            "<a href=\"/products/#{@product.id}\"><span class=\"deleted\">#{event.name}</span></a>"
      end
    end

    context "when product photo" do
      before(:each) do
        @photo = Fabricate(:photo)
      end

      specify "added" do
        event = Fabricate(:event, action_name: "create", trackable: @product, eventable: @photo)
        decorator = EventDecorator.decorate(event)
        decorator.trackable_link.should == "<a href=\"/products/#{@product.id}##{@photo.id}\">#{event.name}</a>"
      end

      specify "deleted" do
        event = Fabricate(:event, action_name: "destroy", trackable: @product, eventable: @photo)
        @photo.destroy
        event.reload
        decorator = EventDecorator.decorate(event)
        decorator.trackable_link.should ==
            "<a href=\"/products/#{@product.id}\"><span class=\"deleted\">#{event.name}</span></a>"
      end
    end
  end


  describe "#description" do
    before(:each) do
      Timecop.freeze(2011, 12, 26, 5, 7, 37)
      product = Fabricate(:product)
      user = Fabricate(:user, first_name: "John", last_name: "Cash")
      event = Fabricate(:event, action_name: "destroy", trackable: product, eventable: product, user: user)
      @decorator = EventDecorator.decorate(event)
    end

    after(:each) do
      Timecop.return
    end

    context "when event was less then 1 day ago" do
      it "should include time to event" do
        Timecop.freeze(2011, 12, 26, 5, 12, 44)
        @decorator.description.should == "<span>5 minutes ago,</span> John C."
      end
    end

    context "when event was more then 1 day ago and less then a year ago" do
      it "should include event day and month" do
        Timecop.freeze(2011, 12, 28, 5, 12, 44)
        @decorator.description.should == "<span>2 days ago, Dec 26,</span> John C."
      end
    end

    context "when event was more then 1 year ago" do
      it "should include event month and year" do
        Timecop.freeze(2012, 12, 28, 5, 12, 44)
        @decorator.description.should == "<span>about 1 year ago, Dec, 2011,</span> John C."
      end
    end
  end
end