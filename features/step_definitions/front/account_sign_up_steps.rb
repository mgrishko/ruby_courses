Given /^company representative is on the new account sign up page$/ do
  visit(new_user_registration_url)
end

When /^(?:[^\s]* )fills? out the following (.*):$/ do |info, fields|
  fabricator = info == "personal information" ? :user : :account
  attributes = Fabricate.attributes_for(fabricator)

  fields.rows.each do |row|
    field = row[0]
    attr = field.downcase.gsub(/\s/, '_').to_sym
    case attr
      when :time_zone, :country
        select attributes[attr], from: field
      else
        fill_in field, with: attributes[attr]
    end
  end
end

When /^(?:[^\s]* )submits the form$/ do
  click_button "Create account"
end