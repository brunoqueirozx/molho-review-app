# 🚨 Como Remover README.md do Target

## Problema
Arquivos `README.md` estão sendo copiados para o bundle do app, causando erro "Multiple commands produce".

## Solução Rápida no Xcode

### Passo 1: Remover do Target Membership

1. **Abra o projeto no Xcode**
2. **No Project Navigator**, encontre:
   - `README.md` (na raiz do projeto)
   - `Shared/Repositories/README.md`
3. **Para cada arquivo README.md**:
   - Selecione o arquivo
   - No **File Inspector** (painel direito), encontre **"Target Membership"**
   - **DESMARQUE** o checkbox do target "Molho"
   - Clique em **"Done"**

### Passo 2: Verificar Build Phases

1. **Selecione o projeto "Molho"** no Project Navigator
2. **Selecione o target "Molho"**
3. **Vá para a aba "Build Phases"**
4. **Expanda "Copy Bundle Resources"**
5. **Procure e REMOVA** qualquer entrada relacionada a:
   - `README.md`
   - `Shared/Repositories/README.md`
   - Qualquer outro arquivo `.md`

### Passo 3: Limpar Build

1. **No Xcode**: **Product → Clean Build Folder** (`Shift+Cmd+K`)
2. **Tente fazer build novamente**: **Product → Build** (`Cmd+B`)

## Por que isso acontece?

Arquivos de documentação (`.md`, `.txt`, etc.) não devem estar no bundle do app iOS. Eles são apenas para desenvolvedores e não são necessários em runtime.

## Arquivos que NÃO devem estar no Bundle

- ❌ `README.md` (qualquer arquivo markdown)
- ❌ `*.md` (arquivos de documentação)
- ❌ `LICENSE`, `CHANGELOG.md`
- ❌ Arquivos de configuração (`.json`, `.yml`, exceto `GoogleService-Info.plist`)

## Arquivos que DEVEM estar no Bundle

- ✅ `GoogleService-Info.plist` (Firebase)
- ✅ `Assets.xcassets/` (imagens e assets)
- ✅ Arquivos `.swift` do app
- ✅ Outros recursos necessários em runtime

## Verificação Final

Após seguir os passos:
- ✅ Build deve compilar sem erros "Multiple commands produce"
- ✅ Bundle não deve conter arquivos `.md`
- ✅ Apenas recursos necessários em runtime devem estar no bundle

