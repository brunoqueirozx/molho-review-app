# 🚀 Setup Firebase - Passo a Passo Simplificado

Siga exatamente estes passos para configurar o Firebase para o sistema de avaliações.

---

## 📋 PASSO 1: Acessar Firebase Console

1. Abra: https://console.firebase.google.com/
2. Selecione seu projeto **Molho**
3. No menu lateral, clique em **Firestore Database**

---

## 📋 PASSO 2: Criar a Coleção "reviews"

### Opção A: Criar Agora (Recomendado)

1. No Firestore Database, clique em **"Start collection"** ou **"Iniciar coleção"**
2. Digite o nome: `reviews`
3. Clique em **Next** ou **Próximo**
4. **ID do documento**: `teste_inicial`
5. Adicione estes campos:

```
Campo             Tipo        Valor
-----             ----        -----
id                string      teste_inicial
merchantId        string      merchant_teste
userId            string      user_teste
userName          string      Teste
rating            number      5
comment           string      Avaliação de teste
createdAt         timestamp   (clique no ícone do relógio)
updatedAt         timestamp   (clique no ícone do relógio)
```

6. Clique em **Save** ou **Salvar**
7. ✅ Pronto! A coleção foi criada

### Opção B: Será Criada Automaticamente

Se preferir, a coleção será criada automaticamente quando você adicionar a primeira avaliação pelo app. Mas é melhor criar agora para configurar os índices.

---

## 📋 PASSO 3: Configurar Regras de Segurança

1. No Firestore Database, clique na aba **Rules** ou **Regras**
2. **APAGUE TODO O CONTEÚDO** atual
3. Abra o arquivo **`firebase-rules.txt`** (está na mesma pasta deste arquivo)
4. **COPIE TODO O CONTEÚDO** do arquivo `firebase-rules.txt`
5. **COLE** no editor de regras do Firebase
6. Clique em **Publish** ou **Publicar**
7. ✅ Pronto! Regras configuradas

**⚠️ Importante:** Se aparecer erro, certifique-se de que apagou TODO o conteúdo anterior antes de colar.

---

## 📋 PASSO 4: Criar Índices Compostos

Você precisa criar 3 índices. Siga para cada um:

### ÍNDICE 1: Reviews por Estabelecimento (ordenado por data)

1. No Firestore Database, clique na aba **Indexes** ou **Índices**
2. Clique em **Create Index** ou **Criar Índice**
3. Configure assim:

```
Collection ID:     reviews
Field 1:          merchantId    →  Ascending
Field 2:          createdAt     →  Descending
Query scope:      Collection
```

4. Clique em **Create Index** ou **Criar Índice**
5. Aguarde aparecer o status **"Enabled"** ou **"Ativado"** (pode levar 1-2 minutos)

---

### ÍNDICE 2: Reviews por Usuário (ordenado por data)

1. Clique em **Create Index** ou **Criar Índice** novamente
2. Configure assim:

```
Collection ID:     reviews
Field 1:          userId        →  Ascending
Field 2:          createdAt     →  Descending
Query scope:      Collection
```

3. Clique em **Create Index** ou **Criar Índice**
4. Aguarde aparecer o status **"Enabled"** ou **"Ativado"**

---

### ÍNDICE 3: Review Específica (Usuário + Estabelecimento)

1. Clique em **Create Index** ou **Criar Índice** novamente
2. Configure assim:

```
Collection ID:     reviews
Field 1:          userId        →  Ascending
Field 2:          merchantId    →  Ascending
Query scope:      Collection
```

3. Clique em **Create Index** ou **Criar Índice**
4. Aguarde aparecer o status **"Enabled"** ou **"Ativado"**

---

## 📋 PASSO 5: Verificar Configuração

### Checklist Final:

- [ ] Coleção `reviews` existe
- [ ] Regras de segurança estão publicadas
- [ ] 3 índices criados e com status "Enabled"
- [ ] Documento de teste pode ser visto na coleção

### Teste Rápido no Console:

1. Vá para a coleção `reviews`
2. Tente adicionar um documento manualmente
3. Se conseguir, está tudo certo! ✅

---

## 📋 PASSO 6: Testar no App

Agora você pode:

1. **Compilar o app** (Cmd+B)
2. **Executar no simulador**
3. **Abrir um estabelecimento**
4. **Clicar na estrela ⭐**
5. **Adicionar uma avaliação**

Se tudo funcionar, você verá:
- ✅ Mensagem de sucesso
- ✅ Avaliação aparece no Firebase Console
- ✅ Métricas do estabelecimento atualizadas

---

## 🐛 Problemas Comuns

### Erro: "Missing or insufficient permissions"

**Causa:** Regras de segurança não foram aplicadas corretamente.

**Solução:**
1. Volte para Rules no Firebase
2. Confira se as regras foram publicadas
3. Certifique-se de que está autenticado no app

---

### Erro: "Index not found" ou "Índice não encontrado"

**Causa:** Os índices ainda não foram criados ou não estão habilitados.

**Solução:**
1. Vá para a aba Indexes
2. Verifique se os 3 índices existem
3. Aguarde todos ficarem com status "Enabled"
4. Se algum falhou, delete e crie novamente

**💡 Dica:** O próprio erro do Firebase geralmente fornece um link direto para criar o índice necessário!

---

### Erro: "Failed to create review"

**Causa:** Usuário não está autenticado ou dados inválidos.

**Solução:**
1. Certifique-se de estar logado no app
2. Verifique se selecionou as estrelas (rating)
3. Confira os logs do Xcode para mais detalhes

---

## 📊 Visualizar Dados no Firebase

Para ver suas avaliações:

1. Acesse **Firestore Database**
2. Clique na coleção **reviews**
3. Você verá todas as avaliações em tempo real!

Você pode:
- 📝 Editar manualmente
- 🗑️ Deletar avaliações
- 📊 Ver estatísticas
- 🔍 Fazer queries

---

## 🎉 Pronto!

Se seguiu todos os passos, seu sistema de avaliações está **100% configurado**!

**Próximos passos:**
- [ ] Teste adicionar uma avaliação
- [ ] Teste editar uma avaliação
- [ ] Teste deletar uma avaliação
- [ ] Teste ver lista de avaliações
- [ ] Compartilhe com amigos para testarem! 🚀

---

## 📞 Ajuda Extra

Se precisar de ajuda:
1. Confira os logs do Xcode (ícone 🐛)
2. Veja o console do Firebase (aba Logs)
3. Confira a documentação: `README.md`, `ARQUITETURA.md`

---

**Tempo estimado:** 10-15 minutos  
**Dificuldade:** ⭐⭐☆☆☆ (Fácil)  
**Status:** Pronto para começar! 🚀

