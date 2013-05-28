require 'google_calendar'

class Calendar < Cogibara::OperatorBase

  def initialize_operator
    @calendar = Google::Calendar.new(username: 'wstrinz', password: 'wvyqigxaonctilxe', app_name: 'cogibara-calendar-operator')
  end

  def process(message)
    info = message.structure
    puts info
    case info[:action]
    when :CALENDAR_CREATE_EVENT
      # puts info
      title = info[:entities][:title]? info[:entities][:title][0] : "Untitled event"
      if info[:entities][:daterange]
        start_t = Time.parse(info[:entities][:daterange][0][:start] + " " + info[:entities][:timerange][0][:start])
        end_t = Time.parse(info[:entities][:daterange][0][:start] + " " + info[:entities][:timerange][0][:end]) # use same day because broken?
      else
        start_t = Time.parse(info[:entities][:timerange][0][:start])
        end_t = Time.parse(info[:entities][:timerange][0][:end]) # use same day because broken?
      end


      create_event = lambda do
        say "adding #{title} to your calendar"
        @calendar.create_event do |e|
          e.title = title
          e.start_time = start_t
          e.end_time = end_t
        end
      end
      # {code: :confirm, message: "create calendar event #{title} from #{start_t} to #{end_t}?", success: create_event}
      puts "confirming event"
      confirm("create calendar event #{title} from #{start_t} to #{end_t}?", create_event)
    else
      puts "unsupported calendar operation #{info[:action]}, returning nil"
      nil
    end
  end
end