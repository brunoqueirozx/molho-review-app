# 🎯 COMECE AQUI - Setup em 15 Minutos

## ✅ CHECKLIST RÁPIDO

Siga esta ordem. Marque cada item quando terminar.

---

### ☑️ ETAPA 1: Acessar Firebase (1 minuto)

1. [ ] Abrir: https://console.firebase.google.com/
2. [ ] Clicar no projeto **Molho**
3. [ ] Clicar em **Firestore Database** (menu lateral)

---

### ☑️ ETAPA 2: Criar Coleção (2 minutos)

1. [ ] Clicar em **"Start collection"** ou **"Iniciar coleção"**
2. [ ] Digitar: `reviews`
3. [ ] Clicar em **Next**
4. [ ] ID do documento: `teste`
5. [ ] Adicionar campos (veja tabela abaixo)
6. [ ] Clicar em **Save**

**Campos para adicionar:**
```
id          → string     → teste
merchantId  → string     → test123
userId      → string     → user123
userName    → string     → Teste
rating      → number     → 5
createdAt   → timestamp  → (clique no relógio)
updatedAt   → timestamp  → (clique no relógio)
```

---

### ☑️ ETAPA 3: Configurar Regras (3 minutos)

1. [ ] Clicar na aba **Rules**
2. [ ] **APAGAR TUDO** que está lá
3. [ ] Abrir o arquivo **`firebase-rules.txt`** (mesma pasta)
4. [ ] **COPIAR TODO** o conteúdo
5. [ ] **COLAR** no Firebase
6. [ ] Clicar em **Publish**

---

### ☑️ ETAPA 4: Criar Índices (9 minutos)

1. [ ] Clicar na aba **Indexes**
2. [ ] Clicar em **Create Index**

**ÍNDICE 1:**
```
Collection: reviews
Campo 1:    merchantId   → Ascending
Campo 2:    createdAt    → Descending
Scope:      Collection
```
3. [ ] Clicar em **Create**
4. [ ] Aguardar status **"Enabled"**

**ÍNDICE 2:**
```
Collection: reviews
Campo 1:    userId       → Ascending
Campo 2:    createdAt    → Descending
Scope:      Collection
```
5. [ ] Clicar em **Create Index** novamente
6. [ ] Clicar em **Create**
7. [ ] Aguardar status **"Enabled"**

**ÍNDICE 3:**
```
Collection: reviews
Campo 1:    userId       → Ascending
Campo 2:    merchantId   → Ascending
Scope:      Collection
```
8. [ ] Clicar em **Create Index** novamente
9. [ ] Clicar em **Create**
10. [ ] Aguardar status **"Enabled"**

---

### ☑️ ETAPA 5: Verificar (2 minutos)

Confira se tudo está certo:

1. [ ] Coleção `reviews` existe
2. [ ] Tem um documento de teste
3. [ ] Regras estão publicadas
4. [ ] 3 índices com status "Enabled" (🟢)

---

### ☑️ ETAPA 6: Testar no App

1. [ ] Abrir Xcode
2. [ ] Compilar (Cmd+B)
3. [ ] Executar no simulador
4. [ ] Abrir um estabelecimento
5. [ ] Clicar na ⭐
6. [ ] Adicionar avaliação
7. [ ] Ver se funcionou! 🎉

---

## 🎉 PRONTO!

Se marcou tudo, está funcionando! ✅

---

## 📁 Arquivos de Ajuda

Use estes arquivos se precisar de mais detalhes:

- **`SETUP_PASSO_A_PASSO.md`** - Instruções detalhadas com screenshots mentais
- **`INDICES_FIREBASE.md`** - Configuração visual dos índices
- **`firebase-rules.txt`** - Regras prontas para copiar
- **`FIREBASE_SETUP.md`** - Documentação completa (original)

---

## ⏱️ Tempo Total: 15 minutos

- Etapa 1: 1 min
- Etapa 2: 2 min
- Etapa 3: 3 min
- Etapa 4: 9 min
- Etapa 5: 2 min
- Etapa 6: Testar!

---

## 🆘 Problemas?

### "Não consigo criar a coleção"
→ Certifique-se de estar na aba **Data**, não em Rules ou Indexes

### "Erro ao publicar regras"
→ Apague TODO o conteúdo anterior antes de colar o novo

### "Índice não aparece"
→ Aguarde 1-2 minutos, o Firebase precisa processar

### "App dá erro ao avaliar"
→ Confira se os 3 índices estão com status "Enabled"

---

## ✨ Está Pronto?

Execute o app e teste:

1. 🏪 Abra um estabelecimento
2. ⭐ Clique na estrela
3. 📝 Adicione uma avaliação
4. ✅ Deve funcionar!

Se funcionou, **parabéns!** 🎊

Seu sistema de avaliações está **100% configurado** e pronto para uso!

---

**Última atualização:** 12 de Novembro de 2025  
**Dificuldade:** ⭐⭐☆☆☆ Fácil  
**Tempo:** 15 minutos  
**Status:** Pronto para começar! 🚀

