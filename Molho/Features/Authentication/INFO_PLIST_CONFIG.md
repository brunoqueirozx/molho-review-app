# Configuração do Info.plist para Autenticação

## 📝 Como Configurar

### 1. Abrir o Info.plist

No Xcode, localize o arquivo `Info.plist` na raiz do projeto.

### 2. Adicionar Google Sign-In

1. Primeiro, pegue o `REVERSED_CLIENT_ID` do arquivo `GoogleService-Info.plist`:
   - Abra o arquivo `GoogleService-Info.plist`
   - Procure pela chave `REVERSED_CLIENT_ID`
   - Copie o valor (algo como: `com.googleusercontent.apps.XXXXXXXXXX`)

2. No `Info.plist`, clique com botão direito → **Add Row**

3. Adicione:
   ```
   Key: CFBundleURLTypes
   Type: Array
   ```

4. Expanda o array e adicione um **Dictionary**:
   ```
   Item 0 (Dictionary)
     ├─ CFBundleTypeRole: String = "Editor"
     └─ CFBundleURLSchemes: Array
          └─ Item 0: String = "SEU_REVERSED_CLIENT_ID_AQUI"
   ```

### 3. Adicionar Apple Sign-In (Capability)

**No Xcode:**

1. Selecione o projeto no navegador
2. Selecione o target "Molho"
3. Vá na aba **Signing & Capabilities**
4. Clique em **+ Capability**
5. Adicione **Sign in with Apple**

## 📋 Exemplo Visual do Info.plist

Seu `Info.plist` deve ter esta estrutura:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- ... outras configurações ... -->
    
    <!-- Google Sign-In -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>com.googleusercontent.apps.XXXXXXXXXX</string>
            </array>
        </dict>
    </array>
    
    <!-- ... outras configurações ... -->
</dict>
</plist>
```

## ✅ Verificação

### Como saber se está correto:

1. **Google Sign-In:**
   - Se o `REVERSED_CLIENT_ID` estiver correto, ao clicar em "Continuar com Google", uma tela do Google deve aparecer
   - Se não funcionar, verifique se o valor está exatamente como no `GoogleService-Info.plist`

2. **Apple Sign-In:**
   - Se a capability estiver ativa, o botão "Sign in with Apple" deve aparecer
   - Ao clicar, deve solicitar Face ID/Touch ID ou senha do iCloud

## 🔍 Encontrando o REVERSED_CLIENT_ID

1. Abra `GoogleService-Info.plist`
2. Procure por esta linha:

```xml
<key>REVERSED_CLIENT_ID</key>
<string>com.googleusercontent.apps.XXXXXXXXXX-YYYYYYYYYYYYYYYYYYYYYYYY</string>
```

3. Copie o valor da string (sem as tags XML)
4. Cole no `Info.plist` em `CFBundleURLSchemes > Item 0`

## 🚨 Erros Comuns

### "No app is associated with this activity"
- **Causa:** REVERSED_CLIENT_ID incorreto
- **Solução:** Verifique se copiou o valor correto do GoogleService-Info.plist

### Apple Sign-In não aparece
- **Causa:** Capability não adicionada
- **Solução:** Vá em Signing & Capabilities e adicione "Sign in with Apple"

### "Invalid Bundle ID"
- **Causa:** Bundle ID do Xcode diferente do Firebase Console
- **Solução:** Verifique se o Bundle ID no Xcode é o mesmo do Firebase

## 📱 Testando

Após configurar:

1. **Teste Google:**
   ```
   Abra o app → "Continuar com Google" → Deve abrir tela do Google
   ```

2. **Teste Apple:**
   ```
   Abra o app → Botão Apple → Deve solicitar autenticação biométrica
   ```

3. **Teste Email:**
   ```
   Abra o app → "Criar conta com Email" → Preencha formulário → Verifique email
   ```

## 💡 Dica

Se estiver tendo problemas, delete o app do simulador/dispositivo e instale novamente. Às vezes configurações antigas podem causar conflitos.

