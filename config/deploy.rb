set :application, "goodsmaster"
set :repository,  "git@git.assembla.com:webforms2.git"

set :scm, :git
set :branch, 'rails3'
set :deploy_via, :remote_cache

set :user, "gmadmin"
set :use_sudo, false

role :web, "108.166.108.36"                          # Your HTTP server, Apache/etc
role :app, "108.166.108.36"                          # This may be the same as your `Web` server
role :db,  "108.166.108.36", :primary => true # This is where Rails migrations will run

set :deploy_to, "/var/www/projects/goodsmaster"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
