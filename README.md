# GameShop

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



composer create-project --prefer-dist laravel/laravel gameshopapi
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
meu front é um app feito em fluter o back vou usar laravel
com base na minha descrição abaixo quero comecar a produção dop back em larazem do zero:

Estrutura de Telas para Flutter:

## Tela de Registro/Login:

Opções para registro por e-mail, Google ou Facebook.
Validação do e-mail.
Etapa adicional para informações do usuário.

## Tela Principal (Lista de Anúncios):

Pesquisa por nome do jogo, poder, % de ataque, preço, etc.
Lista de anúncios com título, preço e vendedor.

## Detalhes do Anúncio:

Fotos da conta em um carrossel.
Descrição detalhada da conta.
Informações do vendedor, depoimentos e avaliação.

## Área do Vendedor:

Anúncios ativos e vendidos.
Opções para criar/editar anúncios.
Informações do vendedor e status de verificação.

## Criação/Edição de Anúncio:

Inserção do link do Google Drive.
Campos para % de ataque, poder, data de início e preço.

## Área de Configurações:

Opções para alterar informações visíveis, planos e configurações gerais.

## Avaliações e Depoimentos:

Lista de avaliações com comentários e classificações dos vendedores.
Estrutura do Banco de Dados (SQL):

## Tabela de Usuários:

ID (Chave Primária)
Nome
E-mail
idade
Tipo de Usuário (Comprador ou Vendedor)
Dados Visíveis (Configurações do que é visível para outros usuários)
Verificado (Booleano)
aceitou termos de serviço
avatar ou foto ou imagem

# caso vendedor adicionar ao usuario
whatsapp
line
telegram
apelido
nome da revenda
campo para confirmar o pagamento ou nao sei ainda como faz isso


# caso vendedor queria ser verificado
cpf 
identidade
foto slef para vaçidar documentos
endereço
cep
cidade
estado
bairro


## Tabela de Anúncios:

ID (Chave Primária)
ID do Vendedor (Chave Estrangeira para Tabela de Usuários)
Link do Google Drive
Descrição
% de Ataque Cavalaria
% de Ataque Arqueiros
% de Ataque Infantaria
estrelas de castelo
Poder
Data de Início
tipo da moeda corrente
Preço
tipos de vinculos
Status (Ativo, Inativo, Vendido)


## Tabela de Avaliações Vendedores:

ID (Chave Primária)
ID do Avaliador (Chave Estrangeira para Tabela de Usuários)
ID do Vendedor 
Comentário
Classificação (Estrelas)
Esta estrutura é um ponto de partida e pode ser adaptada conforme as necessidades específicas do seu aplicativo. Certifique-se de adicionar índices, chaves estrangeiras e outras otimizações conforme necessário para o desempenho e integridade dos dados.


## Favoritos
ID (Chave Primária)
ID do Anúncio
ID do Usuario


ps: se tiver algo a mais para mudar ou acrescentar me avise