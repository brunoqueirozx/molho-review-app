import SwiftUI

#if canImport(FirebaseAuth)
import FirebaseAuth
#endif

struct AddReviewView: View {
    let merchant: Merchant
    @StateObject private var viewModel: AddReviewViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    
    init(merchant: Merchant) {
        self.merchant = merchant
        _viewModel = StateObject(wrappedValue: AddReviewViewModel(merchant: merchant))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(alignment: .center, spacing: Theme.spacing24) {
                        // Título centralizado
                        Text("Avaliar \(merchant.name)")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color(hex: "#1f1f1f"))
                            .multilineTextAlignment(.center)
                            .padding(.top, Theme.spacing16)
                        
                        // Seletor de estrelas
                        VStack(alignment: .center, spacing: Theme.spacing16) {
                            HStack(spacing: Theme.spacing16) {
                                ForEach(1...5, id: \.self) { star in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3)) {
                                            viewModel.rating = star
                                        }
                                    }) {
                                        Image(systemName: star <= viewModel.rating ? "star.fill" : "star")
                                            .font(.system(size: 36))
                                            .foregroundStyle(
                                                star <= viewModel.rating
                                                    ? Color(hex: "#FFD700")
                                                    : Color.gray.opacity(0.3)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.vertical, Theme.spacing8)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Campo de comentário
                        VStack(alignment: .leading, spacing: Theme.spacing8) {
                            Text("Comentário (opcional)")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Color(hex: "#1f1f1f"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ZStack(alignment: .topLeading) {
                                if viewModel.comment.isEmpty {
                                    Text("Compartilhe sua experiência...")
                                        .font(.system(size: 17))
                                        .foregroundStyle(Color.gray.opacity(0.5))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 12)
                                }
                                
                                TextEditor(text: $viewModel.comment)
                                    .font(.system(size: 17))
                                    .foregroundStyle(Color(hex: "#1f1f1f"))
                                    .frame(minHeight: 120)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 8)
                                    .scrollContentBackground(.hidden)
                            }
                            .background(Color(hex: "#F5F5F5"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Mensagens de erro/sucesso
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 15))
                                .foregroundStyle(.red)
                                .padding(.horizontal, Theme.spacing16)
                                .padding(.vertical, Theme.spacing8)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        if let successMessage = viewModel.successMessage {
                            Text(successMessage)
                                .font(.system(size: 15))
                                .foregroundStyle(Theme.primaryGreen)
                                .padding(.horizontal, Theme.spacing16)
                                .padding(.vertical, Theme.spacing8)
                                .background(Theme.primaryGreen.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        // Botões de ação
                        VStack(spacing: Theme.spacing12) {
                            // Botão enviar/atualizar
                            Button(action: {
                                Task {
                                    guard let user = authManager.user else { return }
                                    
                                    await viewModel.submitReview(
                                        userId: user.uid,
                                        userName: user.displayName ?? "Usuário",
                                        userAvatarUrl: user.photoURL?.absoluteString
                                    )
                                    
                                    // Aguardar um pouco para mostrar mensagem de sucesso
                                    if viewModel.successMessage != nil {
                                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                                        dismiss()
                                    }
                                }
                            }) {
                                HStack {
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    } else {
                                        Text(viewModel.isEditing ? "Atualizar avaliação" : "Enviar avaliação")
                                            .font(.system(size: 17, weight: .semibold))
                                    }
                                }
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(viewModel.canSubmit ? Theme.primaryGreen : Color.gray.opacity(0.5))
                                .cornerRadius(Theme.corner12)
                            }
                            .disabled(!viewModel.canSubmit)
                            
                            // Botão deletar (apenas se estiver editando)
                            if viewModel.isEditing {
                                Button(action: {
                                    Task {
                                        await viewModel.deleteReview()
                                        
                                        // Aguardar um pouco para mostrar mensagem de sucesso
                                        if viewModel.successMessage != nil {
                                            try? await Task.sleep(nanoseconds: 1_500_000_000)
                                            dismiss()
                                        }
                                    }
                                }) {
                                    Text("Remover avaliação")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(.red)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 52)
                                        .background(Color.red.opacity(0.1))
                                        .cornerRadius(Theme.corner12)
                                }
                                .disabled(viewModel.isLoading)
                            }
                        }
                        .padding(.top, Theme.spacing16)
                    }
                    .padding(.horizontal, Theme.spacing16)
                    .padding(.bottom, Theme.spacing24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(hex: "#1f1f1f"))
                    }
                }
            }
            .task {
                // Carregar avaliação existente do usuário
                if let userId = authManager.user?.uid {
                    await viewModel.loadExistingReview(userId: userId)
                }
            }
        }
    }
}

#Preview {
    AddReviewView(merchant: Merchant(
        id: "1",
        name: "Restaurante Exemplo",
        latitude: 0,
        longitude: 0
    ))
    .environmentObject(AuthenticationManager.shared)
}

