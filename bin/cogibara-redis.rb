#!/usr/bin/env ruby

require 'cogibara'

require 'redis'
@red = Redis.new

Cogibara.setup do |config|
  config.name = "cucumber"
end

if ARGV[0]
  load "./#{ARGV[0]}"
end

Redis.new.subscribe(:toCapy) do |on|
  on.message do |channel, msg|
    # puts msg
    file = @red.hmget("#{msg}",'file')
    text = @red.hmget("#{msg}",'text')
    @current_client = @red.hmget("#{msg}",'client')[0].to_i
    puts "message from #{@current_client}"
    if file[0]
      puts "Handling as file "
      begin
        Cogibara::FileHandler.new.handle(file[0], @current_client)
      rescue Exception
        puts "an error occured! " + ($!).to_s
      end
    elsif text[0]
      puts "Handling as text"
        Cogibara::message_handler.handle(Cogibara::Message.new(text[0],@current_client))
    end
  end
end