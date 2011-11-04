Given /^company representative is on the new account sign up page$/ do
  visit(new_user_registration_url(subdomain: "app"))
end

When /^(?:[^\s]* )fills? out the sign up form with following (.*) data:$/ do |data, table|
  fabricator = data == "personal" ? :user : :account
  attributes = Fabricate.attributes_for(fabricator)

  table.raw.flatten.each do |field|
    attr = field.downcase.gsub(/\s/, '_').to_sym

    case attr
      when :time_zone
        select attributes[attr], from: field
      when :country
        select Carmen.country_name(attributes[attr]), from: field
      when :company_name
        fill_in field, with: attributes[:company_name]
      else
        fill_in field, with: attributes[attr]
    end
  end
end

When /^(?:[^\s]* )submits the sign up form$/ do
  click_button "Create account"
end

Then /^(?:[^\s]* )should be redirected to the signup acknowledgement page$/ do
  current_url.should == signup_acknowledgement_url(subdomain: "app")
end