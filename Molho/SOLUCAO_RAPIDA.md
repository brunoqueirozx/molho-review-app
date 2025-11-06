# ⚡ Solução Rápida para Erros de Build

## 🎯 Solução Recomendada: Mover Scripts Para Fora do Projeto

A pasta `scripts/` não precisa estar dentro do projeto iOS. Vamos movê-la para fora:

### Passo 1: Mover a pasta scripts

```bash
cd /Users/brunoq./Desktop/Molho
mv Molho/scripts .
```

### Passo 2: Atualizar referências (se necessário)

Os scripts continuarão funcionando normalmente, apenas em um local diferente:

```bash
# Antes:
cd /Users/brunoq./Desktop/Molho/Molho/scripts
node populate_firestore_complete.js

# Depois:
cd /Users/brunoq./Desktop/Molho/scripts
node populate_firestore_complete.js
```

### Passo 3: Limpar Build no Xcode

1. **No Xcode**: **Product → Clean Build Folder** (`Shift+Cmd+K`)
2. **Feche e reabra o Xcode**
3. **Tente fazer build novamente**: **Product → Build** (`Cmd+B`)

## ✅ Resultado Esperado

- ✅ Build deve compilar sem erros
- ✅ `scripts/` não estará mais no projeto iOS
- ✅ Scripts continuam funcionando normalmente
- ✅ Nenhum arquivo de desenvolvimento no bundle

## 🔄 Se Precisar Voltar

Se precisar mover de volta:

```bash
cd /Users/brunoq./Desktop/Molho
mv scripts Molho/
```

---

## 📋 Alternativa: Remover Manualmente do Target

Se preferir manter `scripts/` dentro do projeto, siga as instruções em `REMOVER_ARQUIVOS_DO_TARGET.md`.

