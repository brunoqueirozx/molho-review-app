# Scripts para Popular Firebase

Esta pasta contém scripts para popular o Firestore com dados de exemplo.

## 📋 Arquivos

- `populate_firestore_complete.js` - Script Node.js completo com todos os 12 merchants
- `firestore_rules.txt` - Regras de segurança do Firestore
- `QUICK_START.md` - Guia rápido passo a passo
- `POPULATE_FIREBASE.md` - Guia detalhado
- `PopulateFirestore.swift` - Função Swift alternativa (para usar no app)

## 🚀 Método Recomendado: Node.js

### Pré-requisitos
1. Node.js instalado (`brew install node`)
2. Service Account Key do Firebase

### Passos
1. Baixe o `serviceAccountKey.json` do Firebase Console
2. Coloque em `scripts/serviceAccountKey.json`
3. Execute:
```bash
cd scripts
npm install firebase-admin
node populate_firestore_complete.js
```

Veja `QUICK_START.md` para instruções detalhadas.

## 🔐 Segurança

⚠️ **IMPORTANTE**: O arquivo `serviceAccountKey.json` está no `.gitignore` e **NÃO** deve ser commitado no Git!

## 📚 Documentação

- `FIREBASE_SETUP.md` - Estrutura completa dos dados
- `FIREBASE_MIGRATION.md` - Como migrar do stub para Firebase

