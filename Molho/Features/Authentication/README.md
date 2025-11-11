# Sistema de Autenticação - Molho

## 📋 Visão Geral

Sistema completo de autenticação implementado com Firebase Authentication, suportando múltiplos métodos de login:

- **Apple Sign-In** (Sign in with Apple)
- **Google Sign-In** 
- **Email e Senha** (com verificação de email)

## 🎨 Design

O fluxo de autenticação segue o design do Figma com:
- **Background preto** para todas as telas de auth (Splash, Login, Sign Up)
- **Background branco** após autenticação bem-sucedida
- **Componentes nativos do iOS** (SignInWithAppleButton, TextField, SecureField)

## 📁 Estrutura de Arquivos

```
Features/Authentication/
├── SplashView.swift           # Tela inicial com logo
├── AuthenticationView.swift   # Tela principal de escolha de método
├── SignUpView.swift           # Criação de conta com email/senha
├── LoginView.swift            # Login com email/senha
└── README.md                  # Este arquivo

Shared/Services/
└── AuthenticationManager.swift # Gerenciador de autenticação
```

## 🔐 Funcionalidades Implementadas

### 1. AuthenticationManager
- Singleton compartilhado (`AuthenticationManager.shared`)
- Observable para atualizar UI automaticamente
- Métodos para todos os tipos de login
- Tratamento de erros em português
- Listener de estado de autenticação

### 2. SplashView
- Exibida enquanto verifica autenticação inicial
- Logo do Molho centralizado
- Background preto

### 3. AuthenticationView
- Tela principal de escolha de método de login
- 3 botões: Apple, Google, Email
- Link para tela de Login (usuários existentes)
- Background preto

### 4. SignUpView
- Formulário de criação de conta
- Campos: Nome, Email, Senha, Confirmar Senha
- Validações em tempo real
- Envio automático de email de verificação
- Background preto

### 5. LoginView
- Formulário simplificado de login
- Campos: Email, Senha
- Validação de email
- Mensagens de erro em português
- Background preto

### 6. Fluxo de Logout
- Botão de logout adicionado na ProfileView
- Desconecta do Firebase e Google
- Retorna para tela de autenticação

## ⚙️ Configuração Necessária

### 1. Firebase Authentication

No Console do Firebase, ative os seguintes métodos:

#### Email/Password
1. Vá em **Authentication > Sign-in method**
2. Ative **Email/Password**
3. Configure templates de email (opcional)

#### Google Sign-In
1. Ative **Google** no Sign-in method
2. O `GoogleService-Info.plist` já contém as configurações

#### Apple Sign-In
1. Ative **Apple** no Sign-in method
2. Configure no **Apple Developer Portal**:
   - Vá em **Certificates, Identifiers & Profiles**
   - Em **Identifiers**, selecione seu App ID
   - Ative **Sign in with Apple**
   - Configure o Service ID no Firebase Console

### 2. Info.plist

Adicione as seguintes configurações no `Info.plist`:

```xml
<!-- Para Google Sign-In -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Substitua pelo REVERSED_CLIENT_ID do GoogleService-Info.plist -->
            <string>com.googleusercontent.apps.SEU_CLIENT_ID</string>
        </array>
    </dict>
</array>

<!-- Para Apple Sign-In -->
<key>com.apple.developer.applesignin</key>
<array>
    <string>Default</string>
</array>
```

### 3. Xcode Capabilities

No Xcode, vá em **Signing & Capabilities** e adicione:

1. **Sign in with Apple**
2. Verifique se o Bundle Identifier está correto

### 4. Dependências SPM

Certifique-se de que os seguintes pacotes estão instalados via Swift Package Manager:

- **Firebase** (https://github.com/firebase/firebase-ios-sdk)
  - FirebaseAuth
  - FirebaseFirestore
  - FirebaseStorage
- **GoogleSignIn** (https://github.com/google/GoogleSignIn-iOS)

## 🔄 Fluxo de Autenticação

```
App Inicia
    ↓
SplashView (verificando auth)
    ↓
├─ Autenticado? → HomeView (app principal)
│
└─ Não autenticado? → AuthenticationView
                          ↓
                    ├─ Apple Sign-In → HomeView
                    ├─ Google Sign-In → HomeView
                    ├─ Criar conta → SignUpView → Email verificação → HomeView
                    └─ Já tem conta → LoginView → HomeView
```

## 📧 Verificação de Email

Quando um usuário cria conta com email/senha:

1. Conta é criada no Firebase
2. Email de verificação é enviado automaticamente
3. Alert é exibido informando o usuário
4. Usuário pode acessar o app mesmo sem verificar (opcional: adicionar verificação obrigatória)

Para tornar a verificação obrigatória, adicione em `AuthenticationManager`:

```swift
func requireEmailVerification() async throws {
    guard let user = Auth.auth().currentUser else {
        throw AuthError.noCurrentUser
    }
    
    try await user.reload()
    
    if !user.isEmailVerified {
        throw AuthError.emailNotVerified
    }
}
```

## 🎯 Como Testar

### 1. Teste de Email/Senha
- Abra o app → "Criar conta com Email"
- Preencha os dados
- Verifique o email recebido (pode estar no spam)
- Faça logout e login novamente

### 2. Teste de Google
- Abra o app → "Continuar com Google"
- Selecione uma conta Google
- Autorize o app

### 3. Teste de Apple
- Abra o app → Botão Apple
- Use Face ID/Touch ID
- Autorize o compartilhamento de informações

### 4. Teste de Logout
- Entre no app
- Vá para o Perfil (ícone no canto superior direito)
- Role até o final
- Clique em "Sair da Conta"
- Verifique se volta para tela de login

## 🐛 Solução de Problemas

### Google Sign-In não funciona
- Verifique se o `REVERSED_CLIENT_ID` está correto no Info.plist
- Confirme que o Bundle ID está correto no Firebase Console

### Apple Sign-In não funciona
- Verifique se a capability está ativa no Xcode
- Confirme a configuração no Apple Developer Portal
- Teste em dispositivo real (não funciona no simulador em alguns casos)

### Email de verificação não chega
- Verifique spam/lixo eletrônico
- Configure templates personalizados no Firebase Console
- Verifique as configurações de domínio autorizado

## 🔒 Segurança

- Senhas são gerenciadas pelo Firebase (não armazenadas localmente)
- Tokens são armazenados de forma segura pelo Firebase SDK
- Sign in with Apple usa OAuth 2.0
- Google Sign-In usa OAuth 2.0

## 📱 Experiência do Usuário

- **Validações em tempo real**: Feedback imediato sobre erros
- **Loading states**: Indicadores de progresso durante operações
- **Mensagens de erro em português**: Fácil compreensão
- **Design consistente**: Background preto até login completo
- **Transições suaves**: Navegação natural entre telas

## 🚀 Próximos Passos (Opcional)

1. Adicionar "Esqueci minha senha"
2. Forçar verificação de email antes de acessar app
3. Adicionar telefone como método de login
4. Implementar perfil social (vincular múltiplos métodos)
5. Adicionar login biométrico (Face ID/Touch ID)

