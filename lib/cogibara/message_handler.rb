module Cogibara
  class MessageHandler

    def handle(message)
      if(message.is_a? String)
        message = Message.new(message, "local")
      end

      Responder.new.send_reply("@think",message.clientID)

      if Cogibara::config.soft_parse
        message.structure = derive_structure(message)
      end


      msg = message.text
      @verbose = Cogibara::config.verbose
      @name = Cogibara::config.name

      if msg
        puts "core" if @verbose
        reply = process_core(msg, message)
        unless reply
          reply = process_confirm_deny(msg, message)
          unless reply
            splitmsg = msg
            splitmsg = splitmsg.split
            puts "instruction #{splitmsg[0]}" if @verbose
            if splitmsg[0]==@name
              slicemessage = splitmsg
              slicemessage.shift
              slicemessage = slicemessage.join(' ')
              # slicemessage.slice!(@name)
              slicemessage = slicemessage.strip
              puts "instructed #{slicemessage}" if @verbose
              # if @soft_parse

              reply = process_instruction(slicemessage, message)
              unless reply
                puts "defaults" if @verbose
                reply = process_default(msg, message)
              end
            elsif Cogibara::config.active_mode
              puts "active module #{Cogibara::config.active_mode} processing #{msg}" if @verbose
              reply = process_instruction(Cogibara::config.active_mode + " " + msg, message)
              unless reply
                puts "defaultx" if @verbose
                reply = process_default(msg, message)
              end
            elsif message.structure[:category]
              reply = process_intent(msg, message)
              unless reply
                puts "defaulty" if @verbose
                reply = process_default(msg, message)
              end
            else
              puts "defaultz" if @verbose
              reply = process_default(msg, message)
            end
          end
        end

        puts reply if @verbose
        Responder.new.send_reply("@listen",message.clientID)
        Cogibara::say Message.new("#{@name}: " + reply.to_s, message.clientID)

        reply
      end
    end

    def process_core(message, obj)
      @yourname = "person"
      message = message.chomp
      if message == "hey #{@name}"
        "what's up #{@yourname}?"
      elsif message == "reset mode"
        Cogibara::config.active_mode = nil
        Cogibara::config.active_file_mode = nil
        "Disabling any active modules"
      elsif /your name is now/ =~ message
        message.slice!("your name is now ")
        @name = message.chomp
        "OK, you can call me #{@name}"
      elsif /my name is/ =~ message
        message.slice!("my name is ")
        @yourname = message.chomp
        "OK, I'll call you #{@yourname}"
      elsif message == "what time is it"
        "it is #{Time.now.hour} o'clock and #{Time.now.min} minutes"
      else
        nil
      end
    end

    def process_default(msg, obj)
        chatmsg = Message.new(msg, obj.clientID, obj.structure)
        puts chatmsg.inspect if @verbose
        Cogibara::dispatcher.call("chat", chatmsg)
    end

    def process_instruction(message, obj)

      puts "instruction: #{message.split[0]} (#{Cogibara::dispatcher.registered?(message.split[0])})" if @verbose
      if message =~ /\Aset mode/
        message.slice!("set mode")
        Cogibara::config.active_mode = message.chomp.strip
        "Going into #{Cogibara::config.active_mode} mode"
      elsif message =~ /\Aset file mode/
        message.slice!("set file mode")
        Cogibara::config.active_file_mode = message.chomp.strip
        "Handling files with #{Cogibara::config.active_file_mode}"
      elsif Cogibara::dispatcher.registered?(message.split[0])
          splitmsg = message.split
          Responder.new.send_reply("@search",obj.clientID)
          puts "recognized instruction #{message.split[0]} (#{splitmsg})" if @verbose
          mod = splitmsg[0]
          splitmsg.shift
          Cogibara::dispatcher.call(mod, Message.new(splitmsg.join(' '), obj.clientID, obj.structure))
      else
        puts "didn't understand instruction #{message.split[0]}" if @verbose
        nil
      end
    end

    def process_intent(message, obj)
      if (obj.structure[:action] && Cogibara::dispatcher.registered?(obj.structure[:action].to_s))
        puts "recognized instruction #{obj.structure[:action]}" if @verbose
        Cogibara::dispatcher.call(obj.structure[:category].to_s,obj)
      elsif (obj.structure[:category] && Cogibara::dispatcher.registered?(obj.structure[:category].to_s))
        puts "recognized instruction #{obj.structure[:category]}" if @verbose
        Cogibara::dispatcher.call(obj.structure[:category].to_s,obj)
      else
        puts "didn't understand instruction #{message.split[0]}" if @verbose
        nil
      end
    end

    def derive_structure(message)
      response = Cogibara::dispatcher.call("maluuba",message)
    end


    def process_confirm_deny(message, obj)
      if message == "yes"
        if Cogibara::confirmer.waiting?
          Cogibara::confirmer.confirm_action
          "Confirmed!"
        end
      else
        nil
      end
    end
  end
end