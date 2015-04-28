require "plop/version"
require "redis"

module Plop
  # Throw messages into a queue.
  class Queue
    def initialize(redis = self.class.redis, name: "queue")
      @redis, @name = redis, name
    end

    # Publish a message to the queue.
    def push(message)
      @redis.lpush @name, message
    end
    alias :<< :push
    # This needs to live up to its namesake.
    alias :plop :push

    # Listen for messages. This will block if there
    # are no messages published to the queue.
    def messages
      Enumerator.new do |y|
        loop do
          y << @redis.blpop(@name).last
        end
      end
    end

    # Delete the list key from Redis.
    def clear
      @redis.del @name
    end

    # Default redis instance.
    def self.redis
      Redis.new
    end
  end
end
