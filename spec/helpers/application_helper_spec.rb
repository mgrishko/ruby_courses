require 'spec_helper'

describe ApplicationHelper do
  describe "#title" do
    it "sets content for head title" do
      helper.title "Home"
      helper.content_for(:head_title).should == 'Home'
    end

    it "sets content for body title" do
      helper.title "Home", page_title: true
      helper.content_for(:page_title).should == "Home"
    end

    it "sets content for body title by default" do
      helper.title "Home"
      helper.content_for(:page_title).should == "Home"
    end

    it "should not set content for body title" do
      helper.title "Home", page_title: false
      helper.content_for(:page_title).should be_blank
    end
  end
end