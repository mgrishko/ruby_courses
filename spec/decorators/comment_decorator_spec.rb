require 'spec_helper'

describe CommentDecorator do
  before { ApplicationController.new.set_current_view_context }
  
  before(:each) do
    @comment = Fabricate(:comment)
    @decorator = CommentDecorator.decorate(@comment)
  end
end
