set :application, "webforms"

role :app, "178.63.67.133"
role :db, "178.63.67.133", :primary => true
role :web, "178.63.67.133"

set :user, 'pyromaniac'
set :deploy_to, "/home/pyromaniac/projects/#{application}"
set :scm, :git
set :repository, "file://."
set :branch, "master"
set :git_enable_submodules, true
set :deploy_via, :copy
set :copy_exclude, [".git"]
set :git_enable_submodules, 1
set :use_sudo, false

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy:symlink" do
  run "ln -s #{File.join(shared_path, 'upload/')} #{File.join(current_path, 'public/upload')}"
  run "ln -s #{File.join(shared_path, 'database.yml')} #{File.join(current_path, 'config/database.yml')}"
end
