# Molho - App iOS

App iOS para descobrir e avaliar restaurantes e bares, desenvolvido com SwiftUI e Firebase.

## 🚀 Features

- 🔐 **Autenticação** (Email, Google, Apple Sign In)
- 🗺️ **Mapa interativo** com pins de estabelecimentos
- ⭐ **Sistema de reviews** e avaliações
- 👤 **Perfil de usuário** com foto
- 🔍 **Busca** de estabelecimentos
- 📍 **Localização** atual do usuário

---

## 🛠️ Stack Tecnológica

- **SwiftUI** - Interface nativa iOS
- **Firebase Auth** - Autenticação
- **Firestore** - Banco de dados NoSQL
- **Firebase Storage** - Armazenamento de imagens
- **MapKit** - Mapa interativo
- **Core Data** - Persistência local

---

## 📋 Pré-requisitos

- **Xcode 15+** (iOS 17+)
- **Conta Firebase** (gratuita)
- **CocoaPods** ou **Swift Package Manager**

---

## ⚙️ Configuração do Projeto

### 1. Clone o Repositório

```bash
git clone https://github.com/brunoqueirozx/molho-review-app.git
cd molho-review-app
```

### 2. Configure o Firebase

#### 2.1. Crie um Projeto Firebase

1. Acesse: [Firebase Console](https://console.firebase.google.com/)
2. Clique em **"Adicionar projeto"**
3. Siga o assistente de configuração

#### 2.2. Adicione um App iOS

1. No Firebase Console, clique em **"Adicionar app" → iOS**
2. **Bundle ID:** `molho.review.Molho` (deve ser exatamente esse)
3. Baixe o arquivo **`GoogleService-Info.plist`**
4. Coloque em: `Molho/GoogleService-Info.plist`

#### 2.3. Configure o Info.plist

1. Copie o template: `cp Molho/Info.plist.template Molho/Info.plist`
2. Abra `GoogleService-Info.plist` e copie o valor de `REVERSED_CLIENT_ID`
3. Cole no `Info.plist` no campo `CFBundleURLSchemes`

Exemplo:
```xml
<key>CFBundleURLSchemes</key>
<array>
    <string>com.googleusercontent.apps.SEU-CLIENT-ID-AQUI</string>
</array>
```

#### 2.4. Ative os Serviços no Firebase

No Firebase Console:

1. **Authentication:**
   - Vá em **Authentication → Sign-in method**
   - Ative: **Email/Password**, **Google**, **Apple**

2. **Firestore:**
   - Vá em **Firestore Database**
   - Clique em **"Criar banco de dados"**
   - Escolha **"Modo de teste"** (produção depois)

3. **Storage:**
   - Vá em **Storage**
   - Clique em **"Começar"**

### 3. Instale as Dependências

#### Opção A: Swift Package Manager (Recomendado)

No Xcode:
1. **File → Add Package Dependencies**
2. Adicione: `https://github.com/firebase/firebase-ios-sdk`
3. Selecione:
   - `FirebaseAuth`
   - `FirebaseFirestore`
   - `FirebaseStorage`

#### Opção B: CocoaPods

```bash
cd molho-review-app
pod install
# Abra o arquivo .xcworkspace gerado
```

### 4. Execute o App

1. Abra `Molho.xcodeproj` no Xcode
2. Selecione um simulador ou dispositivo
3. ⌘ + R para executar

---

## 🔐 Segurança

### Arquivos Sensíveis (NÃO estão no repositório)

Os seguintes arquivos contêm credenciais e **NÃO** devem ser commitados:

| Arquivo | Onde obter | Localização |
|---------|------------|-------------|
| `GoogleService-Info.plist` | Firebase Console → Project Settings → iOS app | `Molho/` |
| `Info.plist` | Criar baseado no template | `Molho/` |
| `serviceAccountKey.json` | Firebase Console → Service Accounts (opcional) | `scripts/` |

### ⚠️ **NUNCA Commite:**

- `GoogleService-Info.plist`
- `Info.plist` (com credenciais)
- `serviceAccountKey*.json`
- Arquivos `.env`
- Chaves privadas (`.pem`, `.p8`, `.key`)

### ✅ Práticas de Segurança Implementadas

- Credenciais Firebase protegidas por **Bundle ID**
- Regras de segurança ativas no **Firestore**
- `.gitignore` configurado para arquivos sensíveis
- Autenticação obrigatória para escrita no banco

---

## 🏗️ Arquitetura do Projeto

```
Molho/
├── App/
│   ├── MolhoApp.swift              # Entry point
│   └── AppDelegate.swift           # Configuração Firebase
│
├── Features/                       # Organizadas por feature
│   ├── Authentication/
│   │   ├── AuthenticationView.swift
│   │   ├── LoginView.swift
│   │   ├── SignUpView.swift
│   │   └── SplashView.swift
│   │
│   ├── Home/
│   │   ├── HomeView.swift          # Tela principal com mapa
│   │   ├── HomeViewModel.swift
│   │   ├── TopBar.swift
│   │   ├── BottomBar.swift         # Navegação
│   │   ├── MapContainerView.swift
│   │   └── MerchantPinView.swift
│   │
│   ├── Search/
│   │   ├── SearchView.swift
│   │   ├── SearchViewModel.swift
│   │   └── MerchantListItem.swift
│   │
│   ├── Merchant/
│   │   ├── MerchantSheetView.swift # Detalhes do estabelecimento
│   │   └── MerchantViewModel.swift
│   │
│   ├── Review/
│   │   ├── AddReviewView.swift
│   │   ├── AddReviewViewModel.swift
│   │   ├── ReviewsListView.swift
│   │   └── ReviewsListViewModel.swift
│   │
│   ├── Profile/
│   │   ├── ProfileView.swift
│   │   └── ProfileViewModel.swift
│   │
│   └── AddMerchant/
│       ├── AddMerchantView.swift
│       └── AddMerchantViewModel.swift
│
├── Shared/
│   ├── Models/
│   │   ├── Merchant.swift
│   │   ├── Review.swift
│   │   └── User.swift
│   │
│   ├── Repositories/               # Abstração de dados
│   │   ├── MerchantRepository.swift
│   │   ├── FirebaseMerchantRepository.swift
│   │   ├── ReviewRepository.swift
│   │   ├── FirebaseReviewRepository.swift
│   │   ├── UserRepository.swift
│   │   └── FirebaseUserRepository.swift
│   │
│   ├── Services/
│   │   ├── AuthenticationManager.swift
│   │   ├── FirebaseStorageService.swift
│   │   └── LocationManager.swift
│   │
│   └── Theme/
│       └── Theme.swift             # Cores e espaçamentos
│
├── Assets.xcassets/                # Imagens e ícones
└── Tests/                          # Testes unitários
```

---

## 🗄️ Estrutura do Firestore

### Coleção: `merchants`

```json
{
  "id": "string",
  "name": "string",
  "headerImageUrl": "string?",
  "carouselImages": ["string"],
  "galleryImages": ["string"],
  "categories": ["string"],
  "style": "string",
  "criticRating": 4.5,
  "publicRating": 4.2,
  "likesCount": 380,
  "bookmarksCount": 350,
  "viewsCount": 520,
  "description": "string",
  "addressText": "string",
  "latitude": -23.56,
  "longitude": -46.68,
  "openingHours": {
    "monday": { "open": "18:00", "close": "23:00", "isClosed": false }
  },
  "isOpen": true,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Coleção: `reviews`

```json
{
  "id": "string",
  "merchantId": "string",
  "userId": "string",
  "userName": "string",
  "userPhotoUrl": "string?",
  "rating": 4.5,
  "comment": "string",
  "photos": ["string"],
  "createdAt": "timestamp"
}
```

### Coleção: `users`

```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "avatarUrl": "string?",
  "createdAt": "timestamp"
}
```

---

## 🎨 Design System

O app segue um design system consistente definido em `Theme.swift`:

### Cores

```swift
Theme.Colors.primary        // Verde principal
Theme.Colors.secondary      // Cinza escuro
Theme.Colors.background     // Branco/Cinza claro
Theme.Colors.text           // Preto/Cinza escuro
Theme.Colors.textSecondary  // Cinza médio
```

### Espaçamentos

```swift
Theme.Spacing.xs   // 4pt
Theme.Spacing.sm   // 8pt
Theme.Spacing.md   // 16pt
Theme.Spacing.lg   // 24pt
Theme.Spacing.xl   // 32pt
```

---

## 🧪 Como Testar

### 1. Tela de Autenticação

- Teste login com email/senha
- Teste cadastro de novo usuário
- Teste Google Sign In
- Teste Apple Sign In

### 2. Tela Home

- Verifique se o mapa carrega
- Verifique se os pins aparecem
- Teste a navegação para outras telas

### 3. Tela de Busca

- Busque por estabelecimentos
- Clique em um resultado
- Verifique se o bottom sheet abre

### 4. Perfil

- Carregue foto de perfil
- Edite informações
- Teste logout

---

## 📝 Logs de Debug

O app imprime logs úteis no console do Xcode:

```
🔍 Buscando merchants no Firestore...
📦 Documentos encontrados: 12
✅ Merchants decodificados: 12
🔄 Carregando avatar do Firebase...
✅ Avatar carregado com sucesso!
```

---

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto é privado e não possui licença pública.

---

## 📞 Suporte

Se tiver problemas:

1. Verifique se o Firebase está configurado corretamente
2. Confira os logs no console do Xcode
3. Consulte a [documentação do Firebase](https://firebase.google.com/docs)

---

**Desenvolvido com ❤️ usando SwiftUI**
