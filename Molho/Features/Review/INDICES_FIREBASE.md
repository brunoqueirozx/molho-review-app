# 📊 Índices do Firebase - Configuração Visual

## 🎯 Você precisa criar 3 índices

Copie e use os dados abaixo exatamente como estão.

---

## ÍNDICE 1: Buscar reviews por estabelecimento

**Use quando:** Listar todas as avaliações de um restaurante

### Configuração:
```
┌─────────────────────────────────────────┐
│ Collection ID:    reviews               │
├─────────────────────────────────────────┤
│ Fields indexed:                         │
│   merchantId     ▼ Ascending            │
│   createdAt      ▼ Descending           │
├─────────────────────────────────────────┤
│ Query scope:     ● Collection           │
│                  ○ Collection group     │
└─────────────────────────────────────────┘
```

### Copie e Cole (se houver opção de JSON):
```json
{
  "collectionGroup": "reviews",
  "queryScope": "COLLECTION",
  "fields": [
    {
      "fieldPath": "merchantId",
      "order": "ASCENDING"
    },
    {
      "fieldPath": "createdAt",
      "order": "DESCENDING"
    }
  ]
}
```

---

## ÍNDICE 2: Buscar reviews por usuário

**Use quando:** Ver todas as avaliações que um usuário fez

### Configuração:
```
┌─────────────────────────────────────────┐
│ Collection ID:    reviews               │
├─────────────────────────────────────────┤
│ Fields indexed:                         │
│   userId         ▼ Ascending            │
│   createdAt      ▼ Descending           │
├─────────────────────────────────────────┤
│ Query scope:     ● Collection           │
│                  ○ Collection group     │
└─────────────────────────────────────────┘
```

### Copie e Cole (se houver opção de JSON):
```json
{
  "collectionGroup": "reviews",
  "queryScope": "COLLECTION",
  "fields": [
    {
      "fieldPath": "userId",
      "order": "ASCENDING"
    },
    {
      "fieldPath": "createdAt",
      "order": "DESCENDING"
    }
  ]
}
```

---

## ÍNDICE 3: Buscar review específica

**Use quando:** Verificar se usuário já avaliou um estabelecimento

### Configuração:
```
┌─────────────────────────────────────────┐
│ Collection ID:    reviews               │
├─────────────────────────────────────────┤
│ Fields indexed:                         │
│   userId         ▼ Ascending            │
│   merchantId     ▼ Ascending            │
├─────────────────────────────────────────┤
│ Query scope:     ● Collection           │
│                  ○ Collection group     │
└─────────────────────────────────────────┘
```

### Copie e Cole (se houver opção de JSON):
```json
{
  "collectionGroup": "reviews",
  "queryScope": "COLLECTION",
  "fields": [
    {
      "fieldPath": "userId",
      "order": "ASCENDING"
    },
    {
      "fieldPath": "merchantId",
      "order": "ASCENDING"
    }
  ]
}
```

---

## 🎬 GIF Mental do Processo

```
1. Firebase Console
   ↓
2. Firestore Database
   ↓
3. Aba "Indexes"
   ↓
4. Botão "Create Index"
   ↓
5. Preencher campos (veja acima)
   ↓
6. Clicar "Create"
   ↓
7. Aguardar "Enabled" (1-2 min)
   ↓
8. Repetir para os outros 2 índices
   ↓
9. ✅ Pronto!
```

---

## 📸 Como Deve Ficar

Quando terminar, na aba **Indexes**, você deve ver:

```
┌────────────────────────────────────────────────────────────┐
│ Composite Indexes                                          │
├────────────────────────────────────────────────────────────┤
│ Collection  │ Fields                      │ Status        │
├─────────────┼─────────────────────────────┼───────────────┤
│ reviews     │ merchantId ↑, createdAt ↓   │ 🟢 Enabled   │
│ reviews     │ userId ↑, createdAt ↓       │ 🟢 Enabled   │
│ reviews     │ userId ↑, merchantId ↑      │ 🟢 Enabled   │
└────────────────────────────────────────────────────────────┘
```

---

## ⏱️ Tempo de Criação

- Cada índice leva: **1-2 minutos**
- Total: **5-10 minutos**

Enquanto espera, você pode:
- ☕ Tomar um café
- 📖 Ler a documentação
- 🎵 Ouvir uma música
- ✨ Planejar o que vai fazer com o app!

---

## 🚨 Se Aparecer Erro

### "Index already exists"
✅ Ótimo! Alguém já criou. Pule para o próximo.

### "Invalid field path"
❌ Você digitou o nome errado. Confira:
- `merchantId` (não merchantID)
- `userId` (não userID)
- `createdAt` (não created_at)

### "Creation failed"
❌ Tente novamente. Se persistir:
1. Delete o índice
2. Aguarde 1 minuto
3. Crie novamente

---

## 💡 Dica Pro

O Firebase às vezes cria índices automaticamente quando você tenta fazer uma query que precisa deles. Se aparecer um erro dizendo "The query requires an index", ele vai te dar um **link direto** para criar o índice necessário. É só clicar! 🎯

---

## ✅ Checklist

Use isto para garantir que criou tudo:

- [ ] Índice 1: merchantId + createdAt
- [ ] Índice 2: userId + createdAt
- [ ] Índice 3: userId + merchantId
- [ ] Todos com status "Enabled"
- [ ] Collection scope (não collection group)

---

## 🎉 Quando Terminar

Seus índices estarão otimizados e as queries serão **ultra rápidas**! ⚡

O app vai poder:
- 🚀 Carregar avaliações instantaneamente
- 📱 Funcionar suavemente mesmo com milhares de reviews
- 💪 Escalar sem problemas de performance

---

**Pronto para criar?** Vá para o Firebase Console agora! 🔥

