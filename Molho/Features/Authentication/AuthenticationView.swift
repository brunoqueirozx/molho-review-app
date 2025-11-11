import SwiftUI
import AuthenticationServices

struct AuthenticationView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var showSignUp = false
    @State private var showLogin = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background preto
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Logo
                    Image("molho-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    
                    // Título
                    VStack(spacing: 8) {
                        Text("Bem-vindo ao Molho")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Encontre os melhores estabelecimentos")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    // Botões de autenticação
                    VStack(spacing: 16) {
                        // Sign in with Apple
                        SignInWithAppleButton(
                            onRequest: { request in
                                authManager.prepareAppleSignInRequest(request)
                            },
                            onCompletion: { result in
                                Task {
                                    await handleAppleSignIn(result: result)
                                }
                            }
                        )
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 50)
                        .cornerRadius(12)
                        
                        // Sign in with Google
                        Button(action: {
                            Task {
                                do {
                                    try await authManager.signInWithGoogle()
                                } catch {
                                    print("Erro ao fazer login com Google: \(error)")
                                }
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "g.circle.fill")
                                    .font(.system(size: 20))
                                
                                Text("Continuar com Google")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                        }
                        
                        // Sign in with Email
                        Button(action: {
                            showSignUp = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 20))
                                
                                Text("Criar conta com Email")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                        }
                        
                        // Já tem conta?
                        Button(action: {
                            showLogin = true
                        }) {
                            Text("Já tem uma conta? Entrar")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.9))
                                .underline()
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                }
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
            .navigationDestination(isPresented: $showLogin) {
                LoginView()
            }
            .alert("Erro no Login", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func handleAppleSignIn(result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let authorization):
            do {
                print("🍎 Iniciando login com Apple...")
                try await authManager.signInWithApple(authorization: authorization)
                print("🍎 ✅ Login com Apple bem-sucedido!")
            } catch {
                await MainActor.run {
                    print("🍎 ❌ Erro no login com Apple: \(error.localizedDescription)")
                    errorMessage = authManager.errorMessage ?? "Erro ao fazer login com Apple: \(error.localizedDescription)"
                    showError = true
                }
            }
        case .failure(let error):
            await MainActor.run {
                // Se o usuário cancelou, não mostrar erro
                let nsError = error as NSError
                if nsError.domain == "com.apple.AuthenticationServices.AuthorizationError" && nsError.code == 1001 {
                    print("🍎 Login com Apple cancelado pelo usuário")
                    return
                }
                
                print("🍎 ❌ Falha na autorização com Apple: \(error.localizedDescription)")
                errorMessage = "Erro ao fazer login com Apple: \(error.localizedDescription)"
                showError = true
            }
        }
    }
}

#Preview {
    AuthenticationView()
}

