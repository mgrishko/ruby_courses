require 'spec_helper'

describe ApplicationHelper do
  describe "#title" do
    it "sets content for head title" do
      helper.title "Home"
      helper.content_for(:head_title).should == 'Home'
    end

    it "sets content for body title" do
      helper.title "Home", :body => true
      helper.content_for(:body_title).should == "<h1>Home</h1>"
    end
  end
end