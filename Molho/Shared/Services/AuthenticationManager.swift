import Foundation
import Combine
import AuthenticationServices
import CryptoKit

#if canImport(FirebaseAuth)
import FirebaseAuth
#endif

#if canImport(FirebaseCore)
import FirebaseCore
#endif

#if canImport(GoogleSignIn)
import GoogleSignIn
#endif

@MainActor
class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var user: FirebaseAuth.User?
    @Published var isAuthenticated = false
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?
    
    private init() {
        // Observar mudanças no estado de autenticação
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
                self?.isAuthenticated = user != nil
                self?.isLoading = false
                
                if let user = user {
                    print("✅ Usuário autenticado: \(user.email ?? "sem email")")
                } else {
                    print("❌ Usuário não autenticado")
                }
            }
        }
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    // MARK: - Email/Password Authentication
    
    func signUp(email: String, password: String, name: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Atualizar nome do usuário
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = name
            try await changeRequest.commitChanges()
            
            // Enviar email de verificação
            try await result.user.sendEmailVerification()
            
            self.user = result.user
            self.isAuthenticated = true
            self.errorMessage = nil
            
            print("✅ Conta criada com sucesso para: \(email)")
        } catch {
            self.errorMessage = handleAuthError(error)
            print("❌ Erro ao criar conta: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            self.user = result.user
            self.isAuthenticated = true
            self.errorMessage = nil
            
            print("✅ Login realizado com sucesso para: \(email)")
        } catch {
            self.errorMessage = handleAuthError(error)
            print("❌ Erro ao fazer login: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Google Sign In
    
    func signInWithGoogle() async throws {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            throw AuthError.noRootViewController
        }
        
        do {
            // Obter client ID do Firebase
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                throw AuthError.invalidConfiguration
            }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                throw AuthError.invalidToken
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )
            
            let authResult = try await Auth.auth().signIn(with: credential)
            
            self.user = authResult.user
            self.isAuthenticated = true
            self.errorMessage = nil
            
            print("✅ Login com Google realizado com sucesso")
        } catch {
            self.errorMessage = "Erro ao fazer login com Google"
            print("❌ Erro ao fazer login com Google: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Apple Sign In
    
    func signInWithApple(authorization: ASAuthorization) async throws {
        print("🍎 [1/5] Verificando credencial...")
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("🍎 ❌ Credencial inválida")
            throw AuthError.invalidCredential
        }
        print("🍎 ✅ Credencial válida. User ID: \(appleIDCredential.user)")
        
        print("🍎 [2/5] Extraindo token...")
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("🍎 ❌ Token não encontrado")
            throw AuthError.invalidToken
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("🍎 ❌ Falha ao converter token para string")
            throw AuthError.invalidToken
        }
        print("🍎 ✅ Token extraído com sucesso")
        
        print("🍎 [3/5] Nonce atual: \(currentNonce ?? "NENHUM")")
        
        do {
            print("🍎 [4/5] Criando credencial Firebase...")
            let credential = OAuthProvider.appleCredential(
                withIDToken: idTokenString,
                rawNonce: currentNonce,
                fullName: appleIDCredential.fullName
            )
            print("🍎 ✅ Credencial Firebase criada")
            
            print("🍎 [5/5] Fazendo login no Firebase...")
            let authResult = try await Auth.auth().signIn(with: credential)
            print("🍎 ✅ Login no Firebase bem-sucedido! UID: \(authResult.user.uid)")
            
            // Se tiver informações do usuário, atualizar perfil
            if let fullName = appleIDCredential.fullName {
                let displayName = [fullName.givenName, fullName.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")
                if !displayName.isEmpty {
                    print("🍎 Atualizando nome do perfil: \(displayName)")
                    let changeRequest = authResult.user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    try await changeRequest.commitChanges()
                }
            }
            
            self.user = authResult.user
            self.isAuthenticated = true
            self.errorMessage = nil
            
            print("🍎 ✅ Login com Apple realizado com sucesso!")
        } catch {
            self.errorMessage = "Erro ao fazer login com Apple"
            print("🍎 ❌ Erro ao fazer login com Apple: \(error.localizedDescription)")
            if let nsError = error as NSError? {
                print("🍎 ❌ Domínio: \(nsError.domain), Código: \(nsError.code)")
                print("🍎 ❌ Info: \(nsError.userInfo)")
            }
            throw error
        }
    }
    
    // MARK: - Sign Out
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            
            // Desconectar do Google se estiver conectado
            GIDSignIn.sharedInstance.signOut()
            
            self.user = nil
            self.isAuthenticated = false
            self.errorMessage = nil
            
            print("✅ Logout realizado com sucesso")
        } catch {
            self.errorMessage = "Erro ao fazer logout"
            print("❌ Erro ao fazer logout: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Email Verification
    
    func sendEmailVerification() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.noCurrentUser
        }
        
        try await user.sendEmailVerification()
        print("✅ Email de verificação enviado")
    }
    
    func reloadUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.noCurrentUser
        }
        
        try await user.reload()
        self.user = Auth.auth().currentUser
    }
    
    // MARK: - Helper Methods

    // Generate and hash nonce for Apple Sign In
    func prepareAppleSignInRequest(_ request: ASAuthorizationAppleIDRequest) {
        print("🍎 Preparando request do Apple Sign In...")
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        print("🍎 ✅ Nonce gerado e configurado: \(nonce.prefix(10))...")
        print("🍎 ✅ Scopes solicitados: fullName, email")
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func handleAuthError(_ error: Error) -> String {
        let nsError = error as NSError
        
        switch nsError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Este email já está em uso"
        case AuthErrorCode.invalidEmail.rawValue:
            return "Email inválido"
        case AuthErrorCode.weakPassword.rawValue:
            return "Senha muito fraca. Use pelo menos 6 caracteres"
        case AuthErrorCode.userNotFound.rawValue:
            return "Usuário não encontrado"
        case AuthErrorCode.wrongPassword.rawValue:
            return "Senha incorreta"
        case AuthErrorCode.networkError.rawValue:
            return "Erro de conexão. Verifique sua internet"
        default:
            return "Erro: \(error.localizedDescription)"
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
}

// MARK: - Auth Errors

enum AuthError: LocalizedError {
    case noRootViewController
    case invalidConfiguration
    case invalidToken
    case invalidCredential
    case noCurrentUser
    case appleSignInNotConfigured
    
    var errorDescription: String? {
        switch self {
        case .noRootViewController:
            return "Não foi possível encontrar a view controller principal"
        case .invalidConfiguration:
            return "Configuração inválida"
        case .invalidToken:
            return "Token inválido"
        case .invalidCredential:
            return "Credenciais inválidas"
        case .noCurrentUser:
            return "Nenhum usuário autenticado"
        case .appleSignInNotConfigured:
            return "Sign in with Apple não está configurado. Adicione a capability no Xcode em: Target → Signing & Capabilities → + Capability → Sign in with Apple"
        }
    }
}
