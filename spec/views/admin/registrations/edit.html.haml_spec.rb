require 'spec_helper'

describe "admin/registrations/edit.html.haml" do

  before(:each) do
    @admin = assign(:admin, stub_model(Admin, email: "", password: ""))
  end

  describe "content" do
    it "renders the edit admin form" do
      render
      rendered.should have_selector("form", action: edit_admin_path, method: "put")
    end

    it "render email field" do
      render
      rendered.should have_field("admin_email", name: "admin[email]")
    end

    it "render password field" do
      render
      rendered.should have_field("admin_password", name: "admin[password]")
    end
  end

  describe "sidebar" do
    it "renders a back link" do
      render
      view.content_for(:sidebar).should have_selector("a", text: "Back")
    end
  end
end

