# Cogibara
    
A friendly interface to your computer and the internet, leveraging the power of natural language processing techniques used in applications such as Siri! Why let your smartphone company decide what you need your personal assistant software to do? Cogibara uses free and open source software libraries and APIs to let you ask general knowledge or math questions, manage your calendar, or just chat when you're bored. It's easy ot add new capabilites or integrate other libraries; The gem handles the infrastructure and language processing so you can focus on making your Cogibara do whatever awesome things you want it to!

**NOTE**  
This gem is still in development, there is no documentation besides this readme, I haven't written any tests, and important things may be implemented in breathtakingly stupid ways. Feel free to point out where this is so (I'd appreciate it in fact), but you've been warned. I was planning on keeping this private for a few more months of development, but other projects have come up for the summer, so I'm releasing what I have now in case I don't get much time to work on it.

## Installation

Add this line to your application's Gemfile:

    gem 'cogibara'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cogibara

## Usage

The gem will install two executables; `cogibara-local` and `cogibara-redis`. Both should run fine out of the box, but many functions require an API key or account credentials to work properly. See the Configuration section for more information.
    
**Cogibara Local**  
  
    cogibara-local -m "hows it going?"
      #=> cogibara: Good and you?

    cogibara-local -c config.rb -m "what time is it in the netherlands?"
      #=> cogibara: 7:30:40 am CEST  |  Wednesday, May 29, 2013


The `cogibara-local` executable is a command line interface for the gem. 
    
    Usage: cogibara-local [options]
    -v, --verbose      Verbose output
    -m, --message      Message
    -n, --name         Name
    -c, --config       Configuration file (.rb)

If a message is specifed, the executable will print the response then exit. Otherwise, it will go into a loop until you close it.

You can also call `cogibara-local` on an audio or video file (less than 10 seconds seems to work best), and it will extract the speech from it using google's Speech To Text API, then pass the result to the gem.

**Cogibara Redis**  
The `cogibara-redis` executable uses redis to allow you to design your own interfaces for the gem. For now it requires a local redis server to be installed and running, but in the near future it will allow remote redis connections as well. This could also be used to split up the work of running the gem and serving the responses between computers, giving you the ability to install a lightweight interface on something like a Raspberry Pi and leave the heavy lifting to a desktop PC.

For more on how to use this executable, see the example Rails client [here](https://github.com/wstrinz/cogibara-client).

The demo client at [cogibara.com](http://goo.gl/7XOou) is, at the time of writing, running both server and client on a Raspberry Pi sitting in my living room. 

**Gem API**  
You can also use the gem as a part of any Ruby program

    require 'cogibara'
    require 'yaml'
    Cogibara::dispatcher.config_from_yaml(YAML.load_file('./config.yml'))
    Cogibara::message_handler.handle("hello!") 
        # => "How Are you?"
    Cogibara::message_handler.handle("what is the square root of 9954") 
        #=> "3 sqrt(1106)" 
    Cogibara::message_handler.handle("how's the weather?")
        #=> "Currently Overcast, 65 degrees, cloud cover 99%, then 
            Sprinkling for the hour." 

More details coming soon.

## API Keys

Many operators require an API key to communicate with a remote service. The gems for the individual operators will have better documentation, but here's where you can get a key for the built-in modules:  

Wolfram Alpha ([gem](https://github.com/cldwalker/wolfram)): http://developer.wolframalpha.com/portal/apisignup.html  
Maluuba ([gem](https://github.com/Maluuba/napi-ruby/blob/master/maluuba_napi/lib/maluuba_napi.rb)): http://dev.maluuba.com/  
Forecast_IO ([gem](https://github.com/darkskyapp/forecast-ruby)): https://developer.forecast.io/  

## Configuration

You have three options for configuring the gem; using a YAML file, modifying the configuration at runtime, or adding a configuration block to your code.

### YAML

Although using the gem's configuration functions is more flexible, the simplest way to get everything working is to configure the gem using YAML. This can be accomplished by calling

`Cogibara::dispatcher.config_from_yaml(YAML.load_file('./some_file.yml'))`

See here for an example which will set help you set up all of the built-in modules: https://gist.github.com/wstrinz/5666591

### Runtime Configuration

You can call to `Cogibara::config` to fetch or update your configuration, and `Cogibara::dispatcher` to add new external operators using the following syntax: 

    Cogibara::dispatcher.register_operator([mod_keywords], {name: mod_name,         file_name: mod_file, class_name: mod_class_name, config: mod})

If you do not provide an option, the dispatcher will attempt to fill it in based on the other options and various naming conventions.

### Configuration Block

Explanation coming soon, see examples -

    require 'cogibara'
    Cogibara.setup do |config|
      config.name = "Mr Robot"
      config.verbose = @verbose unless @verbose.nil?
    end
    Cogibara.setup_dispatcher do |dispatcher|
      dispatcher.register_operator(["REMINDER"],{name: "Reminder Setter"})
      dispatcher.register_operator(["chat"],{name: "Chat Bot", class_name:  "Chat", file_name: "chat.rb"})
    end

## Credit

This project would not be possible without the awesome gems and APIs available for free online. Here is a list of all the built in services, please let me know if I'm missing someone or you'd like your gem or service to be removed from this project.

[speech2text gem](https://github.com/taf2/speech2text), by [Todd Fisher](https://github.com/taf)  
[wolfram gem](https://github.com/cldwalker/wolfram), by [Gabriel Horner](https://github.com/cldwalker)  
[Maluuba Natural Language API](http://dev.maluuba.com/), by [Maluuba Inc](http://www.maluuba.com/)  
[maluuba_napi gem](https://github.com/Maluuba/napi-ruby/blob/master/maluuba_napi/lib/maluuba_napi.rb), by [Maluuba Inc](http://www.maluuba.com/)  
[Forecastio API](https://developer.forecast.io/), by [Dark Sky Company](http://forecast.io/)  
[forecast_io gem](https://github.com/darkskyapp/forecast-ruby), by [David Czarnecki](https://github.com/czarneckid)  
[Cleverbot](http://www.cleverbot.com/)  
[cleverbot gem](https://github.com/benmanns/cleverbot), by [Benjamin Manns](https://github.com/benmanns)  
[bing_translator gem](https://github.com/CodeBlock/bing_translator-gem), by [Ricky Elrod](https://github.com/CodeBlock)  
[wikipedia-client gem](https://github.com/kenpratt/wikipedia-client), by [Ken Pratt](https://github.com/kenpratt)  
[sanitize gem](https://github.com/rgrove/sanitize), by [Ryan Grove](https://github.com/rgrove)  
[Redis](http://redis.io/)  
[wikicloth gem](https://github.com/nricciar/wikicloth), by [David Ricciardi](https://github.com/nricciar/wikicloth)  
[google_calendar gem](https://github.com/northworld/google_calendar), by [Northworld LLC](http://www.northworld.com/)  
[geocoder gem](https://github.com/alexreisner/geocoder), by [Alex Reisner](http://www.alexreisner.com/)  
[slop gem](https://github.com/injekt/slop), by [Lee Jarvis](https://github.com/injekt)  

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
