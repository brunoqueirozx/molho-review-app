# 🔧 Como Adicionar "Sign in with Apple" Capability

## ⚠️ ERRO 1000 - Solução

Se você está vendo o erro:
```
AuthorizationError error 1000
```

Significa que a **capability "Sign in with Apple" não está configurada no Xcode**.

---

## 📋 Passo a Passo (5 minutos)

### Passo 1: Abrir Configurações do Target

1. No Xcode, **Project Navigator** (barra lateral esquerda)
2. Clique no arquivo do projeto **"Molho"** (ícone azul no topo)
3. Você verá duas seções: **PROJECT** e **TARGETS**

```
📁 Molho (pasta/projeto azul) ← CLIQUE AQUI
   └── 🎯 Molho (target)
```

### Passo 2: Selecionar o Target

Na lista à esquerda, em **TARGETS**, clique em **"Molho"**

```
TARGETS
  └── Molho ← CLIQUE AQUI
```

### Passo 3: Ir para Signing & Capabilities

No topo da área central, verá várias abas:
- General
- **Signing & Capabilities** ← CLIQUE AQUI
- Resource Tags
- Info
- Build Settings
- etc.

### Passo 4: Adicionar Capability

1. Na aba **"Signing & Capabilities"**, procure o botão:
   ```
   + Capability
   ```
   (fica no canto superior esquerdo da área de conteúdo)

2. **Clique em "+ Capability"**

3. Uma lista aparecerá. Procure por:
   ```
   Sign in with Apple
   ```

4. **Clique em "Sign in with Apple"**

### Passo 5: Verificar se foi Adicionado

Após adicionar, você deve ver uma nova seção na tela:

```
┌─────────────────────────────────────┐
│  Sign in with Apple                 │
├─────────────────────────────────────┤
│  ✓ Enabled                          │
│                                     │
│  Modes                              │
│  • Default                          │
└─────────────────────────────────────┘
```

### Passo 6: Rebuild

1. **Product → Clean Build Folder** (ou `Shift + Cmd + K`)
2. **Product → Build** (ou `Cmd + B`)
3. **Rode o app novamente**

---

## ✅ Teste

Após seguir os passos:

1. Rode o app no simulador ou dispositivo
2. Toque em **"Continuar com Apple"**
3. Deve funcionar! 🎉

---

## ❓ Problemas Comuns

### "Não vejo o botão + Capability"

- Certifique-se de que está na aba **"Signing & Capabilities"** (não "Info")
- Certifique-se de que selecionou o **TARGET "Molho"** (não o PROJECT)

### "Não encontro Sign in with Apple na lista"

- Digite "apple" ou "sign" na busca que aparece
- Se ainda não aparecer, pode ser que seu Xcode esteja desatualizado

### "Aparece erro em vermelho depois de adicionar"

- Verifique se o **Team** está selecionado
- Verifique se **"Automatically manage signing"** está marcado
- Pode ser necessário fazer login com sua Apple ID no Xcode:
  **Xcode → Settings → Accounts**

### "Continua dando erro 1000"

1. Feche o Xcode completamente
2. Delete DerivedData:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. Reabra o projeto
4. Clean e Build novamente

---

## 📸 O que Você Deve Ver

### ANTES (SEM a capability):

```
Signing & Capabilities
┌─────────────────────────────────────┐
│  Signing                            │
│  ✓ Automatically manage signing     │
│  Team: Seu Time                     │
│  Bundle Identifier: molho.review... │
└─────────────────────────────────────┘

(Só isso, nenhuma capability adicional)
```

### DEPOIS (COM a capability):

```
Signing & Capabilities
┌─────────────────────────────────────┐
│  Signing                            │
│  ✓ Automatically manage signing     │
│  Team: Seu Time                     │
│  Bundle Identifier: molho.review... │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  Sign in with Apple                 │ ← DEVE APARECER!
│  ✓ Enabled                          │
└─────────────────────────────────────┘
```

---

## 🎯 Resumo

1. ✅ Abrir projeto no Xcode
2. ✅ Selecionar **TARGET** "Molho"
3. ✅ Aba **"Signing & Capabilities"**
4. ✅ Clicar em **"+ Capability"**
5. ✅ Adicionar **"Sign in with Apple"**
6. ✅ Clean e Build
7. ✅ Rodar novamente

---

## 📞 Se Precisar de Ajuda

Se após seguir todos os passos ainda não funcionar:

1. Verifique se você tem uma **conta de desenvolvedor Apple** válida
2. Verifique se o **Bundle ID** está correto: `molho.review.Molho`
3. Tente rodar em um **dispositivo físico** (não simulador)
4. Veja os logs no Console do Xcode (filtre por "🍎")

---

**Depois de adicionar a capability, tente novamente! Deve funcionar! 🚀**

