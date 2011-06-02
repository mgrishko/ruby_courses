Given /^"([^"]*)" has gln "([^"]*)" and password "([^"]*)" also$/ do |role, gln, password|
  @users = {} unless @users
  @users[role] = Factory(role.to_sym,
  :gln => gln,
  :password => password,
  :password_confirmation => password)
end

When /^(?:|I )go with "(.+)" to (.+)$/ do |url, page_name|
  visit path_to(page_name)+url.to_s
end

