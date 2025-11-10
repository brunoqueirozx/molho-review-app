# 🔧 Como Adicionar Permissão de Localização no Xcode

## ⚠️ IMPORTANTE - Faça isso antes de testar a funcionalidade do pin

O app precisa de permissão para acessar a localização do usuário. Siga estes passos:

## 📋 Passo a Passo

### 1. Abra o projeto no Xcode
- Clique em `Molho.xcodeproj` no Xcode

### 2. Selecione o Target "Molho"
- No Project Navigator (painel esquerdo)
- Clique em **Molho** (ícone azul no topo)
- Certifique-se de estar na aba **Molho** (target, não projeto)

### 3. Vá para a aba "Info"
- No menu superior, clique em **Info**
- Role até encontrar a seção **Custom iOS Target Properties**

### 4. Adicione as permissões de localização

#### Permissão 1: NSLocationWhenInUseUsageDescription

1. Clique no botão **+** ao lado de qualquer propriedade
2. Comece a digitar: `Privacy - Location When`
3. Selecione: **Privacy - Location When In Use Usage Description**
4. No campo **Value**, cole:
```
Precisamos da sua localização para preencher automaticamente o endereço do estabelecimento
```

#### Permissão 2 (Opcional): NSLocationAlwaysAndWhenInUseUsageDescription

1. Clique no botão **+** novamente
2. Digite: `Privacy - Location Always`
3. Selecione: **Privacy - Location Always and When In Use Usage Description**
4. No campo **Value**, cole:
```
Precisamos da sua localização para preencher automaticamente o endereço do estabelecimento
```

### 5. Salve e faça o Build

1. Pressione **Cmd + S** para salvar
2. Pressione **Cmd + B** para build
3. Pronto! ✅

## 📸 Como deve ficar:

Na aba **Info**, você deve ver:

```
Key                                                          Type     Value
────────────────────────────────────────────────────────────────────────────
Privacy - Location When In Use Usage Description            String   Precisamos da sua localização...
Privacy - Location Always and When In Use Usage Description String   Precisamos da sua localização...
```

## ✅ Como Verificar se Funcionou

Depois de adicionar as permissões:

1. **Execute o app** (Cmd + R)
2. **Abra o formulário** de criar estabelecimento
3. **Clique no ícone de pin** 📍 no campo de endereço
4. **Você deve ver** um alerta do iOS pedindo permissão:

```
┌─────────────────────────────────────┐
│  "Molho" Gostaria de Acessar Sua   │
│         Localização                 │
├─────────────────────────────────────┤
│  Precisamos da sua localização      │
│  para preencher automaticamente o   │
│  endereço do estabelecimento        │
├─────────────────────────────────────┤
│  [ Permitir ao Usar o App ]         │
│  [ Permitir Uma Vez ]               │
│  [ Não Permitir ]                   │
└─────────────────────────────────────┘
```

5. **Clique em "Permitir ao Usar o App"**
6. **Aguarde** 2-3 segundos
7. **✅ Endereço preenchido automaticamente!**

## 🐛 Solução de Problemas

### Erro: "Permissão de localização negada"

**Solução:**
1. Vá em **Ajustes** do iOS
2. Role até encontrar **Molho**
3. Toque em **Localização**
4. Selecione **Ao Usar o App**

### Alerta não aparece

**Possíveis causas:**
1. Permissões não foram adicionadas corretamente
2. Verifique se salvou o projeto (Cmd + S)
3. Limpe o build: Cmd + Shift + K
4. Reconstrua: Cmd + B

### No Simulador

Para testar no simulador, configure uma localização:

```
Menu: Features → Location → Custom Location
Latitude: -23.561684
Longitude: -46.656139
```

Ou use uma localização predefinida:
- **Apple** (Cupertino)
- **City Run** (São Francisco)

## 📝 Valores Exatos das Permissões

Para copiar e colar:

**Key 1:**
```
NSLocationWhenInUseUsageDescription
```

**Value 1:**
```
Precisamos da sua localização para preencher automaticamente o endereço do estabelecimento
```

**Key 2 (Opcional):**
```
NSLocationAlwaysAndWhenInUseUsageDescription
```

**Value 2:**
```
Precisamos da sua localização para preencher automaticamente o endereço do estabelecimento
```

## 🎯 Pronto!

Após seguir estes passos, a funcionalidade de localização estará 100% operacional! 🚀

---

**Nota:** Essas permissões são obrigatórias para que o iOS permita o acesso à localização do usuário. Sem elas, o app irá crashar ao tentar acessar o GPS.

