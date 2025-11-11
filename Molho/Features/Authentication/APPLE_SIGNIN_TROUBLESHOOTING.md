# 🍎 Troubleshooting - Sign in with Apple

## ✅ Checklist de Verificação

### 1. Verificar Capability no Xcode

**No Xcode:**

1. Abra o projeto `Molho.xcodeproj`
2. Selecione o **target "Molho"** no Project Navigator
3. Vá para a aba **"Signing & Capabilities"**
4. Procure por **"Sign in with Apple"**
   - ✅ Se estiver lá: OK!
   - ❌ Se NÃO estiver: Clique em **"+ Capability"** e adicione **"Sign in with Apple"**

### 2. Verificar Bundle ID

**No Xcode:**

1. Em **"Signing & Capabilities"**, verifique o **Bundle Identifier**
2. Deve ser: `molho.review.Molho`
3. Anote esse Bundle ID

### 3. Verificar no Apple Developer Portal

**Acesse:** https://developer.apple.com/account/resources/identifiers/list

1. Encontre seu App ID: `molho.review.Molho`
2. Clique para editar
3. Verifique se **"Sign in with Apple"** está:
   - ✅ **Enabled** (habilitado)
   - ✅ Se não estiver, habilite e salve

### 4. Verificar Entitlements

**Arquivo:** `Molho/MolhoRelease.entitlements`

Deve conter:
```xml
<key>com.apple.developer.applesignin</key>
<array>
    <string>Default</string>
</array>
```

✅ **Status:** Já está configurado corretamente!

### 5. Verificar Firebase Console

**Acesse:** https://console.firebase.google.com/project/molho-review-app/authentication/providers

1. Vá em **Authentication → Sign-in method**
2. Procure por **Apple**
3. Verifique se está **Enabled** (habilitado)
4. Se não estiver:
   - Clique em **Apple**
   - Clique em **Enable**
   - Salve

### 6. Verificar Logs no Console

Quando tentar fazer login com Apple, verifique o **Console do Xcode**.

Você deve ver logs assim:

```
🍎 Preparando request do Apple Sign In...
🍎 ✅ Nonce gerado e configurado: abc123...
🍎 ✅ Scopes solicitados: fullName, email
🍎 [1/5] Verificando credencial...
🍎 ✅ Credencial válida. User ID: 001234.abc...
🍎 [2/5] Extraindo token...
🍎 ✅ Token extraído com sucesso
🍎 [3/5] Nonce atual: abc123...
🍎 [4/5] Criando credencial Firebase...
🍎 ✅ Credencial Firebase criada
🍎 [5/5] Fazendo login no Firebase...
🍎 ✅ Login no Firebase bem-sucedido! UID: xyz...
🍎 ✅ Login com Apple realizado com sucesso!
```

### 7. Erros Comuns

#### Erro: "Invalid credential"
**Causa:** Credencial não é do tipo ASAuthorizationAppleIDCredential
**Solução:** Verificar se está usando o botão nativo `SignInWithAppleButton`

#### Erro: "Invalid token"
**Causa:** Token não encontrado ou não pode ser convertido
**Solução:** 
- Verificar se a capability está ativa no Xcode
- Verificar se o App ID tem Sign in with Apple habilitado

#### Erro: "Nonce atual: NENHUM"
**Causa:** O método `prepareAppleSignInRequest` não foi chamado
**Solução:** ✅ Já está corrigido no código atual

#### Erro no Firebase
**Causa:** Apple Sign In não habilitado no Firebase
**Solução:** Habilitar no Firebase Console (ver passo 5)

### 8. Testando em Dispositivo Real

⚠️ **IMPORTANTE:** Sign in with Apple **NÃO funciona no simulador** se você não tiver uma conta Apple configurada.

**Para testar:**
1. Use um **dispositivo físico**
2. Ou configure uma Apple ID no simulador em **Settings → Apple ID**

### 9. Verificar Team e Signing

**No Xcode:**

1. **Signing & Capabilities**
2. Verifique se:
   - **Team:** Está selecionado (seu time/conta)
   - **Signing Certificate:** Está válido
   - **Provisioning Profile:** Está ativo

### 10. Reconstruir o Projeto

Se nada funcionar:

1. **Product → Clean Build Folder** (`Cmd+Shift+K`)
2. Feche o Xcode
3. Delete a pasta `DerivedData`:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
4. Reabra o projeto
5. **Product → Build** (`Cmd+B`)

## 🔍 Como Debugar

### Passo 1: Testar o botão
1. Rode o app
2. Toque em **"Continuar com Apple"**
3. O que acontece?
   - ✅ Abre a tela de login da Apple → Bom sinal
   - ❌ Nada acontece → Problema no botão/callback
   - ❌ Erro imediato → Verificar logs

### Passo 2: Verificar logs
1. Abra o **Console** no Xcode (View → Debug Area → Activate Console)
2. Filtre por "🍎" para ver apenas logs do Apple Sign In
3. Identifique onde o processo para

### Passo 3: Verificar erro específico
- Se parar em **[1/5]**: Problema com a credencial da Apple
- Se parar em **[2/5]**: Problema com o token
- Se parar em **[3/5]**: Problema com o nonce
- Se parar em **[4/5]**: Problema ao criar credencial Firebase
- Se parar em **[5/5]**: Problema ao autenticar no Firebase

## 📋 Informações Úteis

**Bundle ID:** `molho.review.Molho`
**Firebase Project:** `molho-review-app`
**Entitlements:** `MolhoRelease.entitlements`

## 🆘 Se Nada Funcionar

1. Verifique se você está usando uma **conta de desenvolvedor válida**
2. Verifique se o **App ID está registrado** no Apple Developer Portal
3. Tente **criar um novo App ID** e configurar tudo de novo
4. Entre em contato com o suporte da Apple Developer

## ✅ Teste Final

Após seguir todos os passos:

1. **Limpe o build** (Product → Clean Build Folder)
2. **Rode em um dispositivo real** (não simulador)
3. **Toque em "Continuar com Apple"**
4. **Complete a autenticação**
5. **Verifique os logs no console**

Se ver "🍎 ✅ Login com Apple realizado com sucesso!" → **SUCESSO!** 🎉

## 📝 Notas

- O código já está correto e configurado
- O problema geralmente é de configuração no Xcode ou Apple Developer Portal
- Logs detalhados foram adicionados para facilitar o debug
- Erros são exibidos em alertas nativos do iOS

