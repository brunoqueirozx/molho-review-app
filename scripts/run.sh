#!/bin/bash

# Script helper para executar o populate do Firestore
# Execute: bash run.sh

echo "🚀 Verificando dependências..."

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js não está instalado!"
    echo ""
    echo "📥 Instale Node.js:"
    echo "   1. Acesse: https://nodejs.org/"
    echo "   2. Baixe a versão LTS"
    echo "   3. Instale o arquivo .pkg"
    echo "   4. Reinicie o Terminal"
    echo ""
    echo "   Ou instale via Homebrew:"
    echo "   brew install node"
    exit 1
fi

echo "✅ Node.js encontrado: $(node --version)"
echo "✅ npm encontrado: $(npm --version)"

# Verificar serviceAccountKey.json
if [ ! -f "serviceAccountKey.json" ]; then
    echo "❌ serviceAccountKey.json não encontrado!"
    echo "   Baixe do Firebase Console e coloque nesta pasta."
    exit 1
fi

echo "✅ serviceAccountKey.json encontrado"
echo ""

# Instalar dependências
echo "📦 Instalando firebase-admin..."
npm install firebase-admin

if [ $? -ne 0 ]; then
    echo "❌ Erro ao instalar dependências"
    exit 1
fi

echo ""
echo "📤 Executando script para popular Firestore..."
echo ""

# Executar script
node populate_firestore_complete.js

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Sucesso! Verifique no Firebase Console:"
    echo "   https://console.firebase.google.com/project/molho-review-app/firestore"
else
    echo ""
    echo "❌ Erro ao executar o script"
    exit 1
fi

