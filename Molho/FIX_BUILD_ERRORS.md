# 🔧 Como Corrigir Erros de Build "Multiple commands produce"

## Problema

O erro ocorre porque a pasta `scripts/node_modules` (com milhares de arquivos JavaScript) está sendo copiada para o bundle do app iOS, o que não deveria acontecer.

## Solução Rápida

### Passo 1: Excluir node_modules do Git

A pasta `node_modules` já está no `.gitignore`, mas se ela já foi commitada, remova:

```bash
cd /Users/brunoq./Desktop/Molho/Molho
git rm -r --cached scripts/node_modules
git commit -m "chore: remover node_modules do controle de versão"
```

### Passo 2: Excluir do Target no Xcode

1. **Abra o projeto no Xcode**
2. **No Project Navigator** (painel esquerdo), encontre a pasta `scripts/node_modules`
3. **Selecione a pasta `node_modules`**
4. **No File Inspector** (painel direito), desmarque **"Target Membership"** para o target "Molho"
5. **Repita para qualquer outro arquivo de desenvolvimento**:
   - `package.json`
   - `package-lock.json`
   - `*.md` (arquivos markdown)
   - `*.yml` (arquivos YAML)
   - `*.json` (exceto `GoogleService-Info.plist`)

### Passo 3: Verificar Build Phases

1. **Selecione o projeto "Molho"** no Project Navigator
2. **Selecione o target "Molho"**
3. **Vá para a aba "Build Phases"**
4. **Expanda "Copy Bundle Resources"**
5. **Remova qualquer entrada que aponte para**:
   - `scripts/node_modules`
   - `scripts/package.json`
   - `scripts/package-lock.json`
   - Qualquer arquivo `.md`, `.yml`, `.json` (exceto `GoogleService-Info.plist`)

### Passo 4: Limpar Build

1. **No Xcode**, pressione **Shift + Cmd + K** (Clean Build Folder)
2. **Tente fazer build novamente** (Cmd + B)

## Solução Alternativa: Mover scripts para fora do projeto

Se o problema persistir, você pode mover a pasta `scripts` para fora do projeto iOS:

```bash
cd /Users/brunoq./Desktop/Molho
mv Molho/scripts .
```

Depois, atualize os caminhos nos scripts se necessário.

## Verificação

Após aplicar as correções, o build deve:
- ✅ Compilar sem erros "Multiple commands produce"
- ✅ Não incluir `node_modules` no bundle
- ✅ Não incluir arquivos de desenvolvimento no bundle

## Arquivos que NÃO devem estar no Bundle

- `node_modules/` (qualquer pasta)
- `package.json`, `package-lock.json`
- `*.md` (README, CHANGELOG, etc.)
- `*.yml`, `*.yaml` (configurações)
- `.eslintrc`, `.npmignore`, `.jshintrc`
- `tsconfig.json`, `tsdoc-metadata.json`
- `test.js`, `tests.js`
- `LICENSE`, `LICENSE.md`, `LICENSE.txt`

## Arquivos que DEVEM estar no Bundle

- `GoogleService-Info.plist` (Firebase)
- `Assets.xcassets/` (imagens e assets)
- Arquivos `.swift` do app
- Outros recursos necessários em runtime

