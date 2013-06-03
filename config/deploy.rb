# The Capistrano tasks will use your **working copy**, compile the assets and deploy them to the server_address
# Execute one of the following to deploy into staging or production:
#   $ cap staging deploy
#   $ cap production deploy
# Rollback one step:
#   $ cap [staging|production] deploy:rollback

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
# set :scm, :git
# set :repository_root, config[:repository_root]
assets_path = "public/assets/"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set(:user) do
   Capistrano::CLI.ui.ask "Username for #{server_address}: "
end

before "deploy", "deploy:continue", "build"
before "build", "build:masthead"
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
    run_locally("rake assets:clean && rake assets:precompile RAILS_ENV=#{rails_env}")
  end

  desc "Convert masthead html to a javascript string variable"
  task :masthead do
    html = File.read('content/masthead.html')
    js_var = html_to_javascript_variable(html, "malmoMasthead")
    File.open('app/assets/javascripts/masthead_content.js', 'w') do |f|
      f.puts("// Auto generated from content/masthead.html by cap build:masthead. Don't edit this file.")
      f.puts(js_var)
      f.close
    end
  end

  desc "Remove locally compiled assets"
  task :cleanup do
    run_locally("rake assets:clean:all")
    run_locally("rm public/assets.tar.bz2")
  end
end

def html_to_javascript_variable(html, var_name)
  puts "Convert #{var_name} html to a javascript string"
  html = html.gsub(/^\s+/, '').gsub(/\s+/, ' ').gsub(/'/, '"').gsub(/\n/, ' ')
  "var #{var_name} = '#{html}';"
end
