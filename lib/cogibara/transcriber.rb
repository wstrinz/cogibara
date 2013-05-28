require 'speech'

module Cogibara
  class Transcriber
    def make_temp_file(file)
      fname = "tempfile-"+((Time.now.to_f*100000).to_i.to_s)
      File.open(fname,'wb') {|f| f.write(file)}
      fname
    end

    def remove_temp_file(filestring)
      `rm ./#{filestring}`
    end

    def transcribe(file)
      filestring = make_temp_file(file)
      result = Speech::AudioToText.new(filestring).to_json #(2, "en-US")
      remove_temp_file filestring
      # puts result
      if(result["hypotheses"].first)
        result["hypotheses"].first.first
      else
        # "Sorry, I didn't understand that".to_speech
        Cogibara::say "Sorry, I didn't understand that"
        nil
      end
    end

    def transcribe_lang(file, language)
      filestring = make_temp_file(file)
      result = Speech::AudioToText.new(filestring).to_json(2, language)
      remove_temp_file filestring
      # puts result
      if(result["hypotheses"].first)
        result["hypotheses"].first.first
      else
        # "Sorry, I didn't understand that".to_speech
        Cogibara::say "Sorry, I didn't understand that"
        nil
      end
    end
  end

end