# ⚡ Guia Rápido - Sistema de Avaliações

## 🎯 O Que Foi Criado?

Um sistema completo para usuários avaliarem estabelecimentos com **estrelas** (1-5) e **comentários opcionais**.

## 📱 Como Usar

### 1️⃣ Adicionar Avaliação

**Passo a Passo:**
```
1. Abra um estabelecimento na tela principal
2. Clique no ícone ⭐ (estrela) no topo da tela
3. Um bottomSheet vai abrir com o título "Avaliar [Nome do Estabelecimento]"
4. Selecione de 1 a 5 estrelas
5. (Opcional) Escreva um comentário
6. Clique em "Enviar avaliação"
7. Pronto! ✅
```

**Visual:**
```
┌─────────────────────────────┐
│  Avaliar Restaurante ABC    │
├─────────────────────────────┤
│  Qual sua avaliação?        │
│                             │
│  ⭐ ⭐ ⭐ ⭐ ⭐              │
│                             │
├─────────────────────────────┤
│  Comentário (opcional)      │
│  ┌─────────────────────┐   │
│  │ Compartilhe sua     │   │
│  │ experiência...      │   │
│  └─────────────────────┘   │
├─────────────────────────────┤
│  [Enviar avaliação] 🟢     │
└─────────────────────────────┘
```

### 2️⃣ Editar Avaliação

**Quando você já avaliou:**
```
1. Clique no ícone ⭐ novamente
2. Suas estrelas e comentário já estarão preenchidos
3. Altere o que quiser
4. Clique em "Atualizar avaliação"
5. Ou clique em "Remover avaliação" para deletar
```

**Visual:**
```
┌─────────────────────────────┐
│  Avaliar Restaurante ABC    │
├─────────────────────────────┤
│  Editar sua avaliação       │
│                             │
│  ⭐ ⭐ ⭐ ⭐ ☆              │
│                             │
├─────────────────────────────┤
│  Comentário (opcional)      │
│  ┌─────────────────────┐   │
│  │ Ótimo lugar!        │   │
│  │                     │   │
│  └─────────────────────┘   │
├─────────────────────────────┤
│  [Atualizar avaliação] 🟢  │
│  [Remover avaliação] 🔴    │
└─────────────────────────────┘
```

### 3️⃣ Ver Todas as Avaliações

**Passo a Passo:**
```
1. Na tela do estabelecimento
2. Veja as métricas: ⭐ 4.5  💬 127
3. Clique no ícone 💬 (número de avaliações)
4. Uma nova tela abre com todas as avaliações
5. Pull down para atualizar
```

**Visual:**
```
┌─────────────────────────────┐
│      Avaliações        [X]  │
├─────────────────────────────┤
│   ┌─────────────────────┐  │
│   │      4.5 ⭐⭐⭐⭐⭐  │  │
│   │   127 avaliações    │  │
│   └─────────────────────┘  │
├─────────────────────────────┤
│  👤 João Silva              │
│  ⭐⭐⭐⭐⭐                  │
│  há 2 dias                  │
│  "Excelente! Voltarei..."   │
├─────────────────────────────┤
│  👤 Maria Santos            │
│  ⭐⭐⭐⭐☆                  │
│  há 1 semana                │
│  "Muito bom, mas..."        │
└─────────────────────────────┘
```

## 🗂️ Arquivos Importantes

### Modelos
- `Review.swift` - Estrutura da avaliação

### Repositórios
- `ReviewRepository.swift` - Interface
- `FirebaseReviewRepository.swift` - Implementação Firebase

### Views
- `AddReviewView.swift` - Adicionar/Editar
- `ReviewsListView.swift` - Listar todas

### ViewModels
- `AddReviewViewModel.swift` - Lógica de adicionar
- `ReviewsListViewModel.swift` - Lógica de listar

## 🔧 Configuração Necessária

### Firebase
1. Acesse o Console do Firebase
2. Crie a coleção `reviews`
3. Configure índices (ver `FIREBASE_SETUP.md`)
4. Configure regras de segurança

