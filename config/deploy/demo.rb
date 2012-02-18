set :rvm_ruby_string, '1.9.3-p0@gm'

ssh_options[:port] = 22 # must be set to open ssh port

set :deploy_to, "/var/www/projects/#{application}/demo"
# Deploy to demo site from feature branch.
# It is necessary to change it to corresponding feature branch before executing
#   cap demo deploy
#
# Do not commit this change to git.
set :branch, "develop"
set :rails_env, "demo"
set :user, "demo"
set :rvm_type, :user

set :appserver, "dev.getmasterdata.com"

role :app, appserver
role :web, appserver
role :db,  appserver, :primary => true
