# Molho - App iOS

App iOS para descobrir e avaliar estabelecimentos gastronômicos, desenvolvido com SwiftUI e Firebase.

## 🏗️ Estrutura do Projeto

```
Molho/
├── App/
│   ├── MolhoApp.swift          # Entry point do app
│   └── AppDelegate.swift       # Configuração do Firebase
├── Features/
│   ├── Home/
│   │   ├── HomeView.swift      # Tela principal com mapa
│   │   ├── HomeViewModel.swift # ViewModel da Home
│   │   ├── TopBar.swift        # Barra superior
│   │   ├── BottomBar.swift     # Barra inferior (tabs)
│   │   └── MapContainerView.swift # Container do mapa
│   ├── Search/
│   │   ├── SearchView.swift    # Tela de busca
│   │   ├── SearchViewModel.swift # ViewModel da busca
│   │   └── MerchantListItem.swift # Item da lista de resultados
│   └── Merchant/
│       ├── MerchantSheetView.swift # Bottom sheet do estabelecimento
│       └── MerchantViewModel.swift # ViewModel do merchant
├── Shared/
│   ├── Models/
│   │   └── Merchant.swift      # Modelo de dados do estabelecimento
│   ├── Repositories/
│   │   ├── MerchantRepository.swift # Protocolo do repositório
│   │   ├── FirebaseMerchantRepository.swift # Implementação Firebase
│   │   └── FirebaseMerchantRepositoryAsync.swift # Versão async
│   └── Theme/
│       └── Theme.swift         # Cores e espaçamentos
├── Assets.xcassets/            # Imagens e assets
└── GoogleService-Info.plist    # Configuração do Firebase
```

## 🔥 Firebase Firestore

O app está conectado ao Firebase Firestore e carrega os estabelecimentos da coleção `merchants`.

### Estrutura de Dados

Cada documento na coleção `merchants` contém:

- `id`: String (ID do documento)
- `name`: String (nome do estabelecimento)
- `headerImageUrl`: String? (URL da imagem principal)
- `carouselImages`: [String]? (até 10 imagens)
- `galleryImages`: [String]? (galeria sem limite)
- `categories`: [String]? (tags de categoria)
- `style`: String? (ex: "Casual", "Elegante")
- `criticRating`: Double? (1.0 a 5.0)
- `publicRating`: Double? (1.0 a 5.0)
- `likesCount`: Int?
- `bookmarksCount`: Int?
- `viewsCount`: Int?
- `description`: String? (até 1000 caracteres)
- `addressText`: String? (endereço completo)
- `latitude`: Double
- `longitude`: Double
- `openingHours`: OpeningHours? (horário de funcionamento)
- `isOpen`: Bool? (se está aberto agora)
- `createdAt`: Date?
- `updatedAt`: Date?

## 🚀 Como Funciona

### Tela de Busca

1. Ao abrir a tela de busca, `SearchViewModel.loadAllMerchants()` é chamado
2. O método busca todos os merchants da coleção `merchants` no Firestore
3. Os dados são decodificados e exibidos na lista
4. Durante o carregamento, um indicador de loading é exibido
5. Em caso de erro, uma mensagem é exibida com opção de tentar novamente

### Tela Home

1. Ao abrir a Home, `HomeViewModel.loadNearby()` é chamado
2. Carrega merchants próximos (atualmente todos os merchants)
3. Exibe no mapa (funcionalidade futura)

### Merchant Sheet

1. Ao clicar em um merchant na lista de busca
2. Abre um bottom sheet nativo com detalhes completos
3. Mostra imagem, categorias, avaliações, horários, galeria, etc.

## 📋 Requisitos

- Xcode 15+ (iOS 17+)
- SwiftUI
- MapKit
- Firebase SDK (FirebaseFirestore, FirebaseCore)

## 🔧 Configuração

### 1. Instalar Firebase SDK

No Xcode:
1. **File → Add Package Dependencies**
2. Adicione: `https://github.com/firebase/firebase-ios-sdk`
3. Selecione: `FirebaseFirestore`, `FirebaseCore`

### 2. Configurar GoogleService-Info.plist

O arquivo `GoogleService-Info.plist` já está configurado com as credenciais do projeto `molho-review-app`.

### 3. Verificar Firestore

Certifique-se de que:
- O Firestore está ativado no Firebase Console
- A coleção `merchants` existe e tem dados
- As regras de segurança permitem leitura pública

## 🧪 Testar

1. Execute o app no simulador ou dispositivo
2. Navegue para a tela de busca (ícone de busca no BottomBar)
3. Você deve ver os merchants carregados do Firestore
4. Clique em um merchant para ver os detalhes no bottom sheet

## 📝 Logs de Debug

O app imprime logs no console do Xcode:
- `🔍 Buscando merchants no Firestore...`
- `📦 Documentos encontrados: X`
- `✅ Merchants decodificados: X`
- `❌ Erro ao...` (em caso de erro)

## 🎨 Design

O app segue o design do Figma com:
- Cores personalizadas (Theme.swift)
- Espaçamentos consistentes
- Tipografia do sistema
- SF Symbols para ícones

## 📦 Dependências

- Firebase iOS SDK (via SPM)
- SwiftUI (nativo)
- MapKit (nativo)

