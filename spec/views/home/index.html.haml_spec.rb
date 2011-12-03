require 'spec_helper'

describe "home/index.html.haml" do
  before(:each) do
    assign(:events, [
      stub_model(Event, 
        formatted_date: "Jan 02, 2011",
        display_name: "Product Added",
        user_name: "User Name",
        show_link: "<a>Product Name</a>".html_safe
      ),
      stub_model(Event, 
        formatted_date: "Jan 01, 2011",
        display_name: "Comment Added",
        user_name: "User Name",
        show_link: "<a>Comment Text</a>".html_safe
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
      rendered.should have_selector("td", text: "Product Added")
      rendered.should have_selector("td", text: "Comment Added")
    end
    
    it "renders event dates" do
      render
      rendered.should have_selector("td", text: "Jan 02, 2011")
      rendered.should have_selector("td", text: "Jan 01, 2011")
    end
    
    it "renders event owners" do
      render
      rendered.should have_selector("td", text: "User Name")
      rendered.should have_selector("td", text: "User Name")
    end
    
    it "renders event object links" do
      render
      rendered.should have_selector("td a", text: "Product Name")
      rendered.should have_selector("td a", text: "Comment Text")
    end
  end
end
