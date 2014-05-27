Redis.current = ConnectionPool.new(:size => 5, :timeout => 1) do
  if ENV['REDISTOGO_URL']
    Redis.new url: ENV['REDISTOGO_URL']
  else
    Redis.new
  end
end

Sidekiq.configure_server do |config|
  config.redis = Redis.current
end

Sidekiq.configure_client do |config|
  config.redis = Redis.current
end
