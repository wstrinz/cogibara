require 'cogibara'

require 'redis'
  # capy = CleverCapy.new
  # capy.reply_mode = :redis
  # capy.subscribeToRedis()
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
    # puts file.length
    # puts file[0]
    if file[0]
      puts "Handling as file "
      begin
        Cogibara::FileHandler.new.handle(file[0], @current_client)
      rescue Exception
        puts "an error occured! " + ($!).to_s
      end
    elsif text[0]
      puts "Handling as text"
      # begin
        Cogibara::message_handler.handle(Cogibara::Message.new(text[0],@current_client))
      # rescue Exception
        # puts "an error occured! " + ($!).to_s
      # end
    end
  end
end