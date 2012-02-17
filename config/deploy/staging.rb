ssh_options[:port] = 17333 # must be set to open ssh port

set :deploy_to, "/var/www/projects/#{application}/staging"
# Deploy to staging site from latest release branch
set :branch, "release/0.1.1"
set :rails_env, "staging"
set :user, "gmadmin"
set :rvm_type, :user

set :appserver, "beta.goodsmasterhq.com"

role :app, appserver
role :web, appserver
role :db,  appserver, :primary => true

after "deploy", "demodata:symlink"