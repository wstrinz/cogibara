module Cogibara
  class OperatorBase

    attr :clientID
    attr :message_text
    attr :message_structure
    attr :operator_config

    def initialize(config={})
      @operator_config = config
      initialize_operator if self.respond_to?(:initialize_operator)
    end

    def receive_message(message)
      @clientID = message.clientID
      @message_text = message.text
      @message_structure = message.structure
      process(message)
    end

    def process(message)
      "!!!text processing not implemented for this operator!!!"
    end

    def process_file(file)
      "!!!file processing not implemented for this operator!!!"
    end

    def say(message)
      Cogibara::say Message.new("#{Cogibara::config.name}: " + message, @clientID)
    end

    def confirm(message, success=nil, failure=nil)
      puts "new confirm"
      Cogibara::confirmer.add_action(message, success)
      message
    end
  end
end