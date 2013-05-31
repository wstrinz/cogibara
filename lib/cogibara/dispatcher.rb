require 'yaml'
module Cogibara
  class Dispatcher
    def operators
      @operators ||= Hash.new
    end

    def file_operators
      @file_operators ||= Hash.new
    end

    def operator_options
      @operator_options ||= Hash.new
    end

    def operator(keyword)
      operators[keyword] = operators[keyword].new(operator_options[operators[keyword]]) if operators[keyword].is_a? Class
      operators[keyword]
    end

    def file_operator(keyword)
      file_operators[keyword] = file_operators[keyword].new(operator_options[operators[keyword]]) if file_operators[keyword].is_a? Class
      file_operators[keyword]
    end

    def register_operator(keywords, options)
      mod_keywords = keywords
      mod_name = options[:name] || keywords[0]
      mod_file = options[:file_name] ? options[:file_name] : mod_name.downcase.gsub(' ','_')
      mod_class_name = options[:class_name] ? options[:class_name] : mod_file.split('_').map{ |w| w.capitalize }.join
      mod_file += ".rb"
      loc = File.expand_path(File.dirname(__FILE__))
      require "#{loc}/operators/#{mod_file}" if File.exists?("#{loc}/operators/#{mod_file}")

      if Object.const_defined?(mod_class_name)
        mod_class = eval(mod_class_name) ## TODO prooooooobably should do this a different way
        unless (mod_class.method_defined?("process") || mod_class.method_defined?("process_file"))
          puts "process method missing for #{mod_class.to_s} in #{mod_name}"
        else
          operator_options[mod_class] = options[:config] || {}
        end
        if mod_class.method_defined?("process")
          mod_keywords.each do |kw|
            operators[kw] = mod_class
          end
        end
        if mod_class.method_defined?("process_file")
          mod_keywords.each do |kw|
            file_operators[kw] = mod_class
          end
        end
      else
        puts "main class: #{mod_class_name} not defined for module #{mod_name}"
      end
      puts "file: #{loc}/operators/#{mod_file} for module #{mod_name} does not exist, skipping load" if options[:file_name] && !File.exists?("#{loc}/operators/#{mod_file}")
    end


    def call(keyword,message)
      begin
        if operators[keyword].is_a? Cogibara::OperatorBase
          response = operator(keyword).receive_message(message)
        else
          response = operator(keyword).process(message)
        end
      rescue Exception
        puts "an error occured! " + ($!).to_s
        Cogibara::say(Cogibara::Message.new("** O Noez, an error has occured in module #{keyword}; #{($!).to_s}  **",message.clientID))
        nil
      end
      # if response.is_a? Hash
      #   if response[:code]
      #     if response[:code] == :confirm
      #       # Cogibara::Responder.new.send_reply(response[:text],message.clientID)
      #       Cogibara::confirmer.add_action(response[:message], response[:success])
      #       response[:message]
      #     else
      #       response
      #     end
      #   else
      #     response
      #   end
      # else
        response
      # end
    end

    def call_file(keyword, file)
      response = operator(keyword).process_file(file)
    end

    def registered?(keyword)
      operators.has_key?(keyword)
    end

    def registered_file?(keyword)
      puts "looking for #{keyword} in #{file_operators.keys}"
      file_operators.has_key?(keyword)
    end

    def config_from_yaml(yml)
      yml = YAML.load_file(yml) if yml.is_a? String
      yml["modules"].each do |mod|
        mod_name = mod["module_name"]
        mod_keywords = mod["keywords"]
        mod_file = mod["file_name"] ? mod["file_name"] : mod["module_name"].downcase.gsub(' ','_')
        mod_class_name = mod["class_name"] ? mod["class_name"] : mod_file.split('_').map{ |w| w.capitalize }.join
        # mod_file += ".rb"

        if mod_keywords.is_a? Array
          register_operator(mod_keywords, {name: mod_name, file_name: mod_file, class_name: mod_class_name, config: mod})
        else
          register_operator([mod_keywords], {name: mod_name, file_name: mod_file, class_name: mod_class_name, config: mod})
        end
      end
    end
  end
end