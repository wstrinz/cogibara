module Cogibara
  class Speaker
    def speak_to_local(message, voice="rab_diphone", engine=:festival)
      if engine == :pico
        `pico2wave -w out.wav "#{self}"`
        `aplay out.wav`
        `rm ./out.wav`
      else
        `echo "#{self}" | text2wave -eval "(voice_#{voice})" | aplay`
      end
    end

    def speak_to_file(message)

    end
  end
end




