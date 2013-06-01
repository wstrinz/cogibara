# require_relative 'wolfram_alpha.rb'
require 'cleverbot'
require 'wolfram'

class Knowledge < Cogibara::OperatorBase

  PODS = ["Result", "Basic information", "Exact result", "Decimal approximation", "Properties"]
  QWORDS = %w{who what why where when how are can if what's}

  def initialize_operator
    Wolfram.appid = self.operator_config["WOLFRAM_KEY"]
    # @wolfram = WolframAlpha.new
    @cleverbot = Cleverbot::Client.new
  end

  def is_question_word?(word)
    QWORDS.include? word.downcase
  end

  def process(query)
    word = query.text.split[0]

    valid_result = false
    if is_question_word?(word)
      result = Wolfram::HashPresenter.new(Wolfram.fetch(query.text)).to_hash
      recognized = result[:pods].keys & PODS
      unless recognized.empty?
        valid_result = true
        msg = result[:pods][recognized[0]][0]
        if recognized.length > 1
          recognized.shift
          msg += ", " + recognized.map{|x| x + ": " + result[:pods][x][0].to_s}.join(", ")
        end
      end
    end

    valid_result ? msg : nil
  end
end