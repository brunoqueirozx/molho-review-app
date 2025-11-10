# Correção de Margins dos Textos - MerchantSheetView

## Problema identificado

Os textos na tela de estabelecimento (MerchantSheetView) estavam ultrapassando ou ficando muito próximos das bordas laterais, prejudicando a legibilidade.

## Solução aplicada

Adicionamos modificadores específicos para garantir que todos os textos:
1. Respeitem a margin de 16px nas laterais
2. Quebrem linha corretamente quando necessário
3. Não ultrapassem os limites da tela

## Modificadores utilizados

### 1. `.fixedSize(horizontal: false, vertical: true)`
Este modificador força o texto a:
- Respeitar a largura máxima disponível (horizontal: false)
- Crescer verticalmente conforme necessário (vertical: true)
- Quebrar linha automaticamente quando o texto é longo

### 2. `.multilineTextAlignment(.leading)`
Garante que textos multi-linha fiquem alinhados à esquerda de forma consistente.

### 3. `.lineLimit(1)`
Aplicado em categorias e estilos para forçar uma única linha e truncar se necessário.

### 4. `.padding(.horizontal, Theme.spacing16)`
Mantém a margin de 16px nas laterais de todas as seções.

## Textos corrigidos

### Título do estabelecimento
```swift
Text(viewModel.merchant.name)
    .font(.system(size: 28, weight: .regular))
    .fixedSize(horizontal: false, vertical: true)
    .multilineTextAlignment(.leading)
```
- Quebra linha se o nome for muito longo
- Respeita margin de 16px

### Categorias e Estilo
```swift
Text(category)
    .font(.system(size: 17))
    .lineLimit(1)

Text(style)
    .font(.system(size: 17))
    .lineLimit(1)
```
- Forçado a uma linha única
- Trunca com "..." se necessário

### Descrição
```swift
Text(description)
    .font(.system(size: 17))
    .lineSpacing(5)
    .fixedSize(horizontal: false, vertical: true)
    .multilineTextAlignment(.leading)
```
- Quebra linha automaticamente
- Mantém espaçamento entre linhas
- Respeita margins laterais de 16px

### Endereço (Localização)
```swift
Text(address)
    .font(.system(size: 17))
    .lineSpacing(5)
    .fixedSize(horizontal: false, vertical: true)
    .multilineTextAlignment(.leading)
```
- Quebra linha para endereços longos
- Mantém margem de 16px

### Horário de funcionamento
```swift
Text(String(describing: hours))
    .font(.system(size: 17))
    .fixedSize(horizontal: false, vertical: true)
    .multilineTextAlignment(.leading)
```
- Quebra linha se o horário for longo
- Mantém margem de 16px

## Estrutura de Padding

Todas as seções mantêm a seguinte estrutura:

```swift
VStack(alignment: .leading, spacing: 8) {
    // Conteúdo com textos corrigidos
}
.padding(.horizontal, Theme.spacing16)  // 16px nas laterais
.padding(.vertical, Theme.spacing16)
```

## Resultado

### Antes
```
┌─────────────────────────────────┐
│Bar do Alfredos com nome muito lo│
│O Boteco da Esquina é aquele canti│
└─────────────────────────────────┘
❌ Texto cortado nas bordas
```

### Depois
```
┌─────────────────────────────────┐
│ ← 16px                    16px→ │
│  Bar do Alfredos com     │
│  nome muito longo        │
│                                 │
│  O Boteco da Esquina é aquele  │
│  cantinho acolhedor do sente   │
│  em casa. Com um cardápio...   │
└─────────────────────────────────┘
✅ Texto com margin e quebra adequada
```

## Checklist de correções

- [x] Título do estabelecimento quebra linha
- [x] Categorias e estilos limitados a 1 linha
- [x] Descrição quebra linha automaticamente
- [x] Endereço quebra linha quando longo
- [x] Horário quebra linha se necessário
- [x] Todas as seções com padding de 16px
- [x] Alinhamento à esquerda consistente
- [x] Espaçamento entre linhas mantido

## Arquivo modificado

- `/Features/Merchant/MerchantSheetView.swift`

## Comportamento garantido

1. Nenhum texto ultrapassa as margens de 16px
2. Textos longos quebram linha automaticamente
3. Layout responsivo para diferentes tamanhos de tela
4. Legibilidade melhorada
5. Interface profissional e polida

## Testado em

- iPhone SE (tela pequena)
- iPhone 15 Pro (tela média)
- iPhone 15 Pro Max (tela grande)

Todos os textos agora respeitam os limites e ficam perfeitamente legíveis!

