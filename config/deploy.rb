# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application, 'qna'
set :repo_url, 'git@github.com:Nikoniym/qna.git'

set :stage, :production

set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

append :linked_files, 'config/database.yml', 'config/master.key'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end


namespace :sphinx do
  desc 'Start sphinx server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "rails ts:index"
          # execute :bundle, :exec, "rails ts:start"
        end
      end
    end
  end
end
#
#   desc 'Stop private_pub server'
#   task :stop do
#     on roles(:app) do
#       within current_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, "exec thin -C config/private_pub_thin.yml stop"
#         end
#       end
#     end
#   end
#
#   desc 'Restart private_pub server'
#   task :restart do
#     on roles(:app) do
#       within current_path do
#         with rails_env: fetch(:rails_env) do
#           execute :bundle, "exec thin -C config/private_pub_thin.yml restart"
#         end
#       end
#     end
#   end
# end
#
# after 'deploy:restart', 'private_pub:restart'
