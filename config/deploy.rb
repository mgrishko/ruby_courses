# RVM configuration
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, 'ree'             # Or whatever env you want it to run in.

# Bundler
require "bundler/capistrano"
# Bundler options
set :bundle_without, [:development, :test, :cucumber]

set :application, "goodsmaster"
#set :repository, "file://."
# Важно!
# Если развертка будет происходить из локального репозитория,
# тогда нужно закомментировать следующую сроку:
set :repository,  "git@git.assembla.com:webforms2.git"
set :branch, 'rails3'
dpath = "/var/www/projects/goodsmaster"

set :user, "gmadmin"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :use_sudo, false

set :deploy_to, dpath
set :deploy_via, :copy
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
after "deploy", "deploy:cleanup"

#############################################################################################################
## RVM configuration
#$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
#require "rvm/capistrano"                  # Load RVM's capistrano plugin.
#set :rvm_ruby_string, 'ree'             # Or whatever env you want it to run in.

## Bundler
#require "bundler/capistrano"

## Bundler options
##set :bundle_without, [:development, :test, :cucumber]

#set :application, "goodsmaster"

## Use Git source control
#set :scm, :git
#set :repository,  "git@git.assembla.com:webforms2.git"
#set :branch, 'rails3'
#set :deploy_via, :remote_cache
#set :scm_verbose, true
#set :use_sudo, false

#ssh_options[:forward_agent] = true # use local keys instead of the ones on the server
#default_run_options[:pty] = true   # must be set for the password prompt from git to work
#ssh_options[:port] = 12050 # must be set to open ssh port
#role :web, "108.166.108.36"                          # Your HTTP server, Apache/etc
#role :app, "108.166.108.36"                          # This may be the same as your `Web` server
#role :db,  "108.166.108.36", :primary => true # This is where Rails migrations will run

#depend :remote, :gem, "bundler", ">=1.0.21"
#depend :remote, :gem, "rake", ">=0.9.2.2"

#namespace :deploy do

  ##From old version
  ##task :bundle_install do
    ##run "cd #{release_path} && rvmsudo bundle install "
    ##sudo "chmod 777 /usr/local/rvm/gems/ree-1.8.7-2011.03/bin/* "
  ##end
  #task :start do ; end
  #task :stop do ; end

  #task :restart, :roles => :app, :except => { :no_release => true } do
    #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  #end

  ##From current version
  ##desc "Restarting mod_rails with restart.txt"
  ##task :restart, :roles => :app, :except => { :no_release => true } do
    ##run "touch #{current_path}/tmp/restart.txt"
  ##end

  ##[:start, :stop].each do |t|
    ##desc "#{t} task is a no-op with mod_rails"
    ##task t, :roles => :app do ; end
  ##end
#end


##task :copy_database_config, roles => :app do
  ##db_config = "#{shared_path}/database.yml"
  ##run "cp #{db_config} #{release_path}/config/database.yml"
  ##run "ln -s #{dpath}/shared/data #{release_path}/public/data"
##end

#after "deploy:update_code", :copy_database_config
##after "deploy:update_code", "deploy:bundle_install"




