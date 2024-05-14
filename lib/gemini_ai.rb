require 'gemini-ai'
require 'dotenv'

# Carrega as variáveis de ambiente do arquivo .env
Dotenv.load

# Serviço para interação com a API do Gemini
class GeminiService
  def initialize
    @gemini_client = Gemini.new(
      credentials: { service: 'generative-language-api', api_key: ENV['GEMINI_API_KEY'] },
      options: { model: 'gemini-pro' }
    )
  end

  def call(text)
    generate_content(text)
  rescue StandardError => error
    "Erro ao processar a resposta: #{error.message}"
  end

  private

  def generate_content(text)
    request_params = {
      contents: {
        role: 'user',
        parts: { text: text }
      }
    }
    @gemini_client.stream_generate_content(request_params).map do |response|
      response.dig('candidates', 0, 'content', 'parts', 0, 'text').gsub(/[\n\\*#]+/, ' ')
    end.join(" ")
  end
end
