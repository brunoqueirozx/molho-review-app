import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isKeyboardFocused: Bool
    
    var body: some View {
        ZStack {
            // Fundo
            Color(hex: "#FFF")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Barra de navegação customizada
                HStack {
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancelar")
                            .font(.system(size: 17))
                            .foregroundColor(Theme.primaryGreen)
                    }
                }
                .padding(.horizontal, Theme.spacing16)
                .padding(.vertical, Theme.spacing12)
                .background(Color(hex: "#FFF"))
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Carregando perfil...")
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: Theme.spacing24) {
                            // MARK: - Header
                            VStack(spacing: Theme.spacing16) {
                                Text("Perfil do Usuário")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                                    .padding(.top, Theme.spacing24)
                                
                                // MARK: - Avatar
                                AvatarPickerView(
                                    avatarImage: $viewModel.avatarImage,
                                    selectedItem: $viewModel.selectedAvatarItem
                                )
                                .onChange(of: viewModel.selectedAvatarItem) { _ in
                                    Task {
                                        await viewModel.loadAvatarImage()
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.spacing16)
                            
                            // MARK: - Formulário
                            VStack(spacing: Theme.spacing16) {
                                // Nome
                                FormFieldView(
                                    title: "Nome",
                                    placeholder: "Seu nome completo",
                                    text: $viewModel.name,
                                    isKeyboardFocused: $isKeyboardFocused
                                )
                                
                                // ID do usuário (somente leitura)
                                FormFieldView(
                                    title: "ID do Usuário",
                                    placeholder: "ID gerado automaticamente",
                                    text: .constant(viewModel.userId),
                                    isKeyboardFocused: $isKeyboardFocused,
                                    isReadOnly: true
                                )
                                
                                // Email
                                FormFieldView(
                                    title: "Email",
                                    placeholder: "seu.email@exemplo.com",
                                    text: $viewModel.email,
                                    isKeyboardFocused: $isKeyboardFocused,
                                    keyboardType: .emailAddress,
                                    autocapitalization: .never
                                )
                                
                                // Telefone
                                FormFieldView(
                                    title: "Telefone",
                                    placeholder: "(11) 98765-4321",
                                    text: $viewModel.phone,
                                    isKeyboardFocused: $isKeyboardFocused,
                                    keyboardType: .phonePad
                                )
                            }
                            .padding(.horizontal, Theme.spacing16)
                            
                            // MARK: - Botão Salvar
                            VStack(spacing: Theme.spacing12) {
                                if let errorMessage = viewModel.validationMessage, !viewModel.isFormValid {
                                    Text(errorMessage)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .padding(.horizontal, Theme.spacing16)
                                }
                                
                                if let saveError = viewModel.saveError {
                                    Text(saveError)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .padding(.horizontal, Theme.spacing16)
                                }
                                
                                Button(action: {
                                    Task {
                                        let success = await viewModel.saveProfile()
                                        if success {
                                            dismiss()
                                        }
                                    }
                                }) {
                                    HStack {
                                        if viewModel.isSaving {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                                .padding(.trailing, 8)
                                        }
                                        Text(viewModel.isSaving ? "Salvando..." : "Salvar Perfil")
                                            .font(.system(size: 17, weight: .semibold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, Theme.spacing16)
                                    .background(viewModel.isFormValid && !viewModel.isSaving ? Theme.primaryGreen : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(Theme.corner12)
                                }
                                .disabled(!viewModel.isFormValid || viewModel.isSaving)
                                .padding(.horizontal, Theme.spacing16)
                                
                                // MARK: - Botão Logout
                                Button(action: {
                                    Task {
                                        do {
                                            try AuthenticationManager.shared.signOut()
                                            dismiss()
                                        } catch {
                                            print("Erro ao fazer logout: \(error)")
                                        }
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                            .font(.system(size: 17))
                                        
                                        Text("Sair da Conta")
                                            .font(.system(size: 17, weight: .semibold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, Theme.spacing16)
                                    .background(Color.red.opacity(0.1))
                                    .foregroundColor(.red)
                                    .cornerRadius(Theme.corner12)
                                }
                                .padding(.horizontal, Theme.spacing16)
                            }
                            .padding(.bottom, Theme.spacing24)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Avatar Picker View

struct AvatarPickerView: View {
    @Binding var avatarImage: UIImage?
    @Binding var selectedItem: PhotosPickerItem?
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            ZStack(alignment: .bottomTrailing) {
                // Avatar circular
                if let image = avatarImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Theme.primaryGreen, lineWidth: 3)
                        )
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.gray)
                        )
                        .overlay(
                            Circle()
                                .stroke(Theme.primaryGreen, lineWidth: 3)
                        )
                }
                
                // Botão de editar
                Circle()
                    .fill(Theme.primaryGreen)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    )
                    .offset(x: 4, y: 4)
            }
        }
    }
}

// MARK: - Form Field View

struct FormFieldView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isKeyboardFocused: FocusState<Bool>.Binding?
    var isReadOnly: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .words
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.textSecondary)
            
            if isReadOnly {
                Text(text.isEmpty ? placeholder : text)
                    .font(.system(size: 17))
                    .foregroundColor(text.isEmpty ? .gray : Theme.textPrimary)
                    .padding(Theme.spacing12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(Theme.corner12)
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 17))
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
                    .autocorrectionDisabled()
                    .padding(Theme.spacing12)
                    .background(Color.white)
                    .cornerRadius(Theme.corner12)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.corner12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ProfileView()
}

