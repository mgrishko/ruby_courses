require 'spec_helper'

describe "admin/accounts/show.html.haml" do
  before(:each) do
    @account = assign(:account, stub_model(Account))
  end

  it "renders a subdomain column" do
    render
    rendered.should have_selector("p>strong", text: "Subdomain")
  end

  it "renders a company column" do
    render
    rendered.should have_selector("p>strong", text: "Company")
  end

  it "renders a country column" do
    render
    rendered.should have_selector("p>strong", text: "Country")
  end

  it "renders a state column" do
    render
    rendered.should have_selector("p>strong", text: "State")
  end

  it "renders an activation link" do
    render
    rendered.should have_selector("a", text: "Activate")
  end

  it "renders a back link" do
    render
    rendered.should have_selector("a", text: "Back")
  end
end
