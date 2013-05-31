# Cogibara
    
Your friendly natural language interface to computer and the internet, leveraging the power of NLP techniques used in applications such as Siri! Why let your someone else decide what you need your personal assistant software to do? Cogibara uses free and open source libraries and APIs to let you ask general knowledge or math questions, manage your calendar, or just chat when you're bored. It's easy to add new capabilites or integrate other tools; the gem handles the infrastructure and language processing so you can focus on making your Cogibara do whatever awesome things you want it to.

For a demo, try tweeting [@Cogibara](https://twitter.com/cogibara), or check out the [demo client](http://goo.gl/7XOou) and its [github page](https://github.com/wstrinz/cogibara-client). Its just something I put together with ExtJS and Rails, so it's got some bugs at the moment, but it should give you an idea of what the gem can do.

**NOTE**  
This gem is still in development, there is no documentation besides this readme, I haven't written any tests, and important things may be implemented in very silly ways. Feel free [tell me](https://github.com/wstrinz/cogibara/issues) where this is so (I'd appreciate it in fact), but you've been warned. I was planning on keeping this private for a few more months of development, however other projects have come up for the summer, so I'm releasing what I have now in case I don't get much time to work on it.

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

See here for an example which will help you set up all of the built-in modules: https://gist.github.com/wstrinz/5666591

### Runtime Configuration

You can call to `Cogibara::config` to fetch or update your configuration, and `Cogibara::dispatcher` to add new external operators using the following syntax: 

    Cogibara::dispatcher.register_operator([mod_keywords], {name: mod_name, file_name: mod_file, class_name: mod_class_name, config: mod})

If you do not provide an option, the dispatcher will attempt to fill it in based on the other options and various naming conventions.

### Configuration Block

Explanation coming soon, see examples -

    require 'cogibara'
    Cogibara.setup do |config|
      config.name = "Mr Robot"
      config.verbose = true
    end
    Cogibara.setup_dispatcher do |dispatcher|
      dispatcher.register_operator(["REMINDER"],{name: "Reminder Setter"})
      dispatcher.register_operator(["chat"],{name: "Chat Bot", class_name:  "Chat", file_name: "chat.rb"})
    end

## Extending

It's easy to add new functionality to your Cogibara, just add a `process(message)` method to your code, and add your class or file to the list of modules using `Cogibara::dispatcher.register_operator`. You can also extend the `Cogibara::OperatorBase` class, which will allow you to utilize some built in helper methods for things like sending multiple messages and handling confirmation callbacks.

Your operator must be bound to a list of keywords or natural language categories. The Maluuba Natural Speech API, which the gem current uses for language processing, places speech into a number of different categories and extracts information such as dates and times. You can bind your operator to any category, or to any individual 'action' in a category, then handle queries and the structured information Maluuba extracts in whatver way you need to.

Cogibara can recognize both individual keywords and categories of natural speech. Keyword queries are of the form "[name] [keyword] message", and natural language queries can be hooked into using the [categories](http://dev.maluuba.com/categories) for the Maluuba API. To add a new module, either from a file or an existing Class object, simply call `Cogibara::dispatcher.register_operator(['keyword','list'],{name: "Operator Name"})`, which will attempt to load the operator based on standard Ruby naming conventions. In this case, it will be looking for a `operator_name.rb` file, or a class object called `OperatorName`. By specifying `class_name` or `file_name` options, you can override this behavior to define your own custom naming.

As an example, here's how you might go about adding an operator that tells you your current location:

    require 'cogibara'
    require 'geocoder'
    require 'json'
    require 'open-uri'
    class Locator < Cogibara::OperatorBase
      def process(message)
        ip = 0
        open( 'http://jsonip.com/ ' ){ |s| ip = JSON::parse( s.string())['ip'] }
        loc = Geocoder.search(ip)
        "You are in #{loc[0].city}, #{loc[0].state}!"
      end
    end

    Cogibara.default_config

    # Register operator under the 'where am I?' Maluuba speech category, and the 'location' keyword.
    Cogibara::dispatcher.register_operator(['NAVIGATION_WHERE_AM_I', 'location'], {name: 'Locator'})
    
    # natural language query
    Cogibara::message_handler.handle("so where am I now?")
      #=> "You are in Madison, Wisconsin!"
    
    # keyword query
    Cogibara::message_handler.handle("cogibara location")
      #=> "You are in Madison, Wisconsin!"

## Credit

This project would not be possible without the awesome gems and APIs available for free online. Here is a list of all the built in services, please let me know if I'm missing someone or you'd like your gem or service to be removed from this project.

[speech2text gem](https://github.com/taf2/speech2text), by [Todd Fisher](https://github.com/taf)  
[wolfram gem](https://github.com/cldwalker/wolfram), by [Gabriel Horner](https://github.com/cldwalker)  
[Maluuba Natural Language API](http://dev.maluuba.com/), by [Maluuba Inc](http://www.maluuba.com/)  
[maluuba_napi gem](https://github.com/Maluuba/napi-ruby), by [Maluuba Inc](http://www.maluuba.com/)  
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

**A few things I'll try to get in place in the next week**  
-Fix file handling (will only do transcription for now)  
-An executable to listen on a local source (eg microphone). I have code for this from an earlier version of the gem, I just need to update it.  
-Add Speech to Text output to configuration. Again, I also have some work done on this, so it shouldn't take too long to add back in. Espeak will be the default, but you'll be able to specify alternate engines if they're available. Currently I'm rather partial to Pico.  

**Things that may have to wait/wishlist for contributions**  
-RSpec tests  
-Documentation; RDocs would be nice, but pages for the wiki or more details for this document would also be good.  
-A better client to use by default. Preferably using a lighter weight framework such as Sinatra, and allowing easy access for mobile devices.  
-Find replacements for C Extensions; there are a lot of good language processing tools for Java, so it'd be nice for this gem to be JRuby compatible.  
-More offline operators. A simple request now often goes through 3 APIs; Google Speech Recognition, Maluuba's natural language processing, and whatever keyword function it hits after that. By adding support for [PocketSphinx](http://cmusphinx.sourceforge.net/2010/03/pocketsphinx-0-6-release/) and/or something link [LingPipe](http://alias-i.com/lingpipe/) would speed up response times enormously.  
-More operators in general, and improve the current ones. For example, the weather operator only gives current conditions and the days forecast, but it could easily be extended to handle more specific queries using the information extracted by Maluuba.  