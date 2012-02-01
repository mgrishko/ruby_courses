require 'spec_helper'

describe "accounts/edit" do

  before(:each) do
    @account = assign(:account, stub_model(Account, subdomain: "",
                                          company_name: "", country: "",
                                          time_zone: "")
                     )
  end

  describe "content" do
    it "renders the edit account form" do
      render
      rendered.should have_selector("form", action: account_path, method: "put")
    end

    it "render subdomain field" do
      render
      rendered.should have_field("account_subdomain", name: "account[subdomain]")
    end

    it "render company_name field" do
      render
      rendered.should have_field("account_company_name", name: "account[company_name]")
    end

    it "render country field" do
      render
      rendered.should have_field("account_country", name: "account[country]")
    end

    it "render time_zone field" do
      render
      rendered.should have_field("account_time_zone", name: "account[time_zone]")
    end
  end

  describe "sidebar" do
    #it "renders a back link" do
    #  render
    #  view.content_for(:sidebar).should have_selector("a", text: "Back")
    #end
  end
end

