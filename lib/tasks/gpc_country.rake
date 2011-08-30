namespace :db do
  namespace :seed do
    desc "Fill the database with the necessary date"
    task :country => :environment do
      country_data = CountryData.new
      country_data.run
    end
    task :gpc => :environment do
      gpc_data = GpcData.new
      gpc_data.run
    end
  end
end

