set :rvm_ruby_string, '1.9.3-p0@gm'

ssh_options[:port] = 22 # must be set to open ssh port

set :deploy_to, "/var/www/projects/#{application}/qa"
# Deploy to test site from develop branch
set :branch, "develop"
set :rails_env, "qa"
set :user, "demo"
set :rvm_type, :user

set :appserver, "dev.getmasterdata.com"

role :app, appserver
role :web, appserver
role :db,  appserver, :primary => true

after "deploy", "demo:symlink"