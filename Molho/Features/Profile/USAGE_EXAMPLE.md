# Como Usar a ProfileView

Este documento mostra exemplos práticos de como integrar a tela de perfil no aplicativo.

## Exemplo 1: Botão no TopBar para abrir o perfil

```swift
import SwiftUI

struct TopBar: View {
    @State private var showProfile = false
    
    var body: some View {
        HStack {
            // Logo
            Image("molho-logo")
                .resizable()
                .scaledToFit()
                .frame(height: 32)
            
            Spacer()
            
            // Botão de Perfil
            Button(action: {
                showProfile = true
            }) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(Theme.primaryGreen)
            }
        }
        .padding(.horizontal, Theme.spacing16)
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
    }
}
```

## Exemplo 2: NavigationLink em uma Settings View

```swift
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: ProfileView()) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(Theme.primaryGreen)
                            Text("Editar Perfil")
                        }
                    }
                    
                    NavigationLink(destination: Text("Preferências")) {
                        HStack {
                            Image(systemName: "gear")
                                .foregroundColor(Theme.primaryGreen)
                            Text("Preferências")
                        }
                    }
                }
            }
            .navigationTitle("Configurações")
        }
    }
}
```

## Exemplo 3: Fluxo de Onboarding (futuro)

```swift
import SwiftUI

struct OnboardingFlow: View {
    @State private var currentStep = 0
    
    var body: some View {
        TabView(selection: $currentStep) {
            WelcomeView()
                .tag(0)
            
            ProfileView()
                .tag(1)
            
            PermissionsView()
                .tag(2)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
```

## Exemplo 4: Carregar perfil existente

```swift
import SwiftUI

struct MyProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ProfileView()
            .onAppear {
                Task {
                    // Substitua pelo ID real do Firebase Auth
                    let currentUserId = "user-123-abc"
                    await viewModel.loadProfile(userId: currentUserId)
                }
            }
    }
}
```

## Exemplo 5: Verificar se o usuário tem perfil completo

```swift
import SwiftUI

struct ContentView: View {
    @State private var showProfileSetup = false
    
    var body: some View {
        HomeView()
            .onAppear {
                Task {
                    let hasProfile = await checkIfUserHasProfile()
                    if !hasProfile {
                        showProfileSetup = true
                    }
                }
            }
            .fullScreenCover(isPresented: $showProfileSetup) {
                ProfileView()
            }
    }
    
    func checkIfUserHasProfile() async -> Bool {
        // Verificar no Firebase se o usuário já tem perfil
        #if canImport(FirebaseFirestore)
        let repository = FirebaseUserRepository()
        let userId = "current-user-id" // Obter do Firebase Auth
        
        do {
            let user = try await repository.getUser(id: userId)
            return user != nil
        } catch {
            return false
        }
        #else
        return false
        #endif
    }
}
```

## Permissões Necessárias

Para usar a funcionalidade de upload de fotos, adicione ao `Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Precisamos acessar suas fotos para você escolher um avatar</string>

<key>NSCameraUsageDescription</key>
<string>Precisamos acessar sua câmera para tirar uma foto de perfil</string>
```

## Firebase Configuration

Certifique-se de que:

1. ✅ Firebase está inicializado no `MolhoApp.swift`
2. ✅ Firestore está habilitado no console do Firebase
3. ✅ Storage está habilitado no console do Firebase
4. ✅ Regras de segurança estão configuradas (veja abaixo)

### Regras de Segurança do Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir que usuários leiam e escrevam seus próprios perfis
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Regras de Segurança do Storage

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Permitir que usuários façam upload apenas de suas próprias fotos
    match /users/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Próximos Passos

1. Integrar com Firebase Authentication para obter o `userId` real
2. Implementar fluxo de onboarding
3. Adicionar mais campos ao perfil (bio, data de nascimento, etc.)
4. Implementar edição de perfil
5. Adicionar validação de telefone brasileira

