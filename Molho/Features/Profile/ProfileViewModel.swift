import Foundation
import SwiftUI
import PhotosUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    // Campos do usuário
    @Published var userId: String = ""
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var avatarImage: UIImage?
    @Published var avatarUrl: String?
    
    // PhotosPicker
    @Published var selectedAvatarItem: PhotosPickerItem?
    
    // Estado de carregamento
    @Published var isLoading: Bool = false
    @Published var isSaving: Bool = false
    @Published var saveError: String?
    @Published var saveSuccess: Bool = false
    
    // Estado de edição
    @Published var isEditMode: Bool = true
    @Published var hasProfileData: Bool = false
    
    // Repositórios e serviços
    #if canImport(FirebaseFirestore)
    private let userRepository = FirebaseUserRepository()
    #endif
    #if canImport(FirebaseStorage)
    private let storageService = FirebaseStorageService()
    #endif
    
    // MARK: - Inicialização
    
    init() {
        Task {
            await loadCurrentUserProfile()
        }
    }
    
    // MARK: - Carregar perfil do usuário autenticado
    
    func loadCurrentUserProfile() async {
        isLoading = true
        
        #if canImport(FirebaseAuth)
        // Obter usuário atual do Firebase Auth
        if let currentUser = AuthenticationManager.shared.user {
            self.userId = currentUser.uid
            
            // Tentar carregar dados do Firestore
            #if canImport(FirebaseFirestore)
            do {
                if let user = try await userRepository.getUser(id: currentUser.uid) {
                    self.name = user.name
                    self.email = user.email
                    self.phone = user.phone
                    self.avatarUrl = user.avatarUrl
                    
                    // Se houver avatar URL, carregar a imagem
                    if let urlString = user.avatarUrl, let url = URL(string: urlString) {
                        await loadAvatarFromURL(url)
                    }
                    
                    hasProfileData = true
                    isEditMode = false // Dados já salvos, modo visualização
                } else {
                    // Novo usuário, usar dados do Firebase Auth
                    self.name = currentUser.displayName ?? ""
                    self.email = currentUser.email ?? ""
                    hasProfileData = false
                    isEditMode = true // Novo usuário, modo edição
                }
            } catch {
                print("❌ Erro ao carregar perfil: \(error)")
                // Usar dados do Firebase Auth
                self.name = currentUser.displayName ?? ""
                self.email = currentUser.email ?? ""
                hasProfileData = false
                isEditMode = true
            }
            #else
            self.name = currentUser.displayName ?? ""
            self.email = currentUser.email ?? ""
            hasProfileData = false
            isEditMode = true
            #endif
        }
        #endif
        
        isLoading = false
    }
    
    // MARK: - Validação
    
    var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !phone.isEmpty &&
        isValidEmail(email)
    }
    
    var validationMessage: String? {
        if name.isEmpty {
            return "O nome é obrigatório"
        }
        if email.isEmpty {
            return "O email é obrigatório"
        }
        if !isValidEmail(email) {
            return "Email inválido"
        }
        if phone.isEmpty {
            return "O telefone é obrigatório"
        }
        return nil
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Carregar Avatar
    
    func loadAvatarImage() async {
        guard let item = selectedAvatarItem else { return }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                avatarImage = image
            }
        } catch {
            print("❌ Erro ao carregar imagem do avatar: \(error)")
        }
    }
    
    // MARK: - Carregar Perfil Existente
    
    func loadProfile(userId: String) async {
        isLoading = true
        
        #if canImport(FirebaseFirestore)
        do {
            if let user = try await userRepository.getUser(id: userId) {
                self.userId = user.id
                self.name = user.name
                self.email = user.email
                self.phone = user.phone
                self.avatarUrl = user.avatarUrl
                
                // Se houver avatar URL, carregar a imagem
                if let urlString = user.avatarUrl, let url = URL(string: urlString) {
                    await loadAvatarFromURL(url)
                }
            }
        } catch {
            print("❌ Erro ao carregar perfil: \(error)")
            saveError = "Erro ao carregar perfil: \(error.localizedDescription)"
        }
        #endif
        
        isLoading = false
    }
    
    private func loadAvatarFromURL(_ url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                avatarImage = image
            }
        } catch {
            print("❌ Erro ao carregar imagem do avatar da URL: \(error)")
        }
    }
    
    // MARK: - Salvar Perfil
    
    func saveProfile() async -> Bool {
        guard isFormValid else {
            saveError = validationMessage
            return false
        }
        
        isSaving = true
        saveError = nil
        
        #if canImport(FirebaseFirestore) && canImport(FirebaseStorage)
        do {
            // 1. Se houver uma nova imagem de avatar, fazer upload
            var newAvatarUrl = avatarUrl
            
            if let avatarImg = avatarImage {
                print("🔄 Fazendo upload do avatar...")
                
                // Deletar avatar antigo se existir
                if let oldUrl = avatarUrl, !oldUrl.isEmpty {
                    do {
                        try await storageService.deleteAvatar(url: oldUrl)
                        print("🗑️ Avatar antigo deletado")
                    } catch {
                        print("⚠️ Não foi possível deletar avatar antigo: \(error)")
                    }
                }
                
                // Upload do novo avatar
                newAvatarUrl = try await storageService.uploadAvatar(avatarImg, userId: userId)
                print("✅ Avatar uploaded: \(newAvatarUrl ?? "nil")")
            }
            
            // 2. Criar ou atualizar usuário
            let user = User(
                id: userId,
                name: name,
                email: email,
                phone: phone,
                avatarUrl: newAvatarUrl,
                createdAt: Date(), // Será ignorado em updates
                updatedAt: Date()
            )
            
            print("🔄 Salvando perfil no Firestore...")
            
            // Verificar se o usuário já existe
            let existingUser = try await userRepository.getUser(id: userId)
            
            if existingUser != nil {
                // Atualizar
                try await userRepository.updateUser(user)
                print("✅ Perfil atualizado com sucesso!")
            } else {
                // Criar novo
                try await userRepository.createUser(user)
                print("✅ Perfil criado com sucesso!")
            }
            
            // Atualizar avatarUrl local
            self.avatarUrl = newAvatarUrl
            
            isSaving = false
            saveSuccess = true
            hasProfileData = true
            isEditMode = false // Desabilitar edição após salvar
            
            return true
            
        } catch {
            print("❌ Erro ao salvar perfil: \(error)")
            saveError = "Erro ao salvar: \(error.localizedDescription)"
            isSaving = false
            return false
        }
        #else
        saveError = "Firebase não está configurado"
        isSaving = false
        return false
        #endif
    }
    
    // MARK: - Limpar Avatar
    
    func clearAvatar() {
        avatarImage = nil
        selectedAvatarItem = nil
    }
    
    // MARK: - Habilitar Edição
    
    func enableEditMode() {
        isEditMode = true
    }
    
    func cancelEdit() {
        Task {
            await loadCurrentUserProfile()
        }
    }
}

