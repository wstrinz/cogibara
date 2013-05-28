module Cogibara
  class FileHandler

    def handle(file, clientID)
      Responder.new.send_reply("@transcribe",clientID)
      handle_audio(file, clientID)
    end

    def handle_audio(file, clientID, options={})
      if Cogibara::config.active_file_mode
        if Cogibara::dispatcher.registered_file?(Cogibara::config.active_file_mode)
          response = Cogibara::dispatcher.call_file(Cogibara::config.active_file_mode, file)
          Responder.new.send_reply(response,clientID)
        else
          puts "active file mode #{Cogibara::config.active_file_mode} enabled but not registered, doing the regular thing"
          newmessage = Message.new(Transcriber.new.transcribe(file), clientID)
          Responder.new.send_reply("you: #{newmessage.text}",clientID)
          Cogibara::message_handler.handle(newmessage)
        end
      else
        newmessage = Message.new(Transcriber.new.transcribe(file), clientID)
        Responder.new.send_reply("you: #{newmessage.text}",clientID)
        Cogibara::message_handler.handle(newmessage)
      end
    end

    def handle_video(file)

    end

    def handle_image(file)
      "images not yet implemented"
    end

    def handle_other(file)
      "#{file} not supported"
    end

    def convert_to_audio(file)

    end
  end

end