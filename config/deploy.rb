# The Capistrano tasks will use your **working copy**, compile the assets and deploy them to the server_address
# Execute one of the following to deploy into staging or production:
#   $ bundle exec cap staging deploy
#   $ bundle exec cap production deploy
# Rollback one step:
#   $ bundle exec cap [staging|production] deploy:rollback

require 'capistrano/ext/multistage'
require 'fileutils'

config = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'deploy.yml'))

set :server_address, config['server_address']
server server_address, :web
set :use_sudo, false

set :stages, %w(staging production)
set :default_stage, "staging"

set :application, "assets"
set :asset_env, "RAILS_GROUPS=assets"

set :deploy_via, :copy # Use local copy, be sure to update the stuff you want to deploy
assets_path = "public/assets/"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set(:user) do
   Capistrano::CLI.ui.ask "Username for #{server_address}: "
end

before "deploy", "deploy:continue", "build"
after "deploy", "deploy:create_symlink", "deploy:cleanup", "build:cleanup"

namespace :deploy do
  desc "Deploy assets to server"
  task :default do
    run_locally "cd public && tar -jcf assets.tar.bz2 assets"
    top.upload "public/assets.tar.bz2", "#{releases_path}", :via => :scp
    run "cd #{releases_path} && tar -jxf assets.tar.bz2 && rm assets.tar.bz2 && mv assets #{release_name}"
  end

  task :continue do
    puts "This will use your **working copy**, compile the assets and deploy them to #{server_address} #{releases_path}/#{release_name}"
    continue = Capistrano::CLI.ui.ask "Do you want to continue [y/n]: "
    if continue.downcase != 'y' && continue.downcase != 'yes'
      Kernel.exit(1)
    end
  end
end

namespace :build do
  desc "Precompile assets locally"
  task :default do
    run_locally("rake build:masthead RAILS_ENV=#{rails_env}")
    run_locally("rake assets:clobber && rake assets:precompile assets:remove_digests RAILS_ENV=#{rails_env}")
  end

  desc "Remove locally compiled assets"
  task :cleanup do
    run_locally("rake assets:clobber")
    run_locally("rm public/assets.tar.bz2")
  end
end
