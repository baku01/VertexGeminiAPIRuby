require 'sinatra'
require './lib/gemini_ai'  # Garante que o caminho esteja correto

# Define um endpoint POST para '/gemini-ai'
post '/gemini-ai' do
  content_type :text  # Define o tipo de conteúdo da resposta como texto

  # Recupera a questão do corpo da requisição
  question = params["question"]

  # Cria uma nova instância do GeminiService e faz a chamada com a questão
  begin
    response = GeminiService.new.call(question)
  rescue StandardError => error
    status 500
    "Erro ao processar a requisição: #{error.message}"
  end
end
