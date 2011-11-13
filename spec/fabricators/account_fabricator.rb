Fabricator(:account) do
  owner!          { Fabricate(:user) }
  subdomain       { "subdomain" }
  company_name    { Faker::Company.name }
  country         { "US" }
  locale          { "en" }
  time_zone       { "Moscow" }
end

Fabricator(:account_with_memberships, from: :account) do
  after_build do |account|
    account.memberships.build(role: "editor", user: Fabricate(:user))
  end
end

Fabricator(:active_account, from: :account) do
  after_create do |account|
    account.activate!
  end
end
