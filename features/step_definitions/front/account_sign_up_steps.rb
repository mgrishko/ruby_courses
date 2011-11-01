Given /^company representative is on the new account sign up page$/ do
  visit(new_user_registration_url)
end

When /^(?:[^\s]* )fills? out the following personal information:$/ do |fields|
  attributes = Fabricate.attributes_for(:user)

  fields.rows.each do |row|
    field = row[0]
    attr = field.downcase.gsub(/\s/, '_').to_sym
    case attr
      when :time_zone
        select attributes[attr], from: field
      else
        fill_in field, with: attributes[attr]
    end
  end
end