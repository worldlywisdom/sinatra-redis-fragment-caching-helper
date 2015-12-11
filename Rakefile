require 'digest/sha1'
require 'redis'

CACHE = Redis.new(url: ENV["REDIS_URL"])

namespace :cache do

  task :reset do
    # USAGE: heroku run rake cache:reset
    desc "Delete all keys from the cache database"
    puts "Deleting entire cache... "
    CACHE.flushdb
    puts "Done."
  end

  namespace :key do

    task :delete do
      # USAGE: heroku run rake cache:key:delete key="thekey"
      desc "Delete specific key from the cache database"
      puts "Removing key #{ENV['key']} from cache... "
      CACHE.del("#{ENV['key']}")
      puts "Key #{ENV['key']} deleted."
    end

  end

end
