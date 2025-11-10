# Margins Corrigidas - Tela do Estabelecimento

## O que foi corrigido

A tela MerchantSheetView agora possui:
- Margin de 16px em todo o conteúdo
- Scroll horizontal dos chips ultrapassa as margens (como solicitado)
- Galeria de fotos com padding correto
- Dividers respeitando as margens
- Textos não ultrapassam mais os limites da tela

## Áreas com Margin de 16px

### 1. Título e Informações
- Nome do estabelecimento
- Categorias (tipo e estilo)
- Métricas (estrela, comentários, visualizações, bookmarks)
- Descrição

### 2. Seção Localização
- Título "Localização"
- Endereço completo

### 3. Seção Horário
- Título "Horário de funcionamento"
- Status (Aberto/Fechado)
- Horários

### 4. Dividers
- Todas as linhas horizontais respeitam a margem

### 5. Galeria de Fotos
- Título com padding
- Grid de fotos com spacers laterais

## Scroll Horizontal (SEM margem no container)

O scroll horizontal dos chips ultrapassa as margens como solicitado.
O padding é aplicado DENTRO do HStack do scroll, permitindo que o scroll seja livre.

## Resultado

Todos os textos agora respeitam uma margem de 16px e não ultrapassam os limites da tela.
O scroll horizontal dos chips pode ultrapassar livremente esse limite.

