set :application, "innoco"
set :deploy_to, "/var/www/apps/#{application}"
set :use_sudo, false
default_run_options[:pty] = true 
set :mongrel_clean, true
set :scm, :git
set :repository, "ssh://thub@trustrelay.com/home/thub/work/innoco.git"
set :branch, "master"

role :app, "innoco.thubhub.com"
role :web, "innoco.thubhub.com"
role :db,  "innoco.thubhub.com", :primary => true

