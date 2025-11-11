# ⚙️ Configuração Específica do Projeto Molho

## 📋 Informações do Projeto

- **Bundle ID:** `com.brunoqueiroz.molho`
- **Firebase Project:** `molho-review-app`
- **Google App ID:** `1:623650863313:ios:640e815580f84a023dedf0`

## 🔧 Passos de Configuração

### 1. Obter o REVERSED_CLIENT_ID do Google

O arquivo `GoogleService-Info.plist` atual não contém a chave `REVERSED_CLIENT_ID`. Para obtê-la:

#### Opção 1: Baixar arquivo atualizado do Firebase Console (RECOMENDADO)

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto **molho-review-app**
3. Vá em **Project Settings** (ícone de engrenagem)
4. Role até a seção **Your apps**
5. Encontre o app iOS: `com.brunoqueiroz.molho`
6. Clique em **GoogleService-Info.plist** para baixar
7. Substitua o arquivo atual por este novo
8. O novo arquivo deve conter a chave `REVERSED_CLIENT_ID`

#### Opção 2: Ativar Google Sign-In no Firebase

Se a chave ainda não aparecer:

1. No Firebase Console → **Authentication** → **Sign-in method**
2. Clique em **Google** e ative
3. Clique em **Save**
4. Baixe o `GoogleService-Info.plist` novamente (Opção 1)

### 2. Configurar o Info.plist

Após obter o `REVERSED_CLIENT_ID` (algo como: `com.googleusercontent.apps.XXXXXXXXXX`):

1. Abra o `Info.plist` no Xcode
2. Clique com botão direito → **Add Row**
3. Adicione a seguinte estrutura:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Cole aqui o REVERSED_CLIENT_ID obtido -->
            <string>com.googleusercontent.apps.XXXXXXXXXX</string>
        </array>
    </dict>
</array>
```

### 3. Configurar Sign in with Apple

#### No Xcode:

1. Selecione o projeto no navegador
2. Selecione o target **Molho**
3. Vá em **Signing & Capabilities**
4. Clique em **+ Capability**
5. Adicione **Sign in with Apple**

#### No Firebase Console:

1. Vá em **Authentication** → **Sign-in method**
2. Clique em **Apple**
3. Ative o provider
4. Clique em **Save**

#### No Apple Developer Portal:

1. Acesse [Apple Developer](https://developer.apple.com/)
2. Vá em **Certificates, Identifiers & Profiles**
3. Em **Identifiers**, encontre `com.brunoqueiroz.molho`
4. Edite e ative **Sign in with Apple**
5. Salve as alterações

### 4. Ativar Email/Password no Firebase

1. Firebase Console → **Authentication** → **Sign-in method**
2. Clique em **Email/Password**
3. Ative ambos os toggles (Email/Password e Email link)
4. Clique em **Save**

### 5. Configurar Templates de Email (Opcional mas Recomendado)

1. Firebase Console → **Authentication** → **Templates**
2. Configure os templates para:
   - Verificação de email
   - Redefinição de senha
   - Mudança de email

Personalize com:
- Nome do app: **Molho**
- Logo do Molho
- Cores da marca

## 📦 Dependências SPM

Adicione no Xcode (File → Add Package Dependencies):

### Firebase SDK
```
https://github.com/firebase/firebase-ios-sdk
```

**Selecione os produtos:**
- FirebaseAuth
- FirebaseFirestore
- FirebaseStorage
- FirebaseCore

### Google Sign-In
```
https://github.com/google/GoogleSignIn-iOS
```

**Selecione o produto:**
- GoogleSignIn
- GoogleSignInSwift

## ✅ Checklist de Configuração

- [ ] Baixar `GoogleService-Info.plist` atualizado do Firebase
- [ ] Verificar se contém a chave `REVERSED_CLIENT_ID`
- [ ] Adicionar `CFBundleURLTypes` no `Info.plist` com o REVERSED_CLIENT_ID
- [ ] Adicionar capability "Sign in with Apple" no Xcode
- [ ] Ativar Email/Password no Firebase Console
- [ ] Ativar Google no Firebase Console
- [ ] Ativar Apple no Firebase Console
- [ ] Configurar Sign in with Apple no Apple Developer Portal
- [ ] Adicionar Firebase SDK via SPM
- [ ] Adicionar GoogleSignIn via SPM

## 🧪 Como Testar

### 1. Build do Projeto

```bash
# Limpar build
Cmd + Shift + K

