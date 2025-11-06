# 🚀 Como Executar o Script para Popular Firebase

## Situação Atual
✅ `serviceAccountKey.json` está configurado e válido
❌ Node.js precisa ser instalado

## Passo 1: Instalar Node.js

### Opção A - Download Direto (Mais Rápido - ~5 minutos)

1. **Acesse:** https://nodejs.org/
2. **Baixe** a versão **LTS** (Long Term Support) - botão verde
3. **Instale** o arquivo `.pkg` baixado (duplo clique)
4. **Siga** o assistente de instalação
5. **Reinicie** o Terminal

### Opção B - Via Homebrew

```bash
# Se não tiver Homebrew, instale primeiro:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Depois instale Node.js:
brew install node
```

## Passo 2: Verificar Instalação

Abra um novo Terminal e execute:

```bash
node --version   # Deve mostrar: v20.x.x ou similar
npm --version    # Deve mostrar: 10.x.x ou similar
```

## Passo 3: Executar o Script

### Método Simples (usando o script helper):

```bash
cd /Users/brunoq./Desktop/Molho/Molho/scripts
bash run.sh
```

### Método Manual:

```bash
cd /Users/brunoq./Desktop/Molho/Molho/scripts
npm install firebase-admin
node populate_firestore_complete.js
```

## O que Acontece

O script vai:
1. ✅ Verificar se tudo está configurado
2. 📦 Instalar dependências (se necessário)
3. 📤 Enviar 12 merchants para o Firestore
4. ✅ Confirmar sucesso

## Verificar Resultado

Após executar com sucesso, acesse:

**Firebase Console:** https://console.firebase.google.com/project/molho-review-app/firestore

Você deve ver:
- Coleção `merchants` criada
- 12 documentos dentro da coleção
- Todos os campos preenchidos

## Troubleshooting

**"node: command not found"**
→ Node.js não está instalado. Instale seguindo o Passo 1.

**"npm: command not found"**
→ Node.js não está instalado corretamente. Reinstale.

**"serviceAccountKey.json não encontrado"**
→ O arquivo já está na pasta `scripts/`. Verifique o caminho.

**"Permission denied"**
→ Configure as regras do Firestore (veja `firestore_rules.txt`)

---

## ⚡ Resumo Rápido

1. Instale Node.js: https://nodejs.org/ (versão LTS)
2. Execute: `cd scripts && bash run.sh`
3. Pronto! 🎉

