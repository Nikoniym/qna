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
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end


namespace :active_job do
  desc 'Start sidekiq and ActiveJob'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "sidekiq -q default -q mailers --index 0 --pidfile /home/deployer/qna/shared/tmp/pids/sidekiq-0.pid --logfile /home/deployer/qna/shared/log/sidekiq.log --daemon"
        end
      end
    end
  end
end

namespace :git do
  desc 'Deploy'
  task :deploy do
    ask(:message, "Commit message?")
    run_locally do
      execute "git add -A"
      execute "git commit -m '#{fetch(:message)}'"
      execute "git push"
    end
  end
end

# before :deploy, 'git:deploy'
