require 'forecast_io'
require 'geocoder'
require 'date'

class Weather < Cogibara::OperatorBase
  def initialize_operator
    Forecast::IO.api_key = self.operator_config["API_KEY"]
  end

  # def translate(message)
  #   in_language = @bing.detect message
  #   @bing.translate message, :from => in_language, :to => "en"
  # end

  def location_to_coordinates(location)
    Geocoder.coordinates(location)
  end

  def get_location(message)
    info = message.structure
    if info[:entities][:location]
      location_to_coordinates(info[:entities][:location][0])
    else
      [43.092, -89.369]
    end
  end

  def get_forecast_period(message)
    info = message.structure[:entities]

    if info[:daterange]
      start_d = Date.parse(info[:daterange][0][:start])
      end_d = Date.parse(info[:daterange][0][:end])
      start_d..end_d
    elsif info[:time]
      info[:time]=="tomorrow" ? Date.today + 1 : Date.today
    else
      nil
    end
  end

  def current_conditions
    # if @forecast.minutely
    #   say "now: #{@forecast.minutely.summary}"
    # end
    curr_summary = " Currently " + @forecast.currently.summary + ", "
    curr_cond = "#{@forecast.currently.temperature.round} degrees, cloud cover #{(@forecast.currently.cloudCover * 100).round}% "
    next_cond =  @forecast.minutely ? @forecast.minutely.summary : ""
    # next_cond =  @forecast.minutely ? "Then " + @forecast.minutely.summary : ""
    curr_summary + curr_cond + "then, " + next_cond
  end

  def todays_forecast
    temps = @forecast.hourly.data[0..18].map{|hr| hr.temperature}
    max_t = temps.each_with_index.max
    min_t = temps.each_with_index.min
    @forecast.hourly.summary + " The high temperature will be #{max_t[0].round} degrees, in #{max_t[1]} hours, and the low will be #{min_t[0].round} degrees, in #{min_t[1]} hours"
  end

  def week_forecast
    say @forecast.daily.summary
  end

  def process(message)
    return nil if message.text.split.include?("cool")

    @loc = get_location(message)
    @date = get_forecast_period(message)
    @forecast = Forecast::IO.forecast(@loc[0],@loc[1])

    unless @date
      current_conditions
    else
      if @date.is_a? Range
        if @date.first == Date.today || @date.first == Date.today+1
          todays_forecast
        else
          week_forecast
        end
      else
        if @date == Date.today || @date == Date.today + 1
          todays_forecast
        else
          week_forecast
        end
      end
    end
  end
end