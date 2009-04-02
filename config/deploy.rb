### Application deployment setup

set :application,         "say"
set :repository,          "git://github.com/lackac/say.git"
set :scm,                 :git

set :keep_releases,       5
set :user,                "lackac"
set :runner,              user
set :use_sudo,            false
set :deploy_to,           "/home/lackac/apps/#{application}"
set :deploy_via,          :remote_cache


set :domain, 'lackac.hu'
role :web, domain
role :app, domain
role :db , domain, :primary => true

set :rack_env, "production"


after "deploy", "deploy:cleanup"
after "deploy:migrations" , "deploy:cleanup"


namespace :deploy do
  %w(start restart).each do |action|
    desc "Let Phusion Passenger #{action} the processes"
    task action.to_sym, :roles => :app do
      passenger.restart
    end
  end

  desc "Stop task is a no-op with Phusion Passenger"
  task :stop, :roles => :app do ; end
end

namespace :passenger do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
