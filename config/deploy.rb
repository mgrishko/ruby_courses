set :application, "aaa"
set :repository, "file://."
# Важно!
# Если развертка будет происходить из локального репозитория,
# тогда нужно закомментировать следующую сроку:
set :repository,  "git@git.assembla.com:webforms2.git"
dpath = "/home/hosting_max2015/projects/datapool"

set :user, "hosting_max2015"

set :use_sudo, false
set :deploy_to, dpath
set :deploy_via, :copy
set :copy_exclude, [".git"]

set :scm, :git

role :web, "lithium.locum.ru"                          # Your HTTP server, Apache/etc
role :app, "lithium.locum.ru"                          # This may be the same as your `Web` server
role :db,  "lithium.locum.ru", :primary => true # This is where Rails migrations will run

after "deploy:update_code", :copy_database_config

task :copy_database_config, roles => :app do
  db_config = "#{shared_path}/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
  run "ln -s /home/hosting_max2015/projects/datapool/shared/data #{release_path}/public/data"
end

set :unicorn_rails, "/var/lib/gems/1.8/bin/unicorn_rails"
set :unicorn_conf, "/etc/unicorn/datapool.max2015.rb"
set :unicorn_pid, "/var/run/unicorn/datapool.max2015.pid"

# - for unicorn - #
namespace :deploy do
  desc "Start application"
  task :start, :roles => :app do
    run "#{unicorn_rails} -Dc #{unicorn_conf}"
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_rails} -Dc #{unicorn_conf}"
  end
end
