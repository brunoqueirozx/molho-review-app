#!/bin/bash

# Script para ajudar a identificar arquivos que não deveriam estar no target
# Execute: bash limpar_target.sh

echo "🔍 Verificando arquivos que não deveriam estar no bundle do app iOS..."
echo ""

# Arquivos que não devem estar no bundle
PATTERNS=(
    "node_modules"
    "package.json"
    "package-lock.json"
    "*.md"
    "*.yml"
    "*.yaml"
    "*.js"
    "*.mjs"
    "*.wasm"
    ".eslintrc"
    ".gitignore"
    ".npmignore"
    "tsconfig.json"
    "LICENSE*"
    "CHANGELOG*"
    "README*"
)

echo "📋 Arquivos encontrados que NÃO devem estar no bundle:"
echo ""

for pattern in "${PATTERNS[@]}"; do
    find . -name "$pattern" -type f 2>/dev/null | while read -r file; do
        # Ignorar arquivos que devem estar no bundle
        if [[ "$file" != *"GoogleService-Info.plist"* ]] && \
           [[ "$file" != *"Assets.xcassets"* ]] && \
           [[ "$file" != *".swift"* ]]; then
            echo "  ❌ $file"
        fi
    done
done

echo ""
echo "✅ Verificação concluída!"
echo ""
echo "📝 Próximos passos:"
echo "   1. Abra o projeto no Xcode"
echo "   2. Siga as instruções em REMOVER_ARQUIVOS_DO_TARGET.md"
echo "   3. Remova esses arquivos do Target Membership"
echo "   4. Remova do Copy Bundle Resources"

