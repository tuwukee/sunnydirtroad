require 'redis'

module Cache
  mattr_accessor :redis
  class << self
    def get(key)
      Cache.redis.get(key)
    end

    def set(key, value, ttl=nil)
      if ttl
        Cache.redis.setex(key, ttl, value)
      else
        Cache.redis.set(key, value)
      end
    end

    def remove_eldest_key
      key = Cache.redis.keys('*').sort.first
      Cache.remove(key)
    end

    def remove(key)
      Cache.redis.del(key)
    end

    def count
      Cache.redis.keys('*').count
    end

    def establish_connection
      redis_config = YAML.load_file(File.join(Dir.pwd, 'config', 'redis.yml'))
      Cache.redis.client.disconnect if Cache.redis
      Cache.redis = Redis.new(:host => redis_config["host"], :port => redis_config["port"])
    end
  end
end