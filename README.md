# Chat App

Este é um aplicativo de chat simples desenvolvido em Flutter, utilizando Firebase para autenticação, armazenamento e banco de dados em tempo real. O aplicativo permite que os usuários enviem mensagens de texto e imagens, com a opção de autenticação via Google.

## Funcionalidades

- **Autenticação com Google**: Permite que os usuários façam login utilizando suas contas do Google.
- **Envio de Mensagens de Texto**: Os usuários podem enviar mensagens de texto que são armazenadas no Firestore.
- **Envio de Imagens**: Os usuários podem tirar fotos com a câmera e enviá-las diretamente no chat.
- **Visualização de Mensagens**: As mensagens são exibidas em tempo real e organizadas por ordem cronológica decrescente.

## Tecnologias Utilizadas

- **Flutter**: Framework utilizado para desenvolver a interface de usuário.
- **Firebase**:
  - **Firebase Auth**: Usado para autenticação de usuários.
  - **Cloud Firestore**: Banco de dados em tempo real utilizado para armazenar as mensagens.
  - **Firebase Storage**: Utilizado para armazenar as imagens enviadas pelos usuários.
- **Google Sign-In**: API utilizada para autenticação com o Google.

## Estrutura do Projeto

- **lib/main.dart**: Arquivo principal que inicializa o Firebase e configura o `MaterialApp`.
- **lib/chat_screen.dart**: Tela principal que exibe o chat e as mensagens.
- **lib/text_composer.dart**: Widget que compõe a caixa de entrada de texto e o botão de envio.
- **lib/chat_message.dart**: Widget que exibe as mensagens enviadas pelos usuários.

## Uso

Após a configuração, execute o aplicativo em um dispositivo ou emulador. O usuário precisará fazer login com uma conta do Google antes de poder enviar mensagens. Mensagens de texto e imagens podem ser enviadas e serão exibidas na tela de chat em tempo real.
