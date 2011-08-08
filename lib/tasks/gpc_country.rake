namespace :db do
  desc "Fill the database with the necessary date"
  task :gpc_country => :environment do
    data = GpcCountryData.new
    data.run
  end
end

