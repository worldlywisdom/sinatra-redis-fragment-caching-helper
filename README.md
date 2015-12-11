Sinatra Redis Fragment Caching Helper
=====================================================

A Sinatra helper extension that makes fragment caching with Redis easy.

Features
--------

* Makes fragment caching in Sinatra super simple.
* Can be used in views and routes.
* Expiration can be managed individually for each fragment.
* The cache can be bypassed inline for debugging.
* Works in both development and production via easy ENV["REDIS_URL"] configuration.
* No dependencies outside of Sinatra and Redis.

Installation
------------

Place the helper in a directory (like <code>/app</code> or <code>/lib</code>), then include it in your main Sinatra application. I usually use something like:

  ### Require all app files
  Dir['./app/*.rb'].each { |f| require(f) }

Then, copy the commands in Rakefile into your application. Two commands are available, which will allow you to manage keys in the cache:

  cache:reset # Remove all keys from the cache
  cache:key:delete key="yourkey" # Remove a specific key from the cache

How To Use
----------

Usage in ERB views or partials:

  <% cache key: "cache-key", expires: 86400, bypass: false do %>
    This is the block to evaluate.
  <% end %>

Usage in Sinatra routes:

  get '/' do
    cache key: "cache-key", expires: 86400, bypass: false do
      This is the block to evaluate.
    end
  end

Connecting To Redis
-------------------

The helper relies on <code>ENV["REDIS_URL"]</code> to connect to Redis. This should automatically allow you to Redis in development, then switch over production seamlessly.

Credits
-------

Special thanks to [Bryan Thompson](https://gist.github.com/bryanthompson/277560) for sharing a Gist that inspired this helper.
