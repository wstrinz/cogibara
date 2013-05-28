# require 'twilio-ruby'

class ReminderSetter < Cogibara::OperatorBase
  def process(message)

   "reminder setter heard #{message.inspect}, set reminder for (nothing right now)"
  end
end