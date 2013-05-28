require 'bing_translator'

class Translate < Cogibara::OperatorBase

  LANGUAGES = {'english' => 'en-US', 'English' => 'en-US', 'Japanese' => 'ja', 'japanese' => 'ja', 'en-US' => 'en-US', 'dutch' => 'nl-NL', 'Dutch' => 'nl-NL', 'German' => 'de-DE','german' => 'de-DE', 'Spanish' => 'es-US', 'spanish' => 'es-US'}

  def initialize_operator
    @bing = BingTranslator.new('wstrinz', 'aMAR9BHp6NxCml97/OjCaZDB/WRpCDCdmXNHXbCz83s=')
  end

  def translate(message)
    in_language = @bing.detect message
    @bing.translate message, :from => in_language, :to => "en"
  end

  def process(input)
    message = input.text
    if LANGUAGES.has_key? message
      @language = LANGUAGES[message]
      "Translating from #{message} (#{@language})"
    elsif message =~ /\Aset language/
      @language = LANGUAGES[message.split[2]]
      "Translating from #{message.split[2]} (#{@language})"
    else
      "you said: " + translate(message)
    end
  end

  def process_file(file)
    message = Cogibara::Transcriber.new.transcribe_lang(file, @language)
    "you said: " + translate(message)
  end
end