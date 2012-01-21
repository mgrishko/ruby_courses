require 'spec_helper'

describe "admin/accounts/show.haml" do
  before(:each) do
    decorator = AccountDecorator.decorate(Fabricate.build(:account))
    decorator.stub(:activation_link)
    decorator.stub(:login_as_owner_link)
    @account = assign(:account, decorator)
  end

  it "renders an owner field" do
    render
    rendered.should have_selector("p>strong", text: "Owner")
  end

  it "renders an sign in ip-address field" do
    render
    rendered.should have_selector("p>strong", text: "Sign in IP-address")
  end

  it "renders a subdomain field" do
    render
    rendered.should have_selector("p>strong", text: "Subdomain")
  end

  it "renders a company field" do
    render
    rendered.should have_selector("p>strong", text: "Company")
  end

  it "renders a country field" do
    render
    rendered.should have_selector("p>strong", text: "Country")
  end

  it "renders time zone field" do
    render
    rendered.should have_selector("p>strong", text: "Time zone")
  end

  it "renders a website field" do
    render
    rendered.should have_selector("p>strong", text: "Website")
  end

  it "renders about company field" do
    render
    rendered.should have_selector("p>strong", text: "About company")
  end

  it "renders a created at field" do
    render
    rendered.should have_selector("p>strong", text: "Created at")
  end

  it "renders a state field" do
    render
    rendered.should have_selector("p>strong", text: "State")
  end

  it "renders a back link" do
    render
    rendered.should have_selector("a", text: "Back")
  end
  
  it "renders login as owner link" do
    @account.should_receive(:login_as_owner_link)
    render
  end
end
