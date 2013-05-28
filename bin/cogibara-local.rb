require 'cogibara.rb'
# require './config.rb'
require 'slop'



def text(msg)
  Cogibara::message_handler.handle(msg) #.text.to_s
end


def text_loop
  loop do
    text $stdin.gets
  end
end

def text_or_file
  if File.exist?("./#{@msg}")
    Cogibara::file_handler.handle(File.open("./#{ARGV[0]}",'rb').read, "local")
  else
    text(@msg)
  end
end

def parse
  # opts = Slop.parse(autocreate: true)

  opts = Slop.parse do
    on 'v', 'verbose', 'Verbose mode'
    on 'm=', 'message', 'Message'
    on 'n=', 'name', 'Name'
    on 'c=', 'config', 'Configuration file'
  end
  # puts opts

  @verbose = opts.verbose?
  @msg = opts[:message]
  @name = opts[:name] || "cucumber"
  @config_file = opts[:config]

  if !@msg
    if @config_file
      @verbose = false
      @name = "cucumber"
      configure
      text_loop
    else
      @msg = ARGV.join(' ')
      @name = "cucumber"
      @verbose = false
    end
  end
end

def configure
  if @config_file
    load './' + @config_file.to_s
  end
  Cogibara.setup do |config|
    config.name = @name unless @name.nil?
    config.local = true
    config.use_redis = false
    config.verbose = @verbose unless @verbose.nil?
  end
end

parse

configure

ARGV[0] ? text_or_file : text_loop