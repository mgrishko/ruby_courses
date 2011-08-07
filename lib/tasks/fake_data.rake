# encoding: utf-8

namespace :db do
  namespace :seed do
    desc "Fill the database with the fake data"
    task :fake_data => :environment do
      fdl = FakeDataLoader.new
      fdl.run
    end
  end
end

