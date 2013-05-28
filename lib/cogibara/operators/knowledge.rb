# require_relative 'wolfram_alpha.rb'
require 'cleverbot'
require 'wolfram'

class Knowledge < Cogibara::OperatorBase

  def initialize_operator
    Wolfram.appid = self.operator_config["WOLFRAM_KEY"]
    # @wolfram = WolframAlpha.new
    @cleverbot = Cleverbot::Client.new
  end

  def is_question_word?(word)
    qwords = %w{who what why where when how are can if}
    qwords.include? word.downcase
  end

  def process(query)
    word = query.text.split[0]

    if is_question_word?(word)
      result = Wolfram::HashPresenter.new(Wolfram.fetch(query.text)).to_hash
      if result[:pods]["Result"] || result[:pods]["Exact result"] || result[:pods]["Basic information"]
        valid_result = true
        if result[:pods]["Result"]
          msg = result[:pods]["Result"][0]
        elsif result[:pods]["Exact result"]
          msg = result[:pods]["Exact result"][0]
        elsif result[:pods]["Basic information"]
          msg = result[:pods]["Basic information"][0]
        end
      else
        valid_result == false
      end
      # valid_result = !(!result[:pods]["Result"] || result[:pods]["Result"][0] == "(data not available)")
    else
      valid_result = false
    end

    if valid_result
      if msg == "(data not available)"
        # msg = @cleverbot.write(query.text) + " (dk)"
        # # puts msg
        # msg
        nil
      else
        msg
      end
    else
      # @cleverbot.write(query.text)
      nil
    end
    # valid_result ? result[:pods]["Result"][0] : @cleverbot.write(query.text)
  end
end