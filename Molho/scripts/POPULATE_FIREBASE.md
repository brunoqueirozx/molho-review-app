# Como Popular o Firestore com Dados

Este guia explica como enviar os dados de exemplo para o Firebase Firestore.

## Método 1: Script Node.js (Recomendado)

### Passo 1: Instalar Node.js e dependências

```bash
# Verificar se Node.js está instalado
node --version

# Se não tiver, instale via Homebrew:
brew install node

# Navegar até a pasta scripts
cd scripts

# Instalar Firebase Admin SDK
npm install firebase-admin
```

### Passo 2: Baixar Service Account Key

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Selecione seu projeto
3. Vá em **Project Settings** (ícone de engrenagem)
4. Aba **Service Accounts**
5. Clique em **Generate New Private Key**
6. Baixe o arquivo JSON
7. Renomeie para `serviceAccountKey.json`
8. Coloque o arquivo em `scripts/serviceAccountKey.json`

⚠️ **IMPORTANTE**: Adicione `serviceAccountKey.json` ao `.gitignore` para não commitar credenciais!

### Passo 3: Executar o Script

```bash
cd scripts
node populate_firestore_complete.js
```

### Passo 4: Verificar no Firebase Console

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Vá em **Firestore Database**
3. Verifique se a coleção `merchants` foi criada
4. Verifique se há 12 documentos

## Método 2: Via Firebase Console (Manual)

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Vá em **Firestore Database**
3. Clique em **Start collection**
4. Collection ID: `merchants`
5. Adicione documentos manualmente usando a estrutura em `FIREBASE_SETUP.md`

## Método 3: Via App iOS (Futuro)

Quando o Firebase estiver configurado no app, você pode criar uma função de admin para popular os dados diretamente do app.

## Troubleshooting

### Erro: "serviceAccountKey.json não encontrado"
- Verifique se o arquivo está em `scripts/serviceAccountKey.json`
- Verifique se o nome do arquivo está correto

### Erro: "Permission denied"
- Verifique as regras do Firestore
- Certifique-se de que as regras permitem escrita (veja `scripts/firestore_rules.txt`)

### Erro: "Module not found: firebase-admin"
- Execute `npm install firebase-admin` na pasta `scripts`

## Estrutura dos Dados

Cada documento na coleção `merchants` terá:
- Todos os campos do modelo `Merchant`
- Timestamps automáticos (`createdAt`, `updatedAt`)
- Horários de funcionamento estruturados
- Arrays de categorias

Veja `FIREBASE_SETUP.md` para detalhes completos da estrutura.

