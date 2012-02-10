# RVM configuration
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.3-p0'             # Or whatever env you want it to run in.

# Bundler
require "bundler/capistrano"

# Airbrake error notifier
require './config/boot'
require 'airbrake/capistrano'

# NewRelic Recording Deployments
require 'new_relic/recipes'

# Delayed Job recipes
require "delayed/recipes"

# Bundler options
set :bundle_without, [:development, :test, :cucumber]

# Multistage
set :stages, %w(development staging qa)
set :default_stage, "qa"
require 'capistrano/ext/multistage'

set :application, "goodsmaster"

# Use Git source control
set :scm, :git
set :repository, "git@github.com:ZombieHarvester/GoodsMaster.git"
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

  # Avoid keeping secured configuration in git.
  task :copy_secured_configuration, :roles => :app do
    %w(mongoid.yml secured_settings.yml).each do |file|
      db_config = "/var/www/projects/#{application}/#{rails_env}/config/#{file}"
      run "cp #{db_config} #{release_path}/config/#{file}"
    end
  end
end

namespace :demo do
  desc "Creating symbolic link to demo data"
  task :symlink, :roles => :app do
    demo_path = "/var/www/projects/#{application}/#{rails_env}/shared/demo"
    run "ln -s #{demo_path} #{release_path}/lib/tasks/demo"
  end
end

before "deploy", "delayed_job:stop"
before "deploy:assets:precompile", "deploy:copy_secured_configuration"
after "deploy", "delayed_job:start"
after "deploy", "newrelic:notice_deployment" # This goes out even if the deploy fails, sadly
after "deploy", "deploy:cleanup" # keeps only last 5 releases



