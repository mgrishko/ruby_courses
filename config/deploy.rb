set :application, "aaa"
set :repository, "file://."
# Важно!
# Если развертка будет происходить из локального репозитория,
# тогда нужно закомментировать следующую сроку:
#set :repository,  "git@git.assembla.com:webforms2.git"

set :branch, 'rails3'
dpath = "/var/www/projects/datapool"

set :user, "demo"
set :password, "Sfer5C"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :use_sudo, false

set :deploy_to, dpath
set :deploy_via, :copy
set :copy_exclude, [".git"]

set :scm, :git

role :web, "46.4.115.40"                          # Your HTTP server, Apache/etc
role :app, "46.4.115.40"                          # This may be the same as your `Web` server
role :db,  "46.4.115.40", :primary => true # This is where Rails migrations will run

after "deploy:update_code", :copy_database_config

task :copy_database_config, roles => :app do
  db_config = "#{shared_path}/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
  run "ln -s #{dpath}/shared/data #{release_path}/public/data"
end


# - for unicorn - #
namespace :deploy do
  task :change_owner_demo do
    sudo "chown -R demo:demo #{dpath}"
  end

  task :change_owner_apache do
    sudo "chown -R apache:apache #{dpath}"
  end

  task :bundle_install do
    run "cd #{release_path} && rvmsudo bundle install "
    sudo "chmod 777 /usr/local/rvm/gems/ree-1.8.7-2011.03/bin/* "
  end

  task :start do ; end
  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

end

#before "deploy:update_code", "deploy:change_owner_demo"
#after "deploy:update_code", "deploy:change_owner_apache"
after "deploy:update_code", "deploy:bundle_install"

