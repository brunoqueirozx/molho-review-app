# 🚀 Guia Rápido: Popular Firebase

## Passo a Passo Simplificado

### 1️⃣ Baixar Service Account Key

1. Acesse: https://console.firebase.google.com/
2. Selecione seu projeto (ou crie um novo)
3. Clique no ⚙️ **Project Settings**
4. Aba **Service Accounts**
5. Clique em **Generate New Private Key**
6. Baixe o arquivo JSON
7. **Renomeie** para `serviceAccountKey.json`
8. **Mova** para a pasta `scripts/`

### 2️⃣ Instalar Node.js (se não tiver)

```bash
# Verificar se já tem
node --version

# Se não tiver, instalar:
brew install node
```

### 3️⃣ Instalar Dependências

```bash
cd scripts
npm install firebase-admin
```

### 4️⃣ Executar Script

```bash
node populate_firestore_complete.js
```

### 5️⃣ Verificar

Acesse: https://console.firebase.google.com/ → Firestore Database

Você deve ver a coleção `merchants` com 12 documentos! 🎉

---

## ⚠️ Problemas Comuns

**"serviceAccountKey.json não encontrado"**
→ Verifique se o arquivo está em `scripts/serviceAccountKey.json`

**"npm: command not found"**
→ Instale Node.js: `brew install node`

**"Permission denied"**
→ Configure as regras do Firestore (veja `firestore_rules.txt`)

---

## 📝 Nota

O arquivo `serviceAccountKey.json` contém credenciais sensíveis e está no `.gitignore` para não ser commitado.

