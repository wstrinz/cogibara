# require_relative 'wolfram_alpha/'
require 'wolfram'
class WolframAlpha < Cogibara::OperatorBase

  def initialize_operator
    Wolfram.appid = self.operator_config["API_KEY"]
  end

  def resultToString(result)
    rhash = Wolfram::HashPresenter.new(result).to_hash
    rarr = []
    rhash[:pods].keys.each do |key|
      value = rhash[:pods][key][0]
      rarr << (key + ":\n\t" + value + "\n")
    end
    rarr.join
  end

  def process(message)
    # puts "asking wolfram #{query}"
    query = message.text
    result = resultToString(Wolfram.fetch(query))
    # puts result == "Result:\n"
    # result == "Result:\n" ? nil : result

  end
end