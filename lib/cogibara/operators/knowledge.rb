# require_relative 'wolfram_alpha.rb'
require 'cleverbot'
require 'wolfram'

class Knowledge < Cogibara::OperatorBase

  PODS = %w(Result Exact\ Result Basic\ information Decimal\ approximation)

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

    valid_result == false
    if is_question_word?(word)
      result = Wolfram::HashPresenter.new(Wolfram.fetch(query.text)).to_hash
      recognized = result[:pods].keys & PODS
      unless pods.empty?
        valid_result = true
        msg = result[:pods][recognized[0]][0]
        if recognized.length > 1
          recognized.shift
          msg = recognized.map{|x| x + ": " + result[:pods][x][0].to_s}.join(", ")
        end
      end
      # else
      #   valid_result == false
      # if result[:pods]["Result"] || result[:pods]["Exact result"] || result[:pods]["Basic information"]
      #   if result[:pods]["Result"]
      #     msg = result[:pods]["Result"][0]
      #   elsif result[:pods]["Exact result"]
      #     msg = result[:pods]["Exact result"][0]
      #   elsif result[:pods]["Basic information"]
      #     msg = result[:pods]["Basic information"][0]
      #   end
      # end
      # valid_result = !(!result[:pods]["Result"] || result[:pods]["Result"][0] == "(data not available)")
    end

    valid_result ? msg : nil
    
    # valid_result ? result[:pods]["Result"][0] : @cleverbot.write(query.text)
  end
end