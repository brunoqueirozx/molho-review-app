# Guia de Migração para Firebase

Este guia explica como migrar do repositório stub para o Firebase Firestore.

## Passo 1: Adicionar Firebase SDK

1. No Xcode, vá em **File > Add Package Dependencies**
2. Adicione: `https://github.com/firebase/firebase-ios-sdk`
3. Selecione os produtos:
   - `FirebaseFirestore`
   - `FirebaseCore`
   - `FirebaseAuth` (opcional, se for usar autenticação)

## Passo 2: Configurar Firestore no Console

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Crie um novo projeto ou selecione um existente
3. Vá em **Firestore Database** > **Create database**
4. Escolha **Start in test mode** (ou configure as regras manualmente)
5. Copie as regras de `scripts/firestore_rules.txt` para o Firestore Rules

## Passo 3: Adicionar GoogleService-Info.plist

1. No Firebase Console, vá em **Project Settings** > **Your apps**
2. Adicione um app iOS (se ainda não tiver)
3. Baixe o `GoogleService-Info.plist`
4. Adicione ao projeto Xcode em `Resources/GoogleService-Info.plist`

## Passo 4: Atualizar ViewModels

Substitua o repositório stub pelo Firebase:

### Antes:
```swift
let repository: MerchantRepository = MerchantRepositoryStub()
```

### Depois:
```swift
let repository: MerchantRepository = FirebaseMerchantRepository()
```

### Arquivos para atualizar:
- `Features/Home/HomeViewModel.swift`
- `Features/Search/SearchViewModel.swift`
- Qualquer outro ViewModel que use `MerchantRepository`

## Passo 5: Popular o Firestore (Opcional)

Use o script `scripts/populate_firestore.js` para adicionar dados de exemplo:

```bash
cd scripts
npm install firebase-admin
node populate_firestore.js
```

Ou adicione manualmente pelo Firebase Console.

## Passo 6: Testar

1. Rode o app
2. Verifique se os merchants aparecem na tela de busca
3. Verifique se o MerchantSheet abre corretamente

## Troubleshooting

### Erro: "Firebase not configured"
- Verifique se o `GoogleService-Info.plist` está no projeto
- Verifique se `FirebaseApp.configure()` está sendo chamado no `AppDelegate`

### Erro: "Permission denied"
- Verifique as regras do Firestore no console
- Certifique-se de que as regras permitem leitura pública

### Nenhum dado aparece
- Verifique se há documentos na coleção `merchants` no Firestore
- Verifique os logs do console para erros
- Use o repositório stub temporariamente para debug

## Estrutura de Dados Esperada

Veja `FIREBASE_SETUP.md` para a estrutura completa de um documento Merchant.

## Próximos Passos

1. Implementar busca geográfica (GeoFirestore)
2. Adicionar cache local
3. Implementar paginação
4. Adicionar upload de imagens para Firebase Storage

