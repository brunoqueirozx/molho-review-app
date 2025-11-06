# Scripts do Projeto Molho

Esta pasta contém scripts para popular e gerenciar o Firebase Firestore.

## Localização

A pasta `scripts/` foi movida para fora do projeto iOS (`Molho/`) para evitar que arquivos de desenvolvimento sejam incluídos no bundle do app.

## Como Usar

### Popular Firestore

```bash
cd /Users/brunoq./Desktop/Molho/scripts
bash run.sh
```

Ou manualmente:

```bash
cd /Users/brunoq./Desktop/Molho/scripts
npm install firebase-admin
node populate_firestore_complete.js
```

## Arquivos

- `populate_firestore_complete.js` - Script principal para popular o Firestore
- `run.sh` - Script helper para executar o populate
- `serviceAccountKey.json` - Credenciais do Firebase (não commitado)
- `package.json` - Dependências Node.js
- `*.md` - Documentação

## Nota

Esta pasta não está mais dentro do projeto Xcode, então os arquivos não serão incluídos no bundle do app iOS.
