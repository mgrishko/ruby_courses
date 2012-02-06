require 'spec_helper'

describe "home/index" do
  before(:each) do
    assign(:events, EventDecorator.decorate([
      stub_model(Event),
      stub_model(Event)
    ]))

    EventDecorator.any_instance.stub(:action_label).and_return("Action label")
    EventDecorator.any_instance.stub(:trackable_link).and_return("Link to trackable")
    EventDecorator.any_instance.stub(:description).and_return("Event description")
  end

  describe "content" do
    it "renders a list of events" do
      render
      rendered.should have_selector("table tr", count: 2)
    end

    it "renders event action labels" do
      render
      rendered.should have_selector("td.action", text: "Action label")
    end

    it "renders event object links" do
      render
      rendered.should have_selector("td", text: "Link to trackable")
    end

    it "renders event description" do
      render
      rendered.should have_selector("td.desc", text: "Event description")
    end
  end
end
