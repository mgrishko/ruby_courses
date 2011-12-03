require 'spec_helper'

describe CommentDecorator do
  before { ApplicationController.new.set_current_view_context }
  
  before(:each) do
    @comment = Fabricate(:comment, body: "111111111122222222223333333333444444444455555555556666666666")
    @decorator = CommentDecorator.decorate(@comment)
  end

  describe "decorates" do
    it "#display_name" do
      @decorator.display_name.should == "11111111112222222222333333333344444444445555555..."
    end
  end
  
  describe "#show_link" do
    context "when user can view comment" do
      it "#show_link" do
        @decorator.h.stub(:can?).and_return(true)
        @decorator.show_link.should == "<a href=\"/products/#{@comment.commentable.id}\">11111111112222222222333333333344444444445555555...</a>"
      end
    end
    
    context "when user can view destroyed comment" do
      it "#show_link" do
        @comment.destroy
        @decorator.h.stub(:can?).and_return(true)
        @decorator.show_link.should == "11111111112222222222333333333344444444445555555..."
      end
    end
    
    context "when user cannot view comment" do
      it "#show_link" do
        @decorator.h.stub(:can?).and_return(false)
        @decorator.show_link.should == "11111111112222222222333333333344444444445555555..."
      end
    end
  end
end
