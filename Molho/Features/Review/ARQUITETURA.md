# 🏗️ Arquitetura do Sistema de Avaliações

## 📊 Diagrama de Fluxo

```
┌─────────────────────────────────────────────────────────────┐
│                    MerchantSheetView                        │
│  ┌────────────┐         ┌────────────┐                     │
│  │ ⭐ Estrela │────────▶│ 💬 Reviews │                     │
│  └────────────┘         └────────────┘                     │
└───────┬──────────────────────┬──────────────────────────────┘
        │                      │
        ▼                      ▼
┌──────────────────┐   ┌──────────────────┐
│ AddReviewView    │   │ ReviewsListView  │
│                  │   │                  │
│ • 5 Estrelas     │   │ • Média: 4.5⭐   │
│ • Comentário     │   │ • Total: 127     │
│ • Enviar/Editar  │   │ • Lista completa │
│ • Deletar        │   │ • Pull-refresh   │
└────────┬─────────┘   └────────┬─────────┘
         │                      │
         ▼                      ▼
┌────────────────────────────────────────┐
│      AddReviewViewModel                │
│      ReviewsListViewModel              │
└────────┬───────────────────────────────┘
         │
         ▼
┌────────────────────────────────────────┐
│     FirebaseReviewRepository           │
│                                        │
│ • addReview()                         │
│ • updateReview()                      │
│ • deleteReview()                      │
│ • fetchReviews()                      │
│ • calculateAverageRating()            │
│ • updateMerchantMetrics()             │
└────────┬───────────────────────────────┘
         │
         ▼
┌────────────────────────────────────────┐
│         Firebase Firestore             │
│                                        │
│  reviews/                             │
│  ├── {reviewId}/                      │
│  │   ├── id                           │
│  │   ├── merchantId                   │
│  │   ├── userId                       │
│  │   ├── rating (1-5)                │
│  │   └── comment                      │
│                                        │
│  merchants/                           │
│  └── {merchantId}/                    │
│      ├── publicRating                 │
│      └── reviewsCount                 │
└────────────────────────────────────────┘
```

## 🎯 Camadas da Arquitetura

### 1️⃣ Camada de Apresentação (Views)

#### AddReviewView
**Responsabilidade**: Interface para adicionar/editar avaliações

**Componentes**:
- Título dinâmico com nome do estabelecimento
- Seletor interativo de estrelas (1-5)
- Campo de texto para comentário opcional
- Botão de enviar (verde)
- Botão de deletar (vermelho, apenas ao editar)
- Feedback visual de estados (loading, sucesso, erro)

**Estados**:
- `Criação`: Campos vazios, botão "Enviar avaliação"
- `Edição`: Campos preenchidos, botão "Atualizar avaliação"
- `Loading`: Spinner no botão, campos desabilitados
- `Sucesso`: Mensagem verde, fecha automaticamente
- `Erro`: Mensagem vermelha, mantém aberto

#### ReviewsListView
**Responsabilidade**: Exibir todas as avaliações

**Componentes**:
- Card de resumo (média e total)
- Lista scrollável de reviews
- Avatar do usuário (com fallback)
- Data relativa ("há 2 dias")
- Pull-to-refresh

**Estados**:
- `Empty`: Mensagem "Nenhuma avaliação ainda"
- `Loading`: Spinner centralizado
- `Loaded`: Lista de reviews
- `Refreshing`: Pull-to-refresh ativo

### 2️⃣ Camada de Lógica (ViewModels)

#### AddReviewViewModel
**Responsabilidade**: Gerenciar estado da avaliação

**Propriedades Publicadas**:
```swift
@Published var rating: Int = 0
@Published var comment: String = ""
@Published var isLoading: Bool = false
@Published var errorMessage: String?
@Published var successMessage: String?
```

**Métodos Principais**:
- `loadExistingReview(userId:)`: Carrega review existente
- `submitReview(userId:userName:userAvatarUrl:)`: Cria ou atualiza
- `deleteReview()`: Remove avaliação

