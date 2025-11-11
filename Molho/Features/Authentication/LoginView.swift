import SwiftUI

struct LoginView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    enum Field: Hashable {
        case email, password
    }
    
    var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        email.contains("@")
    }
    
    var body: some View {
        ZStack {
            // Background preto
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Entrar")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Acesse sua conta")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 60)
                    
                    // Formulário
                    VStack(spacing: 16) {
                        // Email
                        LoginTextField(
                            title: "Email",
                            placeholder: "seu.email@exemplo.com",
                            text: $email,
                            focusedField: $focusedField,
                            field: .email,
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress,
                            autocapitalization: .never
                        )
                        
                        // Senha
                        LoginTextField(
                            title: "Senha",
                            placeholder: "Digite sua senha",
                            text: $password,
                            focusedField: $focusedField,
                            field: .password,
                            isSecure: true,
                            textContentType: .password
                        )
                        
                        // Validação de email
                        if !email.isEmpty && !email.contains("@") {
                            HStack(spacing: 6) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                                
                                Text("Email inválido")
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                    
                    // Botão de entrar
                    Button(action: {
                        Task {
                            await login()
                        }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .padding(.trailing, 8)
                            }
                            Text(isLoading ? "Entrando..." : "Entrar")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(isFormValid && !isLoading ? Color.white : Color.white.opacity(0.3))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                    .disabled(!isFormValid || isLoading)
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                    
                    // Mensagem de erro
                    if showError {
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.horizontal, 32)
                    }
                    
                    Spacer()
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func login() async {
        isLoading = true
        showError = false
        focusedField = nil
        
        do {
            try await authManager.signIn(email: email, password: password)
            
            await MainActor.run {
                isLoading = false
                dismiss()
            }
        } catch {
            await MainActor.run {
                isLoading = false
                showError = true
                errorMessage = authManager.errorMessage ?? "Erro ao fazer login"
            }
        }
    }
}

// MARK: - Login TextField

struct LoginTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var focusedField: FocusState<LoginView.Field?>.Binding
    let field: LoginView.Field
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType?
    var autocapitalization: TextInputAutocapitalization = .words
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .focused(focusedField, equals: field)
                        .textContentType(textContentType)
                } else {
                    TextField(placeholder, text: $text)
                        .focused(focusedField, equals: field)
                        .keyboardType(keyboardType)
                        .textContentType(textContentType)
                        .textInputAutocapitalization(autocapitalization)
                        .autocorrectionDisabled()
                }
            }
            .font(.system(size: 17))
            .foregroundColor(.white)
            .padding(16)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}

