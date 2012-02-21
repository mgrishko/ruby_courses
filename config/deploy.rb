# RVM configuration
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                              # Load RVM's capistrano plugin.
set :rvm_ruby_string, 'ree-1.8.7-2012.01@gm_old'             # Or whatever env you want it to run in.
set :rvm_type, :user

# Bundler
require "bundler/capistrano"

# Bundler options
set :bundle_without, [:development, :test, :cucumber]
set :application, "goodsmaster"
set :repository,  "git@git.assembla.com:webforms2.git"
set :branch, 'rails3'
dpath = "/var/www/projects/goodsmaster"

set :user, "gmadmin"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :use_sudo, false

set :deploy_to, dpath
set :deploy_via, :remote_cache
set :copy_exclude, [".git"]

set :scm, :git

ssh_options[:port] = 12050 # must be set to open ssh port
role :web, "108.166.108.36"                          # Your HTTP server, Apache/etc
role :app, "108.166.108.36"                          # This may be the same as your `Web` server
role :db,  "108.166.108.36", :primary => true # This is where Rails migrations will run

task :copy_database_config, roles => :app do
  db_config = "#{shared_path}/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
  run "ln -s #{dpath}/shared/data #{release_path}/public/data"
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:update_code", :copy_database_config
#after "deploy", "deploy:cleanup"
