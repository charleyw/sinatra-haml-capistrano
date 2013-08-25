require 'bundler/capistrano'

require "rvm/capistrano"


# == application configuration
set :application, "myapp"
set :user, "wang"
set :use_sudo, false

#set :ssh_options, {:keys => [File.join(ENV["HOME"], ".ssh", "id_rsa.myapp")]}

set :scm, :git
set :repository, "https://github.com/charleyw/sinatra-haml-capistrano.git"
set :deploy_via, :remote_cache
set :deploy_to, "/opt/apps/#{application}"

role :app, "192.168.1.104"

set :runner, user
set :admin_runner, user

# == rvm configuration
set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"       # more info: rvm help autolibs
set :rvm_ruby_string, "1.9.3@#{application}"
set :rvm_type, :user # this is the money config, it defaults to :system

before 'deploy:setup', 'rvm:install_rvm'  # install RVM
before 'deploy:setup', 'rvm:install_ruby' # install Ruby and create gemset


namespace :deploy do
  task :start, :roles => :app do
    run "cd #{deploy_to}/current && nohup bundle exec thin -C config/production_config.yml -R config.ru start"
  end

  task :stop, :roles => :app do
    run "cd #{deploy_to}/current && nohup bundle exec thin -C config/production_config.yml -R config.ru stop"
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
    run "tail -f #{deploy_to}/current/log/thin.log"
  end
end
