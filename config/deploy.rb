# config valid only for Capistrano 3.3.5
lock '3.3.5'

set :application, 'prezale'
set :repo_url, 'git@github.com:renemeye/pr3zale.git'
set :branch, "prezale.de"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/prezale.de'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/local_env.yml config/database.yml config/WWDR.pem config/passkey.pem config/passcertificate.pem}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Start application'
  task :start do
    on roles(:web) do
      execute "cd #{current_path} && RAILS_ENV=production sudo bundle exec thin start -C config/thin.yml"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{current_path} && RAILS_ENV=production sudo bundle exec thin restart -C config/thin.yml"
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{current_path} && RAILS_ENV=production sudo bundle exec thin stop -C config/thin.yml"
    end
  end

  after :publishing, :restart


  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles do
    on roles(:app) do
      execute "cd #{current_path}; RAILS_ENV=production bundle exec rake paperclip:refresh:missing_styles"
    end
  end

  after("deploy:published", "deploy:build_missing_paperclip_styles")
end
