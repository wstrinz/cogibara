module Cogibara
  class Configuration
    attr_accessor :active_mode
    attr_accessor :active_file_mode

    def defaults
      {
        name: "cogibara",
        speak: false,
        speech_engine: :espeak,
        text: true,
        hard_parse: true,
        soft_parse: true,
        verbose: true,
        local: false,
        use_redis: false,
      }
    end

    def name=(name)
     @name = name
    end

    def name
      @name.nil? ? defaults[:name] : @name
    end

    def speak=(speak)
      @speak=speak
    end

    def speak
      @speak.nil? ? defaults[:speak] : @speak
    end

    def hard_parse=(hard_parse)
      @hard_parse=hard_parse
    end

    def hard_parse
      @hard_parse.nil? ? defaults[:hard_parse] : @hard_parse
    end

    def soft_parse=(soft_parse)
      @soft_parse = soft_parse
    end

    def soft_parse
      @soft_parse.nil? ? defaults[:soft_parse] : @soft_parse
    end

    def use_redis
      @use_redis.nil? ? defaults[:use_redis] : @use_redis
    end

    def use_redis=(use_redis)
      @use_redis = use_redis
    end

    def local
      @local.nil? ? defaults[:local] : @local
    end

    def local=(local)
      @local = local
    end

    def text
      @text.nil? ? defaults[:text] : @text
    end

    def text=(text)
      @text = text
    end

    def verbose
      @verbose.nil? ? defaults[:verbose] : @verbose
    end

    def verbose=(verbose)
      @verbose = verbose
    end

  end
end