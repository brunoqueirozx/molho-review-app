# 🚨 Como Remover Arquivos do Target e Resolver Erros de Build

## Problema
Arquivos de desenvolvimento (`.js`, `.json`, `.md`, `.yml`, etc.) estão sendo incluídos no bundle do app, causando erros "Multiple commands produce".

## Solução Passo a Passo

### Passo 1: Abrir o Projeto no Xcode

1. Abra `Molho.xcodeproj` no Xcode

### Passo 2: Remover do Target Membership

1. **No Project Navigator** (barra lateral esquerda), encontre e selecione:
   - `scripts/node_modules/` (pasta inteira)
   - `scripts/package.json`
   - `scripts/package-lock.json`
   - Qualquer arquivo `.md`, `.yml`, `.json` (exceto `GoogleService-Info.plist`)

2. **Para cada arquivo/pasta selecionado**:
   - Clique com botão direito → **"Get Info"** (ou selecione e pressione `Cmd+I`)
   - No painel direito, encontre **"Target Membership"**
   - **DESMARQUE** o checkbox do target "Molho"
   - Clique em **"Done"**

### Passo 3: Verificar Build Phases

1. **Selecione o projeto "Molho"** no Project Navigator (ícone azul no topo)
2. **Selecione o target "Molho"** (não o projeto, mas o target)
3. **Vá para a aba "Build Phases"**
4. **Expanda "Copy Bundle Resources"**
5. **Procure e REMOVA** (selecione e pressione Delete) qualquer entrada relacionada a:
   - `scripts/node_modules`
   - `scripts/package.json`
   - `scripts/package-lock.json`
   - Arquivos `.md` (README, CHANGELOG, etc.)
   - Arquivos `.yml`, `.yaml`
   - Arquivos `.js`, `.mjs` (exceto se forem necessários para o app)
   - Arquivos `.json` (exceto `GoogleService-Info.plist`)
   - Arquivos `.wasm`
   - Arquivos `.eslintrc`, `.gitignore`, `.npmignore`
   - Arquivos `tsconfig.json`
   - Qualquer arquivo de configuração ou desenvolvimento

### Passo 4: Verificar Folder References (Pastas Azuis)

1. **No Project Navigator**, procure por pastas que aparecem em **azul** (folder references)
2. **Se encontrar pastas azuis** como:
   - `scripts/`
   - `node_modules/`
   - Qualquer pasta que contenha arquivos de desenvolvimento
3. **Selecione a pasta azul** → Botão direito → **"Delete"** → Escolha **"Remove Reference"** (não "Move to Trash")

### Passo 5: Verificar Run Script Phases

1. **Ainda na aba "Build Phases"**
2. **Procure por "Run Script" phases**
3. **Se houver scripts que copiam arquivos**, verifique se estão copiando:
   - `node_modules/`
   - Arquivos de desenvolvimento
4. **Se necessário, ajuste o script** para excluir esses arquivos:

```bash
# Exemplo de script seguro
rsync -av \
  --exclude='node_modules' \
  --exclude='.*' \
  --exclude='*.md' \
  --exclude='*.yml' \
  --exclude='*.json' \
  --exclude='package.json' \
  --exclude='package-lock.json' \
  "${SRCROOT}/scripts/dist/" \
  "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/scripts/"
```

### Passo 6: Limpar Build

1. **No Xcode**: **Product → Clean Build Folder** (ou `Shift+Cmd+K`)
2. **Feche o Xcode completamente**
3. **Reabra o projeto**
4. **Tente fazer build novamente**: **Product → Build** (ou `Cmd+B`)

## Arquivos que NÃO devem estar no Bundle

- ❌ `node_modules/` (qualquer pasta)
- ❌ `package.json`, `package-lock.json`
- ❌ `*.md` (README, CHANGELOG, LICENSE, etc.)
- ❌ `*.yml`, `*.yaml` (configurações)
- ❌ `*.js`, `*.mjs` (exceto bundles necessários)
- ❌ `*.wasm` (exceto se necessário)
- ❌ `.eslintrc`, `.gitignore`, `.npmignore`
- ❌ `tsconfig.json`, `tsdoc-metadata.json`
- ❌ `test.js`, `tests.js`
- ❌ `LICENSE`, `LICENSE.md`, `LICENSE.txt`

## Arquivos que DEVEM estar no Bundle

- ✅ `GoogleService-Info.plist` (Firebase)
- ✅ `Assets.xcassets/` (imagens e assets)
- ✅ Arquivos `.swift` do app
- ✅ Outros recursos necessários em runtime

## Verificação Final

Após seguir todos os passos:
- ✅ Build deve compilar sem erros "Multiple commands produce"
- ✅ Bundle não deve conter `node_modules`
- ✅ Bundle não deve conter arquivos de desenvolvimento
- ✅ Apenas recursos necessários em runtime devem estar no bundle

## Se o Problema Persistir

Se ainda houver erros após seguir todos os passos:

1. **Delete DerivedData**:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/Molho-*
   ```

2. **Verifique se há múltiplos targets** copiando os mesmos arquivos

3. **Considere mover a pasta `scripts` para fora do projeto**:
   ```bash
   cd /Users/brunoq./Desktop/Molho
   mv Molho/scripts .
   ```

