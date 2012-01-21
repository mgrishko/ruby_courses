require 'spec_helper'

describe "admin/events/index.html.haml" do
  before(:each) do
    assign(:events, EventDecorator.decorate([
      stub_model(Event),
      stub_model(Event)
    ]))
    
    EventDecorator.any_instance.stub(:account_subdomain).and_return("subdomain")
    EventDecorator.any_instance.stub(:action_label).and_return("Action label")
    EventDecorator.any_instance.stub(:trackable_name).and_return("Trackable name")
    EventDecorator.any_instance.stub(:description).and_return("Event description")
  end

  describe "content" do
    it "renders a list of events" do
      render
      rendered.should have_selector("table tr", count: 2)
    end
    
    it "renders event account subdomains" do
      render
      rendered.should have_selector("td.subdomain", text: "subdomain")
    end
    
    it "renders event action labels" do
      render
      rendered.should have_selector("td.action", text: "Action label")
    end
    
    it "renders event object names" do
      render
      rendered.should have_selector("td", text: "Trackable name")
    end
    
    it "renders event descriptions" do
      render
      rendered.should have_selector("td.desc", text: "Event description")
    end
  end
end
