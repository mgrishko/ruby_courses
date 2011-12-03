require 'spec_helper'

describe CommentDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @product = Fabricate(:product)
    @comment = Fabricate(:comment, commentable: @product, body: "smth written")
    @decorator = CommentDecorator.decorate(@comment)
  end

  describe "decorates" do
    it "#info" do
      @decorator.info.should == "#{@comment.user.full_name}, #{@comment.created_at.strftime('%d %b %Y, %H:%M')}"
    end

    describe "#destroy_link" do
      context "when user can destroy comment" do
        it "renders link" do
          @decorator.h.stub(:can?).and_return(true)
          @decorator.destroy_link.should ==
              "<a href=\"/products/#{@product.id}/comments/#{@comment.id}\" data-method=\"delete\" data-remote=\"true\" rel=\"nofollow\">Delete</a>"
        end
      end

      context "when user cannot destroy comment" do
        it "should return empty string" do
          @decorator.h.stub(:can?).and_return(false)
          @decorator.destroy_link.should be_blank
        end
      end
    end
  end
end
