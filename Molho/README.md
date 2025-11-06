# Molho (iOS · SwiftUI · iOS 17+)

Arquitetura inicial com SwiftUI + MVVM leve, MapKit e integração preparada para Firebase (Auth + Firestore) via SPM.

## Estrutura

- `App/` → `MolhoApp.swift`, `AppDelegate.swift`
- `Resources/` → `Assets.xcassets`, `GoogleService-Info.plist` (placeholder)
- `Features/Home/` → `HomeView.swift`, `HomeViewModel.swift`, `TopBar.swift`, `BottomBar.swift`, `MapContainerView.swift`
- `Features/Search/` → `SearchView.swift`, `SearchViewModel.swift`
- `Features/Merchant/` → `MerchantSheetView.swift`, `MerchantViewModel.swift`
- `Shared/Models/` → `Merchant.swift`
- `Shared/Theme/` → `Theme.swift`
- `Shared/Repositories/` → `MerchantRepository.swift` (protocolo + stub)

## Requisitos
- Xcode 15+ (iOS 17+)
- SwiftUI, MapKit

## Firebase via SPM
1. No Xcode, Project > Package Dependencies > `+` e adicione `https://github.com/firebase/firebase-ios-sdk`.
2. Selecione os produtos mínimos: `FirebaseAuth`, `FirebaseFirestore`, `FirebaseCore`.
3. Em `Signing & Capabilities`, garanta que o app bundle está correto.

> Observação: O código usa `#if canImport(FirebaseCore)` para compilar mesmo sem o pacote instalado. Quando o pacote for adicionado, `FirebaseApp.configure()` será chamado pelo `AppDelegate`.

## GoogleService-Info.plist
- Adicione seu arquivo real em `Resources/GoogleService-Info.plist`.
- O projeto inclui um placeholder. Substitua-o pelo arquivo gerado no console do Firebase.

## Região inicial do mapa
- Ajuste em `Features/Home/HomeView.swift` a `MKCoordinateRegion` inicial (Pinheiros/SP por padrão `-23.56, -46.68`).

## Abrir o Merchant Sheet
- Na `Home`, toque no botão de debug (ícone `chevron.right` flutuante no mapa) para abrir o bottom sheet nativo (`.medium`, `.large`).

## Firebase Firestore - Back-end

O app está preparado para usar Firebase Firestore como back-end. Veja `FIREBASE_SETUP.md` para instruções detalhadas.

### Estrutura de Dados
- **Coleção**: `merchants`
- **Modelo**: Veja `Shared/Models/Merchant.swift` para a estrutura completa
- **Repositório**: `FirebaseMerchantRepository` implementa `MerchantRepository`

### Para usar o Firebase:
1. Adicione o Firebase SDK via SPM (FirebaseFirestore)
2. Configure o `GoogleService-Info.plist`
3. Configure as regras do Firestore (veja `scripts/firestore_rules.txt`)
4. Substitua `MerchantRepositoryStub()` por `FirebaseMerchantRepository()` nos ViewModels

### Exemplo de uso:
```swift
// No ViewModel
let repository: MerchantRepository = FirebaseMerchantRepository()
let merchants = repository.searchMerchants(query: "Bar")
```

## Critérios de aceite
- Home exibe TopBar ("Molho", ícones `cart` e `plus`), mapa preenchendo a tela, BottomBar com 3 ícones.
- Search acessível pela BottomBar (sem navegação complexa, apenas troca de conteúdo).
- MerchantSheet abre com conteúdo completo conforme Figma.
- Firebase preparado (imports e `FirebaseApp.configure()` condicionais).
- Repositórios Firebase implementados e prontos para uso.


