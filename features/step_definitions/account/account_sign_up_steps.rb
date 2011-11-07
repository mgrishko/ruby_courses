Given /^company representative is on the new account sign up page$/ do
  visit(new_user_registration_url(subdomain: "app"))
end

When /^(?:[^\s]* )fills? out the sign up form with following (.*) data:$/ do |data_type, table|
  fill_out_signup_form(data_type, table.raw.flatten)
end

When /^(?:[^\s]* )submits the sign up form$/ do
  click_button "Create account"
end

When /^he submits sign up form with taken subdomain$/ do
  Fabricate(:account, subdomain: "taken")
  fill_out_signup_form("personal", ["First name", "Last name", "Email", "Password", "Time zone"])
  fill_out_signup_form("account", ["Company", "Country"])
  fill_in "Subdomain", with: "taken"
  click_button "Create account"
end

Then /^he should be redirected back to the sign up page$/ do
  current_url.should == new_user_registration_url(subdomain: "app")
end

Then /^he should see that subdomain (.*)$/ do |message|
  page.find("form span", :text => message)
end

Then /^(?:[^\s]* )should be redirected to the signup acknowledgement page$/ do
  current_url.should == signup_acknowledgement_url(subdomain: "app")
end

def fill_out_signup_form(data_type, form_fields)
  fabricator = data_type == "personal" ? :user : :account
  attributes = Fabricate.attributes_for(fabricator)

  form_fields.each do |field|
    attr = field.is_a?(Symbol)? field : field.downcase.gsub(/\s/, '_').to_sym

    case attr
      when :time_zone
        select attributes[attr], from: field
      when :country
        select Carmen.country_name(attributes[attr]), from: field
      when :company
        fill_in field, with: attributes[:company_name]
      else
        fill_in field, with: attributes[attr]
    end
  end
end

