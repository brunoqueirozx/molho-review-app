# 🚨 Instruções para Corrigir Erro de Build

## Problema Identificado

A pasta `scripts/node_modules` está sendo incluída no bundle do app iOS, causando o erro "Multiple commands produce".

## Solução Passo a Passo

### 1. No Xcode - Excluir do Target

1. **Abra o projeto no Xcode**
2. **No Project Navigator** (barra lateral esquerda), encontre:
   - `scripts/node_modules/` (pasta inteira)
   - `scripts/package.json`
   - `scripts/package-lock.json`
3. **Para cada um desses itens**:
   - Clique com botão direito → **"Get Info"** (ou selecione e pressione Cmd+I)
   - No painel direito, encontre **"Target Membership"**
   - **DESMARQUE** o checkbox do target "Molho"
4. **Repita para arquivos de documentação** (se estiverem marcados):
   - `scripts/*.md`
   - `README.md`
   - `FIREBASE_SETUP.md`
   - etc.

### 2. Verificar Build Phases

1. **Selecione o projeto "Molho"** no Project Navigator
2. **Selecione o target "Molho"**
3. **Vá para a aba "Build Phases"**
4. **Expanda "Copy Bundle Resources"**
5. **Procure e REMOVA** qualquer entrada relacionada a:
   - `scripts/node_modules`
   - `scripts/package.json`
   - `scripts/package-lock.json`
   - Qualquer arquivo `.md`, `.yml`, `.json` (exceto `GoogleService-Info.plist`)

### 3. Limpar Build

1. **No Xcode**: **Product → Clean Build Folder** (ou Shift+Cmd+K)
2. **Feche e reabra o Xcode** (opcional, mas recomendado)
3. **Tente fazer build novamente**: **Product → Build** (ou Cmd+B)

### 4. Se o Problema Persistir

Se ainda houver erros, você pode mover a pasta `scripts` para fora do projeto:

```bash
cd /Users/brunoq./Desktop/Molho
mv Molho/scripts .
```

Depois, quando precisar executar os scripts, use:
```bash
cd /Users/brunoq./Desktop/Molho/scripts
node populate_firestore_complete.js
```

## Verificação Final

Após aplicar as correções:
- ✅ Build deve compilar sem erros
- ✅ Bundle não deve conter `node_modules`
- ✅ Bundle não deve conter arquivos `.md`, `.json` de desenvolvimento

## Arquivos que NÃO devem estar no Bundle iOS

- ❌ `node_modules/` (qualquer pasta)
- ❌ `package.json`, `package-lock.json`
- ❌ `*.md` (README, CHANGELOG, etc.)
- ❌ `*.yml`, `*.yaml`
- ❌ `.eslintrc`, `.npmignore`
- ❌ `tsconfig.json`
- ❌ `test.js`, `tests.js`
- ❌ `LICENSE*`

## Arquivos que DEVEM estar no Bundle iOS

- ✅ `GoogleService-Info.plist` (Firebase)
- ✅ `Assets.xcassets/` (imagens)
- ✅ Arquivos `.swift` do app
- ✅ Outros recursos necessários em runtime