#### ReviewsListViewModel
**Responsabilidade**: Gerenciar lista de avaliações

**Propriedades Publicadas**:
```swift
@Published var reviews: [Review] = []
@Published var isLoading: Bool = false
@Published var errorMessage: String?
@Published var averageRating: Double = 0.0
```

**Métodos Principais**:
- `loadReviews()`: Busca todas as reviews

### 3️⃣ Camada de Dados (Repositories)

#### ReviewRepository (Protocolo)
**Responsabilidade**: Interface padronizada

**Métodos Obrigatórios**:
```swift
func addReview(_ review: Review) async throws
func updateReview(_ review: Review) async throws
func deleteReview(reviewId: String) async throws
func fetchReviews(for merchantId: String) async throws -> [Review]
func fetchUserReviews(userId: String) async throws -> [Review]
func fetchUserReview(userId: String, merchantId: String) async throws -> Review?
func calculateAverageRating(for merchantId: String) async throws -> Double
func countReviews(for merchantId: String) async throws -> Int
```

#### FirebaseReviewRepository
**Responsabilidade**: Implementação com Firebase

**Funcionalidades**:
- ✅ CRUD completo de reviews
- ✅ Queries otimizadas com índices
- ✅ Atualização automática de métricas
- ✅ Tratamento de erros
- ✅ Logs detalhados para debugging

**Fluxo de Atualização de Métricas**:
```
Operação (add/update/delete)
    ↓
Salvar/Deletar review
    ↓
Calcular nova média
    ↓
Contar total de reviews
    ↓
Atualizar documento do merchant
```

### 4️⃣ Camada de Modelo (Models)

#### Review
**Responsabilidade**: Estrutura de dados

```swift
struct Review: Identifiable, Codable {
    var id: String                  // UUID
    var merchantId: String          // Estabelecimento
    var userId: String              // Usuário
    var userName: String            // Nome para exibição
    var userAvatarUrl: String?      // Avatar (opcional)
    var rating: Int                 // 1-5 estrelas
    var comment: String?            // Comentário opcional
    var createdAt: Date?            // Data de criação
    var updatedAt: Date?            // Última atualização
}
```

## 🔄 Fluxos de Uso

### Fluxo 1: Adicionar Primeira Avaliação

```
1. Usuário → Abre MerchantSheetView
2. Usuário → Clica em ⭐ (estrela)
3. Sistema → Abre AddReviewView
4. Sistema → Verifica se usuário já avaliou (não)
5. Usuário → Seleciona 5 estrelas
6. Usuário → Digita "Excelente!"
7. Usuário → Clica "Enviar avaliação"
8. Sistema → Valida (rating > 0)
9. Sistema → Cria Review no Firebase
10. Sistema → Atualiza métricas do merchant
11. Sistema → Mostra "Avaliação enviada com sucesso!"
12. Sistema → Fecha sheet após 1.5s
```

### Fluxo 2: Editar Avaliação Existente

```
1. Usuário → Abre MerchantSheetView
2. Usuário → Clica em ⭐ (estrela)
3. Sistema → Abre AddReviewView
4. Sistema → Verifica se usuário já avaliou (sim)
5. Sistema → Carrega review existente
6. Sistema → Preenche campos (rating=5, comment="Excelente!")
7. Sistema → Mostra "Editar sua avaliação"
8. Sistema → Exibe botão "Remover avaliação"
9. Usuário → Muda para 4 estrelas
10. Usuário → Clica "Atualizar avaliação"
11. Sistema → Atualiza Review no Firebase
12. Sistema → Recalcula métricas do merchant
13. Sistema → Mostra "Avaliação atualizada com sucesso!"
14. Sistema → Fecha sheet após 1.5s
```

### Fluxo 3: Ver Todas as Avaliações

```
1. Usuário → Abre MerchantSheetView
2. Usuário → Vê métricas (⭐ 4.5, 💬 127)
3. Usuário → Clica no 💬 (contador de reviews)
4. Sistema → Abre ReviewsListView
5. Sistema → Busca todas as reviews do merchant
6. Sistema → Calcula média (4.5)
7. Sistema → Exibe card de resumo
8. Sistema → Renderiza lista de reviews
9. Usuário → Scroll pela lista
10. Usuário → Pull-to-refresh
11. Sistema → Recarrega reviews
```

