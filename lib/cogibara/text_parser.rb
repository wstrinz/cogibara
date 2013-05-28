module Cogibara
  class TextParser
    def parse(message)
      Message.new(message.text, {msg: message.text + " structured"})
    end
  end

end