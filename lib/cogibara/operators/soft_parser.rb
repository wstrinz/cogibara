require 'maluuba_napi'

class SoftParser < Cogibara::OperatorBase
  def initialize_operator
    @api_key = self.operator_config["API_KEY"]
    @client = MaluubaNapi::Client.new(@api_key)
  end

  def normalize(message, type)
    @client.normalize phrase: message, type: type, timezone:"CST"
  end

  def normalize_msg!(msg, response)
    if response[:entities]
      if response[:entities][:daterange]
        n = normalize(msg, "daterange")[:entities][:daterange]
        response[:entities][:daterange] = n if n
      end
      if response[:entities][:timerange]
        n = normalize(msg, "timerange")[:entities][:timerange]
        response[:entities][:timerange] = n if n
      end
      if response[:entities][:time]
        n = normalize(msg, "time")[:entities][:time]
        response[:entities][:time] = n if n
      end
    end
  end

  def process(message)
    response = @client.interpret phrase: message.text
    normalize_msg!(message.text, response)
    ## Should normalize times and do something with them
    # time_categories = [:REMINDER, :ALARM, :TIMER]
    # timerange_categories = [:TIMER]
    # date_categories = [:CALENDAR]
    #
    # if time_categories.includes? response[:category]
    #   normalized = @client.normalize phrase: message, type: 'time', timezone: 'CST'
    # elsif timerange_categories.includes? response[:category]
    #   normalized = @client.normalize phrase: message, type: 'timerange', timezone: 'CST'
    # elsif date_categories.includes? response[:category]
    #   normalized = @client.normalize phrase: message, type: 'daterange', timezone: 'CST'
    # end
    #
    response
  end
end