## 🛡️ Validações e Segurança

### Validações no Cliente (Swift)
```swift
✅ Rating entre 1-5
✅ Usuário autenticado
✅ Campos obrigatórios preenchidos
✅ Limite de caracteres no comentário
```

### Validações no Servidor (Firebase Rules)
```javascript
✅ userId corresponde ao auth.uid
✅ Rating entre 1-5
✅ Apenas dono pode editar/deletar
✅ Timestamps válidos
```

## 📈 Performance

### Otimizações Implementadas

**1. Índices Compostos**
- Queries rápidas por merchant + data
- Queries rápidas por user + data
- Busca eficiente de review específica

**2. Cálculos no Servidor**
- Média calculada no backend
- Contagem agregada (evita buscar todos os docs)

**3. Estados de Loading**
- Feedback imediato ao usuário
- Skeleton screens (possível implementação futura)

**4. Cache Potencial** (não implementado ainda)
- Reviews podem ser cacheadas localmente
- Invalidar cache após operações de escrita

## 🧪 Pontos de Teste

### Testes Unitários (Sugeridos)

```swift
// ReviewViewModel
✓ submitReview() - sucesso
✓ submitReview() - rating inválido
✓ submitReview() - usuário não autenticado
✓ loadExistingReview() - review existe
✓ loadExistingReview() - review não existe
✓ deleteReview() - sucesso

// ReviewRepository
✓ addReview() - sucesso
✓ updateReview() - sucesso
✓ deleteReview() - sucesso
✓ fetchReviews() - lista vazia
✓ fetchReviews() - lista com itens
✓ calculateAverageRating() - valores corretos
```

### Testes de Interface (Sugeridos)

```swift
✓ Abrir AddReviewView
✓ Selecionar estrelas
✓ Digitar comentário
✓ Enviar avaliação
✓ Editar avaliação existente
✓ Deletar avaliação
✓ Ver lista de avaliações
✓ Pull-to-refresh
```

## 🎨 Design System

### Cores
- **Verde Primário**: Theme.primaryGreen (botão enviar)
- **Ouro**: #FFD700 (estrelas selecionadas)
- **Vermelho**: .red (deletar, erros)
- **Cinza Claro**: #F5F5F5 (backgrounds)
- **Texto Principal**: #1f1f1f
- **Texto Secundário**: #989898

### Espaçamentos
- **spacing8**: 8pt
- **spacing12**: 12pt
- **spacing16**: 16pt
- **spacing24**: 24pt

### Bordas
- **corner8**: 8pt
- **corner12**: 12pt
- **corner100**: 100pt (circular)

## 📦 Dependências

### Firebase
```
- FirebaseFirestore
- FirebaseAuth (para autenticação)
```

### SwiftUI
```
- Combine (para @Published)
- Foundation (para Date, UUID)
```

## 🔮 Evolução Futura

### Fase 2: Recursos Avançados
- [ ] Fotos nas avaliações
- [ ] Vídeos curtos (stories)
- [ ] Marcar amigos
- [ ] Compartilhar reviews

### Fase 3: Engajamento
- [ ] Sistema de "útil"
- [ ] Badges para reviewers
- [ ] Gamificação
- [ ] Ranking de reviewers

### Fase 4: Business
- [ ] Respostas do estabelecimento
- [ ] Analytics detalhado
- [ ] Moderação automática
- [ ] Sistema de denúncias

## 📝 Conclusão

Esta arquitetura segue os princípios de:
- ✅ **Separação de responsabilidades**
- ✅ **SOLID principles**
- ✅ **Clean Architecture**
- ✅ **MVVM pattern**
- ✅ **Repository pattern**
- ✅ **Protocol-oriented programming**

O sistema está **pronto para produção** e **fácil de manter e evoluir**! 🚀

