module Cogibara
  class Message
    attr :text
    attr_accessor :structure
    attr :clientID

    def initialize(text="", clientID=-1,structure=Hash.new)
      @text = text
      @structure = structure
      @clientID = clientID
    end

    def become_clone!(msg)
      @text = msg.text
      @structure = msg.structure
      @clientID = msg.clientID

    end
  end
end