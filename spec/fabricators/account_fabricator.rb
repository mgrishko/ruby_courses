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
    Fabricate.build(:editor_membership, account: account)
    Fabricate.build(:contributor_membership, account: account)
    Fabricate.build(:viewer_membership, account: account)
    Fabricate.build(:admin_membership, account: account)
  end
end

Fabricator(:account_with_another_admin, from: :account) do
  after_build do |account|
    Fabricate.build(:admin_membership, account: account)
  end
end
