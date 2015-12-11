# A Redis fragment caching helper for Sinatra
# Usage in ERB views or partials:
# <% cache key: "cache-key", expires: 86400, bypass: false do %>
#   This is the block to evaluate.
# <% end %>
# Can also be used in normal Sinatra routes.
# Cache key and expires keywords are mandatory.
# Bypass and block are optional.
# Inspired by https://gist.github.com/bryanthompson/277560

require 'sinatra/base'
require 'redis'

# Set Redis connection information
CACHE = Redis.new(url: ENV["REDIS_URL"])
# Set ERB output buffer variable in Sinatra
set :erb, :outvar => '@output_buffer'

module Sinatra
  module RedisCacheHelper
    def cache(key:, expires:, bypass: false, &block)
      begin
        # Try cache unless bypass is set to true (optional)
        unless bypass == true
          fragment = CACHE.get(key)
          # Return cached fragment to ERB if CACHE.get returns a value for the key
          if fragment
            @output_buffer = fragment
          # Evaluate block and write fragment to cache if CACHE.get returns nil
          else
            if block_given?
              fragment = block.call
              CACHE.setex(key, expires.to_i || 86400, fragment)
              @output_buffer = fragment
            end
          end
        # Bypass cache by yielding block if bypass is set to true
        else
          @output_buffer = block.call
        end
      # Bypass cache by yielding block if there's a Redis connection error or timeout
      rescue Redis::CannotConnectError || Redis::ConnectionError || Redis::TimeoutError
        @output_buffer = block.call
      end
    end

    # Delete key from cache unless there's a Redis connection error
    def cache_expire(key:)
      begin
        CACHE.delete(key)
      rescue Redis::CannotConnectError || Redis::ConnectionError || Redis::TimeoutError
        exit
      end
    end

  end
  helpers RedisCacheHelper
end
