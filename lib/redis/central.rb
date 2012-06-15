require 'redis-namespace'

class Redis
  
  module Central

    class << self

      REDIS_CLIENT_OPTIONS = [
        :scheme,
        :host,
        :port,
        :path,
        :timeout,
        :password,
        :db
      ] 

      attr_writer *REDIS_CLIENT_OPTIONS
      attr_writer :namespace

      def redis
        @redis ||= begin
          redis = Redis.new(client_options)
          if @namespace && @namespace =~ /\w/
            Redis::Namespace.new(@namespace, :redis => redis)
          else
            redis
          end
         end
      end

      private
      def client_options
        REDIS_CLIENT_OPTIONS.inject({}) do |memo, option|
          option_value = instance_variable_get("@#{option}")
          memo[option] = option_value if option_value
          memo
        end
      end

      def reset!
        @redis     = nil
        @namespace = nil
        REDIS_CLIENT_OPTIONS.each do |option|
          self.send("#{option}=", nil)
        end
      end

    end

    def self.included(base)
      base.send(:include, Access)
      base.extend(Access)
    end

    module Access

      def redis
        Redis::Central.redis
      end

    end

  end

end
