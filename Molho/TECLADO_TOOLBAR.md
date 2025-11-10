# Toolbar do Teclado - Botão "Concluir"

## O que foi implementado

Adicionado um botão "Concluir" nativo do iOS que aparece acima do teclado quando o usuário está digitando em qualquer campo de texto do formulário de criação de estabelecimento.

## Como funciona

### 1. FocusState
Utilizamos o `@FocusState` do SwiftUI para gerenciar o foco dos campos de texto:

```swift
@FocusState private var isKeyboardFocused: Bool
```

### 2. Toolbar do Teclado
Adicionamos um `ToolbarItemGroup` com placement `.keyboard`:

```swift
.toolbar {
    ToolbarItemGroup(placement: .keyboard) {
        Spacer()
        Button("Concluir") {
            isKeyboardFocused = false
        }
    }
}
```

### 3. Campos de Texto com Focus
Aplicamos o modificador `.focused()` nos campos que abrem o teclado:

- TextField do nome do estabelecimento
- TextEditor da descrição
- TextField do endereço

```swift
TextField("Nome do estabelecimento", text: $viewModel.name)
    .focused($isKeyboardFocused)
```

## Comportamento

1. Quando o usuário toca em qualquer campo de texto, o teclado aparece
2. Acima do teclado, aparece uma barra com o botão "Concluir" alinhado à direita
3. Ao tocar em "Concluir", o teclado fecha automaticamente
4. É o comportamento padrão do iOS

## Vantagens

- Nativo do iOS
- Interface familiar para os usuários
- Não requer código adicional de gerenciamento de teclado
- Funciona automaticamente com todos os campos de texto do formulário
- Melhor experiência de usuário

## Arquivo modificado

- `/Features/AddMerchant/AddMerchantView.swift`

## Exemplo Visual

```
┌─────────────────────────────────┐
│ Nome do estabelecimento         │
│ [cursor]                        │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│                    [Concluir]   │  ← Toolbar
├─────────────────────────────────┤
│  Q  W  E  R  T  Y  U  I  O  P  │
│   A  S  D  F  G  H  J  K  L    │
│    Z  X  C  V  B  N  M         │
│          [espaço]              │
└─────────────────────────────────┘
         ↑ Teclado iOS
```

## Testado em

- TextField (Nome do estabelecimento)
- TextEditor (Descrição)
- TextField (Endereço)

Todos os campos agora possuem o botão "Concluir" quando o teclado está aberto!

