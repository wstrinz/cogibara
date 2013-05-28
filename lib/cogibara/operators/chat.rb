require 'cleverbot'
require 'curb'

class Chat < Cogibara::OperatorBase
  def initialize_operator
    @cleverbot_client = Cleverbot::Client.new
    pf_ID = self.operator_config["Bot_ID"].to_i
    if pf_ID > 0
      @pf_ID = pf_ID
    end
  end

  def process(message)
    if @pf_ID
      reply = Curl.post("http://www.personalityforge.com/directchat.php?BotID=#{@pf_ID}&MID=8", {Message: message.text, action: "Send Message", UserID: @pf_ID})
      reply.body_str.slice(/<\!-- Bot's reply -->.*?<\!-- end section -->/m).slice(/<span class="bigfont">.*<\/span>/m).gsub(/<.*>/,'').gsub("\n\t",'')
    else
      @cleverbot_client.write message.text
    end

  end
end