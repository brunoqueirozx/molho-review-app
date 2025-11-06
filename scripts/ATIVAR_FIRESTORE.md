# 🔥 Como Ativar o Firestore no Firebase

## Erro: "5 NOT_FOUND"

Este erro significa que o **Firestore Database não foi criado** no seu projeto Firebase.

## Passo a Passo para Ativar

### 1. Acesse o Firebase Console
https://console.firebase.google.com/project/molho-review-app

### 2. Vá para Firestore Database
- No menu lateral esquerdo, clique em **"Firestore Database"**
- Ou acesse diretamente: https://console.firebase.google.com/project/molho-review-app/firestore

### 3. Criar o Banco de Dados
1. Clique no botão **"Criar banco de dados"** ou **"Create database"**
2. Escolha o modo:
   - **Modo de produção** (recomendado para produção)
   - **Modo de teste** (para desenvolvimento - permite leitura/escrita por 30 dias)
3. Escolha a localização:
   - **us-central** (Iowa) - Recomendado
   - Ou outra região próxima ao Brasil (ex: **southamerica-east1** - São Paulo)
4. Clique em **"Ativar"** ou **"Enable"**

### 4. Configurar Regras de Segurança (Importante!)

Após criar o banco, você precisa configurar as regras:

1. Vá para a aba **"Regras"** ou **"Rules"**
2. Cole as regras do arquivo `firestore_rules.txt`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Coleção de merchants - leitura pública, escrita apenas para admins
    match /merchants/{merchantId} {
      allow read: if true; // Qualquer um pode ler
      allow write: if false; // Apenas via Admin SDK (scripts)
    }
  }
}
```

3. Clique em **"Publicar"** ou **"Publish"**

### 5. Verificar

Após ativar, você deve ver:
- Uma tela com o Firestore vazio
- Mensagem: "Cloud Firestore está pronto para uso"

## Depois de Ativar

Execute novamente o script:

```bash
cd /Users/brunoq./Desktop/Molho/Molho/scripts
node populate_firestore_complete.js
```

## Verificar se Funcionou

Acesse: https://console.firebase.google.com/project/molho-review-app/firestore

Você deve ver:
- ✅ Coleção `merchants` criada
- ✅ 12 documentos dentro da coleção
- ✅ Todos os campos preenchidos

## Troubleshooting

**"Firestore Database não aparece no menu"**
→ O projeto pode não ter sido criado corretamente. Verifique se está no projeto correto.

**"Erro ao criar banco de dados"**
→ Verifique se você tem permissões de administrador no projeto Firebase.

**"Regras não estão funcionando"**
→ Certifique-se de publicar as regras após editá-las.

---

## ⚡ Resumo Rápido

1. Acesse: https://console.firebase.google.com/project/molho-review-app/firestore
2. Clique em **"Criar banco de dados"**
3. Escolha **"Modo de teste"** (para desenvolvimento)
4. Escolha localização **"us-central"**
5. Configure as regras de segurança
6. Execute o script novamente

