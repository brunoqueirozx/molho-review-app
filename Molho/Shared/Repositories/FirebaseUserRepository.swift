import Foundation

#if canImport(FirebaseFirestore)
import FirebaseFirestore

final class FirebaseUserRepository: UserRepository {
    private let db = Firestore.firestore()
    private let collectionName = "users"
    
    // MARK: - Métodos do Protocol
    
    func getUser(id: String) async throws -> User? {
        print("🔍 Buscando usuário com ID: \(id)")
        
        let document = try await db.collection(collectionName).document(id).getDocument()
        
        guard document.exists else {
            print("⚠️ Usuário com ID \(id) não encontrado")
            return nil
        }
        
        let user = try decodeUser(from: document)
        print("✅ Usuário '\(user.name)' carregado com sucesso")
        return user
    }
    
    func createUser(_ user: User) async throws {
        print("📝 Criando novo usuário: \(user.name)")
        
        var newUser = user
        newUser.createdAt = Date()
        newUser.updatedAt = Date()
        
        let data = try encodeUser(newUser)
        try await db.collection(collectionName).document(user.id).setData(data)
        
        print("✅ Usuário criado com sucesso")
    }
    
    func updateUser(_ user: User) async throws {
        print("🔄 Atualizando usuário: \(user.name)")
        
        var updatedUser = user
        updatedUser.updatedAt = Date()
        
        let data = try encodeUser(updatedUser)
        try await db.collection(collectionName).document(user.id).setData(data, merge: true)
        
        print("✅ Usuário atualizado com sucesso")
    }
    
    func deleteUser(id: String) async throws {
        print("🗑️ Deletando usuário com ID: \(id)")
        
        try await db.collection(collectionName).document(id).delete()
        
        print("✅ Usuário deletado com sucesso")
    }
    
    // MARK: - Métodos auxiliares
    
    /// Converte URLs do Firebase Storage (gs://) para URLs HTTP públicas
    private func convertStorageUrl(_ gsUrl: String) -> String {
        // Se já é uma URL HTTP, retorna como está
        if gsUrl.hasPrefix("http://") || gsUrl.hasPrefix("https://") {
            return gsUrl
        }
        
        // Se é uma URL gs://, converte para HTTP
        if gsUrl.hasPrefix("gs://") {
            let withoutPrefix = gsUrl.replacingOccurrences(of: "gs://", with: "")
            
            if let firstSlashIndex = withoutPrefix.firstIndex(of: "/") {
                let bucket = String(withoutPrefix[..<firstSlashIndex])
                let path = String(withoutPrefix[firstSlashIndex...].dropFirst())
                
                var allowedCharacters = CharacterSet.alphanumerics
                allowedCharacters.insert(charactersIn: "-_.~")
                let encodedPath = path.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? path
                
                return "https://firebasestorage.googleapis.com/v0/b/\(bucket)/o/\(encodedPath)?alt=media"
            }
        }
        
        return gsUrl
    }
    
    private func decodeUser(from document: DocumentSnapshot) throws -> User {
        guard let data = document.data() else {
            throw RepositoryError.documentDataNotFound
        }
        
        // Converter Timestamp para Date
        var processedData: [String: Any] = [:]
        
        for (key, value) in data {
            if let timestamp = value as? Timestamp {
                processedData[key] = timestamp.dateValue().timeIntervalSince1970
            } else {
                processedData[key] = value
            }
        }
        
        // Converter avatar URL se necessário
        var avatarUrl: String? = nil
        if let avatar = processedData["avatarUrl"] as? String {
            avatarUrl = convertStorageUrl(avatar)
        }
        
        // Garantir que campos obrigatórios existam
        guard let name = processedData["name"] as? String,
              let email = processedData["email"] as? String,
              let phone = processedData["phone"] as? String else {
            throw RepositoryError.missingRequiredFields
        }
        
        return User(
            id: document.documentID,
            name: name,
            email: email,
            phone: phone,
            avatarUrl: avatarUrl,
            createdAt: decodeDateFromProcessed(processedData["createdAt"]),
            updatedAt: decodeDateFromProcessed(processedData["updatedAt"])
        )
    }
    
    private func encodeUser(_ user: User) throws -> [String: Any] {
        var data: [String: Any] = [
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "phone": user.phone
        ]
        
        if let avatarUrl = user.avatarUrl {
            data["avatarUrl"] = avatarUrl
        }
        
        if let createdAt = user.createdAt {
            data["createdAt"] = Timestamp(date: createdAt)
        }
        
        if let updatedAt = user.updatedAt {
            data["updatedAt"] = Timestamp(date: updatedAt)
        }
        
        return data
    }
    
    private func decodeDateFromProcessed(_ value: Any?) -> Date? {
        guard let value = value else { return nil }
        
        if let interval = value as? TimeInterval {
            return Date(timeIntervalSince1970: interval)
        } else if let double = value as? Double {
            return Date(timeIntervalSince1970: double)
        }
        
        return nil
    }
}

// MARK: - Errors

enum RepositoryError: LocalizedError {
    case documentDataNotFound
    case missingRequiredFields
    case encodingFailed
    
    var errorDescription: String? {
        switch self {
        case .documentDataNotFound:
            return "Dados do documento não encontrados"
        case .missingRequiredFields:
            return "Campos obrigatórios ausentes"
        case .encodingFailed:
            return "Falha ao codificar dados"
        }
    }
}

#endif // canImport(FirebaseFirestore)