# Build
Cmd + B
```

### 2. Testar no Simulador

**Email/Password:**
1. Abra o app
2. "Criar conta com Email"
3. Preencha os dados
4. Deve criar conta e enviar email

**Google Sign-In:**
1. Abra o app
2. "Continuar com Google"
3. Se configurado corretamente, abre tela do Google
4. Nota: Pode precisar de dispositivo real

**Apple Sign-In:**
1. Abra o app
2. Clique no botão Apple
3. Deve solicitar autenticação
4. Nota: Funciona melhor em dispositivo real

### 3. Verificar Logs

No console do Xcode, procure por:

```
✅ Usuário autenticado: [email]
✅ Login realizado com sucesso
✅ Conta criada com sucesso
```

Ou erros:

```
❌ Erro ao fazer login
⚠️ Token inválido
```

## 🐛 Troubleshooting Específico

### "No app is associated with this activity"
- Causa: REVERSED_CLIENT_ID não configurado ou incorreto
- Solução: Verifique o Info.plist e o valor do REVERSED_CLIENT_ID

### Bundle ID Mismatch
- Causa: Bundle ID no Xcode diferente de `com.brunoqueiroz.molho`
- Solução: Verifique em Project Settings → General → Bundle Identifier

### Google Sign-In não abre
- Causa: GoogleService-Info.plist desatualizado
- Solução: Baixe novamente do Firebase Console

### Email de verificação não enviado
- Causa: Email/Password não ativado no Firebase
- Solução: Ative em Authentication → Sign-in method → Email/Password

### Apple Sign-In não funciona no simulador
- Causa: Limitação do simulador
- Solução: Teste em dispositivo físico com iOS 13+

## 📱 Requisitos Mínimos

- **iOS:** 15.0+
- **Xcode:** 15.0+
- **Swift:** 5.9+

## 🔐 Regras de Segurança do Firebase

Certifique-se de ter as seguintes regras no Firestore:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Regra para usuários
    match /users/{userId} {
      // Apenas o próprio usuário pode ler seus dados
      allow read: if request.auth != null && request.auth.uid == userId;
      
      // Apenas o próprio usuário pode criar/atualizar seus dados
      allow create, update: if request.auth != null && request.auth.uid == userId;
      
      // Apenas o próprio usuário pode deletar seus dados
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
    
    // Regra para merchants (estabelecimentos)
    match /merchants/{merchantId} {
      // Todos podem ler
      allow read: if true;
      
      // Apenas usuários autenticados podem criar
      allow create: if request.auth != null;
      
      // Apenas o criador pode atualizar/deletar
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.createdBy;
    }
  }
}
```

## 🚀 Deploy

Antes de publicar na App Store:

1. Certifique-se de que todos os métodos de auth estão funcionando
2. Teste em dispositivos reais (iPhone/iPad)
3. Verifique se o App Store Connect tem o Bundle ID correto
4. Configure os domains autorizados no Firebase
5. Ative a verificação de App Attest (segurança adicional)

## 📞 Links Úteis

- [Firebase Console - Molho](https://console.firebase.google.com/project/molho-review-app)
- [Apple Developer Portal](https://developer.apple.com/)
- [Firebase Auth Docs](https://firebase.google.com/docs/auth/ios/start)
- [Google Sign-In Docs](https://developers.google.com/identity/sign-in/ios/start-integrating)

---

**Projeto:** Molho 🌶️
**Bundle ID:** com.brunoqueiroz.molho
**Firebase:** molho-review-app

