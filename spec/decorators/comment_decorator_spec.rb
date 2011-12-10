require 'spec_helper'

describe CommentDecorator do
  before { ApplicationController.new.set_current_view_context }

  before(:each) do
    @product = Fabricate(:product)
    @comment = Fabricate(:comment, commentable: @product, body: "smth written")
    @decorator = CommentDecorator.decorate(@comment)
  end

  it "#info" do
    @decorator.info.should == "#{@comment.user.full_name}, #{@comment.created_at.strftime('%d %b %Y, %H:%M')}"
  end
  
  it "#show_link" do
    @decorator.show_link(text: "text").should == "<a href=\"/products/#{@product.id}##{@comment.id}\">text</a>"
  end
end
