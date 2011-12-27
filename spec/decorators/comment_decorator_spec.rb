require 'spec_helper'

describe CommentDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    Timecop.freeze(2011, 12, 26, 5, 7, 37)
    @product = Fabricate(:product)
    @user = Fabricate(:user, first_name: "John", last_name: "Cash")
  end

  after(:each) do
    Timecop.return
  end

  describe "#details" do
    before(:each) do
      comment = Fabricate(:comment, commentable: @product, user: @user)
      @decorator = CommentDecorator.decorate(comment)
    end

    it "should return commented by info and ago in minutes" do
      Timecop.freeze(2011, 12, 26, 5, 12, 44)
      @decorator.details.should == "<span>5 minutes ago, John Cash</span>"
    end

    it "should return commented by info and ago in days" do
      Timecop.freeze(2011, 12, 28, 5, 12, 44)
      @decorator.details.should == "<span>2 days ago, Dec 26, John Cash</span>"
    end

    it "should return commented by info and ago in years" do
      Timecop.freeze(2012, 12, 28, 5, 12, 44)
      @decorator.details.should == "<span>about 1 year ago, Dec, 2011, John Cash</span>"
    end
  end
end
