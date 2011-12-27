require 'spec_helper'

describe "admin/accounts/show.html.haml" do
  before(:each) do
    decorator = Admin::AccountDecorator.decorate(Fabricate.build(:account))
    decorator.stub(:activation_link)
    decorator.stub(:login_as_owner_link)
    @account = assign(:account, decorator)
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

  it "renders a back link" do
    render
    rendered.should have_selector("a", text: "Back")
  end
  
  it "renders login as owner link" do
    @account.should_receive(:login_as_owner_link)
    render
  end
end
