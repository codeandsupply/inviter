workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

rackup      DefaultRackup if defined?(DefaultRackup)
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

preload_app!

if ENV["RAILS_ENV"] == "production" || ENV["RACK_ENV"] == "production"
  before_fork do
      @sidekiq_pid ||= spawn('bundle exec sidekiq -t 25')
  end
  on_restart do
    Sidekiq.redis.shutdown { |conn| conn.close }
  end
end

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

plugin :tmp_restart
