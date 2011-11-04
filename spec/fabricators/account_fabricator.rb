Fabricator(:account) do
  subdomain       { "subdomain" }
  company_name    { Faker::Company.name }
  country         { "US" }
  locale          { "en" }
  time_zone       { "Moscow" }

  after_build do |account|
    account.users.build(Fabricate.attributes_for(:user))
  end
end
