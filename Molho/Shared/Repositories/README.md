# Repositórios - Merchant

Este diretório contém as implementações dos repositórios para acessar dados de merchants.

## Estrutura

- `MerchantRepository.swift` - Protocolo e implementação stub (mock)
- `FirebaseMerchantRepository.swift` - Implementação usando Firebase Firestore (síncrona)
- `FirebaseMerchantRepositoryAsync.swift` - Implementação usando Firebase Firestore (assíncrona, iOS 15+)

## Uso

### Repositório Stub (Desenvolvimento/Testes)
```swift
let repository: MerchantRepository = MerchantRepositoryStub()
let merchants = repository.searchMerchants(query: "Bar")
```

### Repositório Firebase (Produção - Síncrono)
```swift
let repository: MerchantRepository = FirebaseMerchantRepository()
let merchants = repository.searchMerchants(query: "Bar")
```

### Repositório Firebase (Produção - Assíncrono, iOS 15+)
```swift
let repository = FirebaseMerchantRepositoryAsync()

// Em uma função async
func loadMerchants() async {
    do {
        let merchants = try await repository.searchMerchantsAsync(query: "Bar")
        // Use os merchants
    } catch {
        print("Erro: \(error)")
    }
}
```

## Migração

Para migrar do stub para Firebase, veja `FIREBASE_MIGRATION.md` na raiz do projeto.

