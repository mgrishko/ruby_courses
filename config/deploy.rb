# RVM configuration
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                              # Load RVM's capistrano plugin.
set :rvm_ruby_string, 'ree'             # Or whatever env you want it to run in.

# Bundler
require "bundler/capistrano"
set :application, "goodsmaster"

# Bundler options
set :bundle_without, [:development, :test, :cucumber]

set :application, "goodsmaster"
set :branch, 'rails3'
set :rails_env, "production"
set :user, "gmadmin"
set :rvm_type, :user


# Git
set :scm, :git
set :repository,  "git@git.assembla.com:webforms2.git"
set :deploy_to, "/var/www/projects/goodsmaster"
set :deploy_via, :remote_cache
set :scm_verbose, true
set :use_sudo, false
set :copy_exclude, [".git"]

ssh_options[:port] = 12050 # must be set to open ssh port
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :use_sudo, false

role :web, "108.166.108.36"                          # Your HTTP server, Apache/etc
role :app, "108.166.108.36"                          # This may be the same as your `Web` server
role :db,  "108.166.108.36", :primary => true # This is where Rails migrations will run

task :copy_database_config, roles => :app do
  db_config = "#{shared_path}/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
  run "ln -s /var/www/projects/goodsmaster/shared/data #{release_path}/public/data"
end

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

after "deploy:update_code", :copy_database_config

