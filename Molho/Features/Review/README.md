# Sistema de Avaliações (Reviews)

Este módulo implementa o sistema completo de avaliações de estabelecimentos pelos usuários.

## Estrutura

### Modelos
- **Review.swift**: Modelo de dados para avaliações
  - `rating`: Avaliação de 1 a 5 estrelas
  - `comment`: Comentário opcional do usuário
  - `merchantId`: ID do estabelecimento avaliado
  - `userId`: ID do usuário que fez a avaliação
  - Timestamps de criação e atualização

### Repositórios
- **ReviewRepository.swift**: Protocolo com operações de avaliações
- **FirebaseReviewRepository.swift**: Implementação Firebase
  - Adicionar, atualizar e deletar avaliações
  - Buscar avaliações por estabelecimento ou usuário
  - Calcular média de avaliações
  - Atualizar métricas do estabelecimento automaticamente

### Views
- **AddReviewView.swift**: BottomSheet para adicionar/editar avaliação
  - Seleção de 1 a 5 estrelas
  - Campo opcional de comentário
  - Suporta edição de avaliação existente
  - Opção para deletar avaliação

- **AddReviewViewModel.swift**: ViewModel para gerenciar estado da avaliação

## Integração

O sistema está integrado com:

1. **MerchantSheetView**: Botão de estrela abre o AddReviewView
2. **Firebase Firestore**: Persistência de dados
3. **AuthenticationManager**: Identifica usuário que está avaliando

## Funcionalidades

### Adicionar Avaliação
1. Usuário clica no ícone de estrela na tela do estabelecimento
2. BottomSheet é aberto com seleção de estrelas e campo de comentário
3. Ao enviar, a avaliação é salva no Firebase
4. Métricas do estabelecimento são atualizadas automaticamente

### Editar Avaliação
- Se o usuário já avaliou o estabelecimento, o sistema carrega a avaliação existente
- Campos são preenchidos com os dados atuais
- Usuário pode atualizar a avaliação

### Deletar Avaliação
- Se existir avaliação, botão de remover é exibido
- Ao deletar, as métricas do estabelecimento são atualizadas

### Cálculo Automático de Métricas
- Média de avaliações (`publicRating`)
- Total de avaliações (`reviewsCount`)
- Atualização automática no documento do estabelecimento

## Banco de Dados

### Coleção: `reviews`

```json
{
  "id": "UUID",
  "merchantId": "merchant_id",
  "userId": "user_id",
  "userName": "Nome do Usuário",
  "userAvatarUrl": "https://...",
  "rating": 5,
  "comment": "Ótima experiência!",
  "createdAt": "Timestamp",
  "updatedAt": "Timestamp"
}
```

### Índices Recomendados

Para melhor performance, criar índices compostos no Firestore:

1. `merchantId` (Ascending) + `createdAt` (Descending)
2. `userId` (Ascending) + `createdAt` (Descending)
3. `userId` (Ascending) + `merchantId` (Ascending)

## Uso

```swift
// Abrir view de avaliação
@State private var showAddReview = false

Button("Avaliar") {
    showAddReview = true
}
.sheet(isPresented: $showAddReview) {
    AddReviewView(merchant: merchant)
}
```

## Próximos Passos

- [ ] Criar view para listar todas as avaliações de um estabelecimento
- [ ] Adicionar filtros por quantidade de estrelas
- [ ] Implementar paginação para grandes quantidades de avaliações
- [ ] Adicionar sistema de "útil" para avaliações
- [ ] Permitir resposta do estabelecimento às avaliações

