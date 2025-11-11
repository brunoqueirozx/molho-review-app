# 🔍 Verificar Apple Developer Portal

## ⚠️ Erro 1000 Persistente

Se você já adicionou a capability no Xcode mas o erro 1000 continua, o problema pode estar no **Apple Developer Portal**.

---

## 📋 Verificar App ID no Apple Developer Portal

### Passo 1: Acessar o Portal

1. Acesse: https://developer.apple.com/account/resources/identifiers/list
2. Faça login com sua Apple ID de desenvolvedor

### Passo 2: Encontrar seu App ID

1. Na lista de **Identifiers**, procure por: `molho.review.Molho`
2. Ou procure por qualquer App ID que corresponda ao seu Bundle Identifier

### Passo 3: Verificar Sign in with Apple

1. Clique no App ID para ver os detalhes
2. Procure na lista de **Capabilities** por: **"Sign in with Apple"**
3. Verifique se está:
   - ✅ **Enabled** (com checkbox marcado)
   - ❌ Se não estiver habilitado, continue para o Passo 4

### Passo 4: Habilitar Sign in with Apple (se necessário)

1. Clique em **"Edit"** (no canto superior direito)
2. Role até encontrar **"Sign in with Apple"**
3. **Marque o checkbox** para habilitar
4. Clique em **"Save"** ou **"Continue"**
5. Confirme as alterações

### Passo 5: No Xcode

Depois de habilitar no Portal:

1. **Feche o Xcode completamente**
2. Reabra o projeto
3. No Xcode: **Product → Clean Build Folder** (`Shift + Cmd + K`)
4. **Product → Build** (`Cmd + B`)
5. Rode o app novamente

---

## 🆔 Se o App ID não existe

Se você não encontrou o App ID `molho.review.Molho` no portal:

### Opção A: Criar o App ID

1. No portal, clique em **"+"** para criar novo identifier
2. Selecione **"App IDs"** → Continue
3. Selecione **"App"** → Continue
4. Preencha:
   - **Description:** Molho Review App
   - **Bundle ID:** `molho.review.Molho` (Explicit)
5. Em **Capabilities**, marque:
   - ✅ **Sign in with Apple**
6. **Continue** → **Register**

### Opção B: Usar Bundle ID automático do Xcode

O Xcode pode criar o App ID automaticamente:

1. No Xcode, vá em **"Signing & Capabilities"**
2. Certifique-se de que **"Automatically manage signing"** está marcado
3. Selecione seu **Team**
4. O Xcode vai criar/registrar o App ID automaticamente

---

## 🔄 Regenerar Provisioning Profile

Às vezes é necessário regenerar o provisioning profile:

### No Xcode:

1. **Signing & Capabilities**
2. Desmarque **"Automatically manage signing"**
3. Espere alguns segundos
4. **Marque** novamente **"Automatically manage signing"**
5. O Xcode vai regenerar os profiles

---

## 📱 Testar em Dispositivo Real

Sign in with Apple funciona melhor em **dispositivo físico**:

1. Conecte um iPhone/iPad real
2. Selecione o dispositivo no Xcode
3. Build e run
4. Teste o Sign in with Apple

---

## 🔐 Verificar Apple ID no Xcode

Certifique-se de que você está logado:

1. **Xcode → Settings** (ou Preferences)
2. **Accounts**
3. Verifique se sua **Apple ID** está adicionada
4. Se não estiver, clique em **"+"** para adicionar

---

## ⚙️ Informações do Projeto Molho

- **Bundle ID:** `molho.review.Molho`
- **Firebase Project:** `molho-review-app`
- **Entitlements:** `MolhoRelease.entitlements`

---

## 🆘 Erro Comum: "No matching App ID found"

Se aparecer este erro no Xcode:

1. O App ID não existe ou não tem a capability habilitada
2. Siga os passos acima para criar/habilitar
3. Ou deixe o Xcode gerenciar automaticamente com "Automatically manage signing"

---

## ✅ Checklist Final

Antes de testar novamente:

- [ ] Capability "Sign in with Apple" adicionada no Xcode
- [ ] App ID existe no Apple Developer Portal
- [ ] App ID tem "Sign in with Apple" habilitado no Portal
- [ ] Team selecionado no Xcode
- [ ] "Automatically manage signing" marcado
- [ ] Clean Build Folder executado
- [ ] Rebuild feito
- [ ] Testando em dispositivo real (recomendado)

---

## 📞 Se Continuar com Problema

Possíveis causas adicionais:

1. **Conta de desenvolvedor expirada ou sem permissões**
2. **Bundle ID com caracteres especiais ou inválidos**
3. **Firebase não configurado para Apple Sign In**
4. **Provisioning profile corrompido**

Nesse caso:
- Tente usar uma conta de desenvolvedor diferente
- Verifique o Firebase Console se Apple está habilitado
- Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData`

---

**Boa sorte! 🍀**

