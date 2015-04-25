# config valid only for Capistrano 3.4.0
lock '3.4.0'

set :application, 'pr3zale'
set :repo_url, 'git@github.com:renemeye/pr3zale.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/srv/pr3zale'

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
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :assets_prefix, 'presale/assets/'


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo /usr/sbin/service thin restart -C /etc/thin/pr3zale"
    end
  end

  after :publishing, :restart
end
