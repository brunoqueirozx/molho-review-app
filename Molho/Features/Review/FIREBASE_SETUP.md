# Configuração Firebase para Sistema de Avaliações

Este guia explica como configurar o Firebase Firestore para suportar o sistema de avaliações.

## 1. Criar Coleção no Firestore

Acesse o [Console do Firebase](https://console.firebase.google.com/) e crie a coleção `reviews`:

### Estrutura da Coleção

```
reviews/
  ├── {reviewId}/
      ├── id: string
      ├── merchantId: string
      ├── userId: string
      ├── userName: string
      ├── userAvatarUrl: string (opcional)
      ├── rating: number (1-5)
      ├── comment: string (opcional)
      ├── createdAt: timestamp
      └── updatedAt: timestamp
```

## 2. Configurar Índices Compostos

Para otimizar as queries, crie os seguintes índices compostos no Firestore:

### Console Firebase → Firestore Database → Indexes → Create Index

#### Índice 1: Buscar reviews por estabelecimento (ordenado por data)
- **Coleção**: `reviews`
- **Campos**:
  - `merchantId`: Ascending
  - `createdAt`: Descending
- **Escopo da query**: Collection

#### Índice 2: Buscar reviews por usuário (ordenado por data)
- **Coleção**: `reviews`
- **Campos**:
  - `userId`: Ascending
  - `createdAt`: Descending
- **Escopo da query**: Collection

#### Índice 3: Buscar review específica de um usuário para um estabelecimento
- **Coleção**: `reviews`
- **Campos**:
  - `userId`: Ascending
  - `merchantId`: Ascending
- **Escopo da query**: Collection

## 3. Configurar Regras de Segurança

### Regras Recomendadas

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Reviews
    match /reviews/{reviewId} {
      // Permitir leitura pública
      allow read: if true;
      
      // Permitir criação apenas para usuários autenticados
      allow create: if request.auth != null 
                    && request.resource.data.userId == request.auth.uid
                    && request.resource.data.rating >= 1
                    && request.resource.data.rating <= 5;
      
      // Permitir atualização apenas do próprio review
      allow update: if request.auth != null 
                    && resource.data.userId == request.auth.uid
                    && request.resource.data.rating >= 1
                    && request.resource.data.rating <= 5;
      
      // Permitir deleção apenas do próprio review
      allow delete: if request.auth != null 
                    && resource.data.userId == request.auth.uid;
    }
    
    // Merchants - permitir atualização das métricas
    match /merchants/{merchantId} {
      allow read: if true;
      
      // Apenas sistema pode atualizar métricas
      allow update: if request.auth != null;
    }
  }
}
```

## 4. Testar a Configuração

### No Console do Firebase

1. Acesse **Firestore Database**
2. Clique em **Rules Playground**
3. Teste as seguintes operações:

#### Teste 1: Criar Review
```
Operation: Create
Path: /reviews/test123
Auth: Authenticated (copie um UID de teste)
Data:
{
  "id": "test123",
  "merchantId": "merchant1",
  "userId": "seu-uid-aqui",
  "userName": "Teste",
  "rating": 5,
  "comment": "Ótimo!",
  "createdAt": timestamp.now(),
  "updatedAt": timestamp.now()
}
```

#### Teste 2: Ler Reviews
```
Operation: Get
Path: /reviews/test123
Auth: Unauthenticated
```

#### Teste 3: Atualizar Review
```
Operation: Update
Path: /reviews/test123
Auth: Authenticated (mesmo UID usado na criação)
Data:
{
  "rating": 4,
  "comment": "Muito bom!",
  "updatedAt": timestamp.now()
}
```

## 5. Monitoramento

### Métricas para Acompanhar

1. **Firestore Usage**: 
   - Leituras/Escritas por dia
   - Armazenamento usado

2. **Query Performance**:
   - Tempo médio de resposta
   - Queries lentas

3. **Custos**:
   - Estimativa de custos por operação
   - Previsão mensal

### Dashboard Recomendado

Crie alertas no Google Cloud Console para:
- Mais de 1000 escritas por minuto
- Queries com latência > 500ms
- Custos acima do orçamento mensal

## 6. Backup e Recuperação

### Configurar Backups Automáticos

1. Acesse **Firestore → Backups**
2. Configure backup diário:
   - Horário: 03:00 (horário de menor uso)
   - Retenção: 7 dias
   - Incluir coleção: `reviews`

## 7. Limites e Quotas

### Limites do Plano Gratuito (Spark)

- 50.000 leituras/dia
- 20.000 escritas/dia
- 20.000 deleções/dia
- 1 GB armazenamento

### Dicas para Economizar

1. **Cache Local**: Use estratégias de cache
2. **Paginação**: Limite resultados por página
3. **Agregações**: Calcule métricas de forma eficiente
4. **Offline First**: Sincronize apenas quando necessário

## 8. Troubleshooting

### Erro: "Missing or insufficient permissions"

**Solução**: Verifique as regras de segurança e certifique-se de que o usuário está autenticado.

### Erro: "Index not found"

**Solução**: Crie os índices compostos listados acima. O Firebase geralmente fornece um link direto para criar o índice necessário na mensagem de erro.

### Erro: "Too many requests"

**Solução**: Implemente rate limiting ou atualize para um plano superior.

## 9. Próximos Passos

- [ ] Implementar cache local para reduzir leituras
- [ ] Adicionar Cloud Functions para validação extra
- [ ] Implementar sistema de moderação de conteúdo
- [ ] Adicionar analytics para tracking de avaliações
- [ ] Implementar notificações push para novos reviews

## Recursos Úteis

- [Documentação Firestore](https://firebase.google.com/docs/firestore)
- [Melhores Práticas de Segurança](https://firebase.google.com/docs/firestore/security/rules-conditions)
- [Otimização de Queries](https://firebase.google.com/docs/firestore/query-data/query-cursors)
- [Pricing Calculator](https://firebase.google.com/pricing)

