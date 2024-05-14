# API com Sinatra: Integração do Vertex AI e Gemini 🚀

Este projeto é uma API construída com o framework Sinatra para interagir com o Vertex AI da Google e o Gemini. Ele permite que os usuários enviem perguntas através de um endpoint HTTP POST e recebam respostas processadas por modelos de inteligência artificial avançados.

## Configuração 🛠

Este projeto utiliza Ruby e o framework Sinatra. Certifique-se de ter Ruby instalado em sua máquina.

### Dependências

Para instalar as dependências do projeto, execute:

```bash
bundle install
```

### Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto e adicione as seguintes chaves de API:

```
GEMINI_API_KEY=sua_chave_api_gemini_aqui
```

Certifique-se de ter configurado as credenciais de acesso para a API do Google.

## Detalhes do Código

### Classe `GeminiService`

A classe `GeminiService` é responsável pela interação com a API do Gemini. Abaixo está o método `initialize` que configura o cliente:

```ruby
def initialize
  @gemini_client = Gemini.new(
    credentials: { service: 'generative-language-api', api_key: ENV['GEMINI_API_KEY'] },
    options: { model: 'gemini-pro' }
  )
end
```

- **Inicialização**: Este trecho configura o cliente Gemini com a chave de API fornecida e o modelo desejado.

O método `generate_content` envia o texto recebido e processa a resposta:

```ruby
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
```

- **Geração de Conteúdo**: O método processa o texto fornecido, enviando-o para a API e ajustando a resposta para remover caracteres especiais.

### Endpoint Sinatra `/gemini-ai`

O código a seguir configura um endpoint POST em `/gemini-ai` que trata as requisições:

```ruby
post '/gemini-ai' do
  content_type :text  # Define o tipo de conteúdo da resposta como texto
  question = params["question"]  # Recupera a questão do corpo da requisição

  begin
    response = GeminiService.new.call(question)
  rescue StandardError => error
    status 500
    "Erro ao processar a requisição: #{error.message}"
  end
end
```

- **Endpoint POST**: Este código define como a API recebe e responde a perguntas enviadas pelos usuários.

## Executando a Aplicação 🏃‍♂️

Para iniciar o servidor, execute:

```bash
ruby app.rb
```

## Uso 📡

Envie uma requisição POST para `http://localhost:4567/gemini-ai` com um corpo de requisição que inclua uma `question` para obter uma resposta processada pelo serviço de IA.

```bash
curl -X POST -d "question=sua_pergunta_aqui" http://localhost:4567/gemini-ai
```

## Contribuições 👥

Contribuições são bem-vindas! Para contribuir, faça um fork do repositório, crie uma branch para sua funcionalidade e submeta um pull request.
