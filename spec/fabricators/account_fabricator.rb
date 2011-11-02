Fabricator(:account) do
  subdomain       { "subdomain" }
  company_name    { Faker::Company.name }
  country         { "us" }
  locale          { "en" }
  time_zone       { "Moscow" }
end
