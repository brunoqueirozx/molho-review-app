# 🚀 Como Executar o Script para Popular Firebase

## Status Atual
✅ `serviceAccountKey.json` encontrado na pasta `scripts/`
❌ Node.js não está instalado

## Passos para Executar

### 1. Instalar Node.js

**Opção A - Download Direto (Mais Rápido):**
1. Acesse: https://nodejs.org/
2. Baixe a versão **LTS** (recomendada)
3. Instale o arquivo `.pkg` baixado
4. Reinicie o Terminal

**Opção B - Via Homebrew:**
```bash
# Instalar Homebrew (se não tiver)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar Node.js
brew install node
```

### 2. Verificar Instalação
```bash
node --version
npm --version
```

### 3. Executar o Script
```bash
cd /Users/brunoq./Desktop/Molho/Molho/scripts
npm install firebase-admin
node populate_firestore_complete.js
```

## O que o Script Faz

- Cria a coleção `merchants` no Firestore
- Adiciona 12 estabelecimentos de exemplo
- Inclui todos os campos: nome, categorias, avaliações, horários, etc.

## Verificar Resultado

Após executar, acesse:
https://console.firebase.google.com/ → Firestore Database

Você deve ver a coleção `merchants` com 12 documentos! 🎉