### Xcode
✅ Nenhuma configuração adicional necessária
✅ Já integrado com MerchantSheetView
✅ Usa AuthenticationManager existente

## ⚙️ Funcionalidades Automáticas

### ✅ O Sistema Faz Sozinho:

1. **Detecta se você já avaliou**
   - Carrega sua avaliação automaticamente
   - Muda interface para modo "editar"

2. **Atualiza métricas do estabelecimento**
   - Calcula média de estrelas
   - Conta total de avaliações
   - Atualiza na tela automaticamente

3. **Valida dados**
   - Garante que estrelas estão entre 1-5
   - Verifica se usuário está logado
   - Mostra erros se algo der errado

4. **Feedback visual**
   - Loading ao enviar
   - Mensagem de sucesso
   - Mensagem de erro
   - Fecha automaticamente após sucesso

## 🎨 Design

### Cores
- **Verde**: Botões de ação positiva
- **Vermelho**: Botão de deletar
- **Ouro**: Estrelas selecionadas
- **Cinza**: Estrelas não selecionadas

### Animações
- ⚡ Spring animation ao selecionar estrelas
- 🔄 Pull-to-refresh na lista
- ✨ Feedback visual em botões

## 🐛 Solução de Problemas

### "Erro ao enviar avaliação"
**Causas possíveis:**
- Sem conexão com internet
- Firebase não configurado
- Regras de segurança incorretas
- Usuário não autenticado

**Solução:**
1. Verifique conexão
2. Confira Firebase Console
3. Veja logs no Xcode (prints detalhados)

### "Nenhuma avaliação ainda"
**Causas:**
- Estabelecimento não tem avaliações
- Filtros do Firebase bloqueando
- Índices não criados

**Solução:**
1. Adicione uma avaliação de teste
2. Verifique índices no Firebase

### Estrelas não aparecem douradas
**Causa:** Problema no SF Symbols

**Solução:**
- Já implementado com fallback
- Deve funcionar normalmente

## 📊 O Que Acontece no Firebase

### Quando você avalia:
```
1. Cria documento em reviews/
   └── {uuid}/
       ├── rating: 5
       ├── comment: "Ótimo!"
       ├── merchantId: "abc123"
       ├── userId: "xyz789"
       └── createdAt: timestamp

2. Atualiza merchants/abc123/
   ├── publicRating: 4.5 (recalculado)
   └── reviewsCount: 128 (incrementado)
```

## 📈 Métricas

O sistema rastreia:
- ⭐ **Média de avaliações** (publicRating)
- 💬 **Total de avaliações** (reviewsCount)
- 👤 **Quem avaliou** (userId, userName)
- 📅 **Quando avaliou** (createdAt)
- 🔄 **Última atualização** (updatedAt)

## 🚀 Próximos Passos

### Você pode adicionar:
- [ ] Fotos nas avaliações
- [ ] Filtros por estrelas (5⭐ apenas)
- [ ] Sistema de "útil" em reviews
- [ ] Resposta do estabelecimento
- [ ] Paginação (carregar mais)

### Documentação Completa:
- `README.md` - Visão geral
- `FIREBASE_SETUP.md` - Configuração Firebase
- `ARQUITETURA.md` - Estrutura técnica
- `IMPLEMENTACAO_COMPLETA.md` - Status final

## ✅ Checklist de Implementação

- [x] Modelo de dados (Review)
- [x] Repositório Firebase
- [x] View de adicionar/editar
- [x] View de listar
- [x] ViewModels
- [x] Integração com MerchantSheet
- [x] Atualização automática de métricas
- [x] Validações
- [x] Feedback visual
- [x] Documentação completa

## 🎉 Status

**✅ TUDO PRONTO PARA USAR!**

O sistema está completamente funcional. Basta configurar o Firebase e começar a usar!

---

**Dúvidas?** Consulte os outros arquivos de documentação na pasta `Features/Review/`.

