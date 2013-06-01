require "cogibara/version"
require 'yaml'

module Cogibara
  class << self
    def setup
      yield config
    end

    def setup_dispatcher
      yield dispatcher
    end

    def config
      @config ||= Configuration.new
    end

    def default_config
      # dispatcher.config_from_yaml(YAML.load_file('cogibara/default_config.yml'))
      load 'cogibara/default_config.rb'
    end

    def dispatcher
      @dispatcher ||= Dispatcher.new
    end

    def speaker
      @speaker ||= Speaker.new
    end

    def responder
      @responder ||= Responder.new
    end

    def message_handler
      @handler ||= MessageHandler.new
    end

    def file_handler
      @file_handler ||= FileHandler.new
    end

    def confirmer
      @confirmer ||= Confirmer.new
    end

    def say(message)
      speak message if config.speak
      text message if config.text
    end

    def text(message)
      responder.send_reply(message.text, message.clientID) if config.use_redis
      puts message.text if config.local
    end

    def speak(message)
      speaker.speak_to_local(message)
    end

    def config_from_yaml(yml)
      dispatcher.config_from_yaml(yml)
    end
    # def config[entry]
    #   @config ? @config.config[entry] : nil
    # end
  end
end

require 'cogibara/message.rb'
require 'cogibara/configuration.rb'
require 'cogibara/file_handler.rb'
require 'cogibara/text_parser.rb'
require 'cogibara/message_handler.rb'
require 'cogibara/dispatcher.rb'
require 'cogibara/speaker.rb'
require 'cogibara/responder.rb'
require 'cogibara/transcriber.rb'
require 'cogibara/confirmer.rb'
require 'cogibara/operator_base.rb'

Cogibara.default_config
