# 🚀 Guia de Início Rápido - Autenticação Molho

## ⚡ TL;DR - 5 Minutos para Começar

### 1️⃣ Firebase Console (2 min)

1. Acesse: https://console.firebase.google.com/project/molho-review-app
2. Vá em **Authentication** → **Sign-in method**
3. Ative:
   - ✅ Email/Password
   - ✅ Google
   - ✅ Apple

### 2️⃣ Baixar GoogleService-Info.plist (30 seg)

1. Firebase Console → **Project Settings** (engrenagem)
2. Seção **Your apps** → App iOS
3. Download **GoogleService-Info.plist**
4. Substitua o arquivo no projeto

### 3️⃣ Info.plist (1 min)

1. Abra o novo `GoogleService-Info.plist`
2. Copie o valor de `REVERSED_CLIENT_ID`
3. No `Info.plist`, adicione:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>[COLE O REVERSED_CLIENT_ID AQUI]</string>
        </array>
    </dict>
</array>
```

### 4️⃣ Xcode Capability (30 seg)

1. Projeto → Target "Molho" → **Signing & Capabilities**
2. **+ Capability** → **Sign in with Apple**

### 5️⃣ Dependências SPM (1 min)

Se ainda não tiver, adicione:

**File** → **Add Package Dependencies**

```
https://github.com/firebase/firebase-ios-sdk
```
Selecione: FirebaseAuth, FirebaseFirestore, FirebaseStorage

```
https://github.com/google/GoogleSignIn-iOS
```
Selecione: GoogleSignIn, GoogleSignInSwift

### 6️⃣ Build & Run! 🎉

```
Cmd + B (Build)
Cmd + R (Run)
```

---

## 🎯 Teste Rápido

### Email/Password
```
App → "Criar conta com Email" → Preencher → Criar
Verificar email recebido
```

### Google
```
App → "Continuar com Google" → Selecionar conta
```

### Apple
```
App → Botão Apple → Face ID/Touch ID
```

### Logout
```
App → Ícone perfil (canto superior direito) → 
Rolar até o fim → "Sair da Conta"
```

---

## ✅ Checklist Rápido

Antes de rodar o app:

- [ ] Firebase Authentication ativado (Email, Google, Apple)
- [ ] GoogleService-Info.plist atualizado
- [ ] REVERSED_CLIENT_ID no Info.plist
- [ ] Sign in with Apple capability adicionada
- [ ] Firebase SDK instalado via SPM
- [ ] GoogleSignIn instalado via SPM

---

## 🐛 Problemas Comuns

| Erro | Solução Rápida |
|------|----------------|
| "No app is associated" | Verificar REVERSED_CLIENT_ID no Info.plist |
| Apple button não aparece | Adicionar capability no Xcode |
| Email não enviado | Ativar Email/Password no Firebase |
| Build error (import) | Instalar dependências SPM |

---

## 📚 Mais Informações

- **Guia completo:** Ver `README.md` nesta pasta
- **Configuração detalhada:** Ver `CONFIG_ESPECIFICA_MOLHO.md`
- **Info.plist passo a passo:** Ver `INFO_PLIST_CONFIG.md`
- **Tudo implementado:** Ver `IMPLEMENTACAO_COMPLETA.md`

---

## 🎨 O que você verá

### Tela Inicial (Splash)
- Background preto
- Logo Molho centralizado
- Carregando...

### Tela de Autenticação
- Background preto
- Logo no topo
- 3 botões de login
- Link "Já tem conta?"

### Tela de Criar Conta
- Background preto
- Formulário com validações
- Botão desabilitado até preencher corretamente
- Alert de verificação de email

### Tela de Login
- Background preto
- Email e senha
- Botão de entrar

### App (após login)
- Background BRANCO ✨
- HomeView com mapa
- Botão de perfil no canto

### Perfil
- Dados do usuário
- **BOTÃO DE LOGOUT** no final (vermelho)

---

## 💡 Dicas

1. **Teste em dispositivo real** para Apple/Google Sign-In funcionarem 100%
2. **Verifique spam** para emails de verificação
3. **Limpe o build** (Cmd+Shift+K) se tiver problemas
4. **Delete o app** do simulador e reinstale se mudou configurações

---

## 🆘 Precisa de Ajuda?

1. Veja os logs no console do Xcode:
   - ✅ = Sucesso
   - ❌ = Erro

2. Procure por mensagens como:
   - "Usuário autenticado"
   - "Erro ao fazer login"
   - "Token inválido"

3. Consulte a documentação completa nos arquivos da pasta `Authentication/`

---

**Pronto! Seu sistema de autenticação está implementado! 🎉**

Se tudo estiver configurado corretamente, você terá:
- ✅ Login com Apple
- ✅ Login com Google  
- ✅ Login com Email/Senha
- ✅ Verificação de email
- ✅ Logout
- ✅ Fluxo completo funcionando

**Boa sorte com o Molho! 🌶️**

