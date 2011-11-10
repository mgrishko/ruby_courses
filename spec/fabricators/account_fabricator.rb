Fabricator(:account) do
  owner!           { Fabricate(:user) }
  subdomain       { "subdomain" }
  company_name    { Faker::Company.name }
  country         { "US" }
  locale          { "en" }
  time_zone       { "Moscow" }
end

Fabricator(:account_with_memberships, from: :account) do
  after_build do |account|
    account.memberships.build(Fabricate.attributes_for(:membership, account: account))
  end
end
