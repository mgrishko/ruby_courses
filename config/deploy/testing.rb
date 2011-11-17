ssh_options[:port] = 22 # must be set to open ssh port

set :deploy_to, "/var/www/projects/#{application}/testing"
# Deploy to test site from develop branch
set :branch, "develop"
set :rails_env, "testing"
set :user, "demo"

set :appserver, "dev.getmasterdata.com"

role :app, appserver
role :web, appserver
role :db,  appserver, :primary => true

