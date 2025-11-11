import SwiftUI

struct SignUpView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showVerificationAlert = false
    
    enum Field: Hashable {
        case name, email, password, confirmPassword
    }
    
    var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password.count >= 6 &&
        password == confirmPassword &&
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
                        Text("Criar Conta")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Preencha os dados abaixo")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 40)
                    
                    // Formulário
                    VStack(spacing: 16) {
                        // Nome
                        AuthTextField(
                            title: "Nome Completo",
                            placeholder: "Digite seu nome",
                            text: $name,
                            focusedField: $focusedField,
                            field: .name,
                            keyboardType: .default,
                            textContentType: .name
                        )
                        
                        // Email
                        AuthTextField(
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
                        AuthTextField(
                            title: "Senha",
                            placeholder: "Mínimo 6 caracteres",
                            text: $password,
                            focusedField: $focusedField,
                            field: .password,
                            isSecure: true,
                            textContentType: .newPassword
                        )
                        
                        // Confirmar senha
                        AuthTextField(
                            title: "Confirmar Senha",
                            placeholder: "Digite a senha novamente",
                            text: $confirmPassword,
                            focusedField: $focusedField,
                            field: .confirmPassword,
                            isSecure: true,
                            textContentType: .newPassword
                        )
                        
                        // Validações
                        VStack(alignment: .leading, spacing: 8) {
                            if !password.isEmpty && password.count < 6 {
                                ValidationText(text: "A senha deve ter pelo menos 6 caracteres", isValid: false)
                            }
                            
                            if !confirmPassword.isEmpty && password != confirmPassword {
                                ValidationText(text: "As senhas não coincidem", isValid: false)
                            }
                            
                            if !email.isEmpty && !email.contains("@") {
                                ValidationText(text: "Email inválido", isValid: false)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                    
                    // Botão de criar conta
                    Button(action: {
                        Task {
                            await createAccount()
                        }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .padding(.trailing, 8)
                            }
                            Text(isLoading ? "Criando conta..." : "Criar Conta")
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
        .alert("Email de Verificação Enviado", isPresented: $showVerificationAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Enviamos um email de verificação para \(email). Por favor, verifique sua caixa de entrada e clique no link para confirmar sua conta.")
        }
    }
    
    private func createAccount() async {
        isLoading = true
        showError = false
        focusedField = nil
        
        do {
            try await authManager.signUp(email: email, password: password, name: name)
            
            // Mostrar alerta de verificação
            await MainActor.run {
                isLoading = false
                showVerificationAlert = true
            }
        } catch {
            await MainActor.run {
                isLoading = false
                showError = true
                errorMessage = authManager.errorMessage ?? "Erro ao criar conta"
            }
        }
    }
}

// MARK: - Auth TextField

struct AuthTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var focusedField: FocusState<SignUpView.Field?>.Binding
    let field: SignUpView.Field
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

// MARK: - Validation Text

struct ValidationText: View {
    let text: String
    let isValid: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(isValid ? .green : .red)
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(isValid ? .green : .red)
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}

