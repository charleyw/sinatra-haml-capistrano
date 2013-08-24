require 'bundler/capistrano'

set :application, "myapp"
set :user, "wang"
set :use_sudo, false

#set :ssh_options, {:keys => [File.join(ENV["HOME"], ".ssh", "id_rsa.myapp")]}

set :scm, :git
set :repository, "git@git.realestate.com.au:charley-wang/easy-trip.git"
set :deploy_via, :remote_cache
set :deploy_to, "/opt/apps/#{application}"

role :app, "192.168.56.104"

set :runner, user
set :admin_runner, user

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{deploy_to}/current && nohup thin -C config/production_config.yml -R config.ru start"
  end

  task :stop, :roles => :app do
    run "cd #{deploy_to}/current && nohup thin -C config/production_config.yml -R config.ru stop"
  end

  task :restart, :roles => :app do
    deploy.stop
    deploy.start
  end

  # This will make sure that Capistrano doesn't try to run rake:migrate (this is not a Rails project!)
  task :cold do
    deploy.update
    deploy.start
  end
end

namespace :"#{application}" do
  task :log do
    run "cat #{deploy_to}/current/log/thin.log"
  end
end