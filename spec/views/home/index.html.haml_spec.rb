require 'spec_helper'

describe "home/index.html.haml" do
  before(:each) do
    assign(:events, [
      stub_model(Event, 
        trackable_name: "Product",
        trackable_link: "<a>Product Name</a>".html_safe,
        description: "Created by User Name",
        date: "Jan 02, 2011"
      ),
      stub_model(Event, 
        trackable_name: "Product",
        trackable_link: "<a>Product Name</a>".html_safe,
        description: "Commented by User Name",
        date: "Jan 01, 2011"
      )
    ])
  end

  describe "content" do
    it "renders a list of events" do
      render
      rendered.should have_selector("table tr", count: 2)
    end
    
    it "renders event types" do
      render
      rendered.should have_selector("td", text: "Product")
      rendered.should have_selector("td", text: "Product")
    end
    
    it "renders event dates" do
      render
      rendered.should have_selector("td", text: "Jan 02, 2011")
      rendered.should have_selector("td", text: "Jan 01, 2011")
    end
    
    it "renders event owners" do
      render
      rendered.should have_selector("td", text: "Created by User Name")
      rendered.should have_selector("td", text: "Commented by User Name")
    end
    
    it "renders event object links" do
      render
      rendered.should have_selector("td a", text: "Product Name")
      rendered.should have_selector("td a", text: "Product Name")
    end
  end
end
