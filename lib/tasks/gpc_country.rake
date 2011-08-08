namespace :db do
  namespace :seed do
    desc "Fill the database with the fake data"
    task :gpc_country => :environment do
      GpcCountryData.new
    end
  end
end

