module Cogibara
  class Confirmer

    def actions
      @actions ||= []
    end

    def add_action(message,success=nil,failure=nil)
      actions << [message,success,failure]
    end

    def confirm_action
      act = actions.shift
      if act[1]
        act[1].call
      end
    end

    def deny_action
      act = actions.shift
      if act[2]
        act[2].call
      end
    end

    def waiting?
      !actions.empty?
    end
  end
end