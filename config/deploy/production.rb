set :deploy_to, "/var/www/#{application}/production"
# Deploy to production site only from master branch
set :branch, "master"
set :rails_env, "production"