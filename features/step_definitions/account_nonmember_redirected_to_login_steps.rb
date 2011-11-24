Given /^another active account$/ do
  @another_account = Fabricate(:active_account, subdomain: "another")
end

Then /^he should be prompted to login to another account$/ do
  current_url.should == new_user_session_url(subdomain: @another_account.subdomain)
end

When /^user navigates to another account home page$/ do
  visit(root_url(subdomain: @another_account.subdomain))
end

When /^he logs in as another account user$/ do
  @another_user = @another_account.owner
  steps %Q{
    Then he signs in with "#{@another_user.email}" email and "111111" password
  }
end

When /^he navigates to account home page$/ do
  visit(root_url(subdomain: @account.subdomain))
end

Then /^he should be prompted to login to account$/ do
  current_url.should == new_user_session_url(subdomain: @account.subdomain)
end
