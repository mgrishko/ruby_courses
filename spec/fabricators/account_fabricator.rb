Fabricator(:account) do
  owner!          { Fabricate(:user) }
  subdomain       { Faker::Internet.domain_word[0..20] }
  company_name    { Faker::Company.name }
  country         { "US" }
  locale        "en"
  time_zone     "Moscow"
end

Fabricator(:active_account, from: :account) do
  after_create do |account|
    account.activate!
  end
end

Fabricator(:account_with_memberships, from: :active_account) do
  after_build do |account|
    Fabricate.build(:editor_membership, account: account)
    Fabricate.build(:contributor_membership, account: account)
    Fabricate.build(:viewer_membership, account: account)
    Fabricate.build(:admin_membership, account: account)
  end
end

Fabricator(:account_with_another_admin, from: :active_account) do
  after_build do |account|
    Fabricate.build(:admin_membership, account: account)
    account.memberships.build(role: "editor", user: Fabricate(:user))
  end
end
