set :deploy_to, "/var/www/#{application}/staging"
# Deploy to staging site from staging branch
set :branch, "staging"
set :rails_env, "staging"