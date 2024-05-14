require './lib/gemini_ai'

p "#{GeminiService.new.call("Pode me dizer oque você pode fazer?")}"
