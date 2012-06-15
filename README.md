# Redis::Central

redis-central providers a helper for providing access and configuration to a single per-application/thread, optionally namespaced, redis client.

## Installation

    gem install redis-central
    
## Usage

### Shared client
At it's most basic (and it's all pretty basic), redis-central provides your classes and objects with a "redis" helper method for accessing a single redis client. In this form it will return a [Redis](https://github.com/redis/redis-rb) instance

	require 'redis-central'
	
	class User
	
	  include Redis::Central
	  
	  attr_accessor :id, :name
	  
	  def self.find(id)
	    user = User.new
	    user.name = redis.get "users:#{id}:name"
	  end
	  
	  def save
	    redis.set "users:#{id}:name", name
	  end
	  
	end
	
Both the class and its instances will have access to the redis method. Other classes can also include Redis::Central, and these will have access to the same redis client instance.

Configuration options which would normally be passed to the Redis instance can be set on the ``Redis::Central`` class, eg.

    Redis::Central.port = 1234

### Namespacing
The real motivation for this library, however, is to provide an easy means of centrally namespacing redis keys for an application.

This is particularly useful where a single redis server is being used for multiple deployments of the same application, or for applications which share a model/ models which are persisted through redis, or simply scenarios were redis keys could clash between applications. 

So for instance you could have an initializer containing something like this:

	app_name = RAILS_ROOT.split(File::SEPARATOR).last
	Redis::Central.namespace = app_name
	
In this scenario calls to the redis method will return an instance of [Redis::Namespace](https://github.com/defunkt/redis-namespace), namespaced with the given setting. All queries to this object will then be prefixed accordingly.

## Testing

    bundle install
    rake test

## Author
Si Wilkins