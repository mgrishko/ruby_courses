# RVM configuration
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.3-p0@gm'             # Or whatever env you want it to run in.

# Bundler
require "bundler/capistrano"

# Airbrake error notifier
require './config/boot'
require 'airbrake/capistrano'

# NewRelic Recording Deployments
require 'new_relic/recipes'

# Bundler options
set :bundle_without, [:development, :test, :cucumber, :console]

# Multistage
set :stages, %w(development staging qa)
set :default_stage, "qa"
require 'capistrano/ext/multistage'

set :application, "goodsmaster"

# Use Git source control
set :scm, :git
set :repository, "git@git.assembla.com:webforms2.2.git"
set :deploy_via, :remote_cache
set :scm_verbose, true
set :use_sudo, false

ssh_options[:forward_agent] = true # use local keys instead of the ones on the server
default_run_options[:pty] = true   # must be set for the password prompt from git to work
#ssh_options[:port] = 37777 # must be set to open ssh port

depend :remote, :gem, "bundler", ">=1.0.21"
depend :remote, :gem, "rake", ">=0.9.2.2"

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  # Avoid keeping the mongoid.yml configuration in git.
  task :copy_database_configuration, :roles => :app do
    db_config = "/var/www/projects/#{application}/config/mongoid.yml"
    run "cp #{db_config} #{release_path}/config/mongoid.yml"
  end

  #Regenerate yard documention and restart yard server
  task :yard_regenerate, :roles => :app do
    run "yard doc"
    run "yard server -d"
  end
end

after "deploy", "deploy:copy_database_configuration"
after "deploy", "newrelic:notice_deployment" # This goes out even if the deploy fails, sadly
after "deploy", "deploy:cleanup" # keeps only last 5 releases
