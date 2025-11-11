# Profile - Perfil do Usuário

Esta feature implementa a tela de perfil do usuário no aplicativo Molho.

## Estrutura

```
Features/Profile/
├── ProfileView.swift           # View principal do perfil
├── ProfileViewModel.swift      # ViewModel com lógica de negócio
└── README.md                   # Documentação
```

## Funcionalidades

### 1. Avatar do Usuário
- Upload de foto de perfil através do PhotosPicker nativo do iOS
- Imagem circular de 80pt
- Preview em tempo real
- Upload automático para Firebase Storage
- Placeholder padrão quando não há avatar

### 2. Campos do Perfil
Os seguintes campos são suportados:
- **Nome**: Campo de texto livre
- **ID do Usuário**: Campo somente leitura (gerado automaticamente)
- **Email**: Campo com validação de formato
- **Telefone**: Campo numérico

### 3. Validação
- Validação em tempo real dos campos
- Validação de formato de email
- Mensagens de erro claras
- Botão de salvar desabilitado quando há erros

### 4. Integração com Firebase

#### Firestore Database
Coleção: `users`

Estrutura do documento:
```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "phone": "string",
  "avatarUrl": "string (gs://...)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### Firebase Storage
Os avatares são armazenados em:
```
users/{userId}/avatar_{uuid}.jpg
```

## Componentes Criados

### Models
- `User.swift` - Modelo de dados do usuário

### Repositories
- `UserRepository.swift` - Protocol do repositório
- `FirebaseUserRepository.swift` - Implementação com Firestore

### Services
- Extensão do `FirebaseStorageService.swift` com métodos para upload de avatar

### Views
- `ProfileView.swift` - Tela principal
- `AvatarPickerView` - Componente de seleção de avatar
- `FormFieldView` - Componente reutilizável de campo de formulário

### ViewModels
- `ProfileViewModel.swift` - Lógica de negócio e estado

## Como Usar

### Exibir a tela de perfil

```swift
import SwiftUI

struct ContentView: View {
    @State private var showProfile = false
    
    var body: some View {
        Button("Ver Perfil") {
            showProfile = true
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
    }
}
```

### Carregar perfil existente

```swift
let viewModel = ProfileViewModel()

Task {
    await viewModel.loadProfile(userId: "user-id-here")
}
```

## Design

A tela segue o design system do Molho:
- **Cores**: Usa o `Theme.swift` com cores consistentes
- **Espaçamentos**: Segue os padrões definidos (8, 12, 16, 24, 32pt)
- **Tipografia**: Usa a hierarquia de fonte nativa do iOS
- **Componentes**: Utiliza componentes nativos do iOS (TextField, etc.)

## Próximos Passos

Esta implementação é a base para:
1. Integração com Firebase Authentication (login/signup)
2. Fluxo de onboarding para novos usuários
3. Edição de perfil com mais campos
4. Preferências do usuário
5. Histórico de atividades

## Notas Técnicas

- A tela usa `@MainActor` para garantir que todas as atualizações de UI aconteçam na thread principal
- Os uploads de imagem são feitos de forma assíncrona com `async/await`
- O ID do usuário é gerado localmente por enquanto (deve ser substituído pelo Firebase Auth no futuro)
- As URLs do Firebase Storage são automaticamente convertidas de `gs://` para URLs HTTP públicas

