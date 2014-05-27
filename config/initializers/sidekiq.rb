# request_thread_count = Puma.cli_config.options[:max_threads]

Redis.current = ConnectionPool.new(:size => 5, :timeout => 1) do
  if ENV['REDISTOGO_URL']
    Redis.new url: ENV['REDISTOGO_URL']
  else
    Redis.new
  end
end

Sidekiq.configure_server do |config|
  config.redis = Redis.current
end unless ENV['REDISTOGO_URL']
