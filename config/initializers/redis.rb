uri = URI.parse(ENV["REDIS_URL"])
REDIS = Redis.new(url: ENV['REDIS_URL'])
