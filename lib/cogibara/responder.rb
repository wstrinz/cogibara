require 'redis'

module Cogibara
  class Responder
    def redis
      @redis ||= Redis.new
    end

    def send_reply(message, client, options={type: "text"})
      if(Cogibara::config.use_redis)
        redis.multi do
          redis.incr "sendMsgNum"
          @msgid = redis.get "sendMsgNum"
        end

        redis.hmset("sendMsg:#{@msgid.value}",options[:type],message,"client",client)
        redis.publish("fromCapy","sendMsg:#{@msgid.value}")
      end
      if(Cogibara::config.local)
        puts message unless message[0] == "@"
      end
    end
  end
end