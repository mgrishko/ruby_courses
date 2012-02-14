Given /^company representative has a new account$/ do
  @owner = Fabricate(:user, email: "user@example.com", password: "password")
  @account = Fabricate(:account, owner: @owner)
  
  visit new_user_session_url(subdomain: @account.subdomain)
  fill_in "Email", with: @owner.email
  fill_in "Password", with: @owner.password
  click_button "Sign in"
end

Given /^company representative signs up for a new account with "([^"]*)" subdomain$/ do |subdomain|
  steps "Given company representative is on the sign up page"
  
  user_fields = ["First name", "Last name", "Email", "Password"]
  fill_out_signup_user_fields(user_fields)
  
  account_fields = ["Time zone", "Company", "Country"]
  fill_out_signup_account_fields(account_fields)
  
  fill_in "Subdomain", with: subdomain
  
  click_button "Request account"
end

def fill_out_signup_user_fields(fields)
  attrs = Fabricate.attributes_for(:user)

  fields.each do |field|
    attr = field.downcase.gsub(/\s/, '_').to_sym
    fill_in field, with: attrs[attr]
  end
end

def fill_out_signup_account_fields(fields)
  attrs = Fabricate.attributes_for(:account)

  fields.each do |field|
    attr = field.downcase.gsub(/\s/, '_').to_sym

    case attr
      when :time_zone
        select attrs[attr], from: field
      when :country
        select Carmen.country_name(attrs[attr]), from: field
      when :company
        fill_in field, with: attrs[:company_name]
      else
        fill_in field, with: attrs[attr]
    end
  end
end

When /^admin goes to the accounts page$/ do
  visit(admin_accounts_url)
end

When /^(?:[^\s]* )activates the account$/ do
  click_link("Show")
  click_link("Activate")
end

When /^he follows company account link$/ do
  visit_in_email(home_url(subdomain: @account.subdomain))
end

Then /^an account owner should receive an activation email$/ do
  email_address = @account.owner.email
  unread_emails_for(email_address).size.should == 1
  open_email(email_address)
end

Then /^he should be on the account list page$/ do
  current_url.should == admin_accounts_url(subdomain: Settings.app_subdomain)
end
