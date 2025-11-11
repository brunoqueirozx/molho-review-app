import Foundation
import UIKit

#if canImport(FirebaseStorage)
import FirebaseStorage

final class FirebaseStorageService {
    private let storage = Storage.storage()
    private let merchantsFolder = "merchants"
    private let usersFolder = "users"
    
    // MARK: - Upload de Imagens
    
    /// Faz upload de uma imagem e retorna a URL gs://
    func uploadImage(_ image: UIImage, merchantId: String, imageType: ImageType) async throws -> String {
        // Comprimir a imagem
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw StorageError.compressionFailed
        }
        
        // Gerar nome único para a imagem
        let filename = "\(imageType.prefix)_\(UUID().uuidString).jpg"
        let path = "\(merchantsFolder)/\(merchantId)/\(filename)"
        
        // Referência no Storage
        let storageRef = storage.reference().child(path)
        
        // Metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload
        let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
        
        // Retornar URL no formato gs://
        return "gs://\(storageRef.bucket)/\(path)"
    }
    
    /// Faz upload de múltiplas imagens
    func uploadImages(_ images: [UIImage], merchantId: String, imageType: ImageType) async throws -> [String] {
        var urls: [String] = []
        
        for (index, image) in images.enumerated() {
            let url = try await uploadImage(image, merchantId: merchantId, imageType: imageType)
            urls.append(url)
            print("✅ Upload \(index + 1)/\(images.count): \(url)")
        }
        
        return urls
    }
    
    // MARK: - Deletar Imagens
    
    /// Deleta uma imagem do Storage
    func deleteImage(url: String) async throws {
        let storageRef = storage.reference(forURL: url)
        try await storageRef.delete()
    }
    
    /// Deleta todas as imagens de um merchant
    func deleteMerchantImages(merchantId: String) async throws {
        let folderRef = storage.reference().child("\(merchantsFolder)/\(merchantId)")
        
        // Listar todos os arquivos
        let result = try await folderRef.listAll()
        
        // Deletar cada arquivo
        for item in result.items {
            try await item.delete()
        }
    }
    
    // MARK: - Upload de Avatar de Usuário
    
    /// Faz upload de um avatar de usuário e retorna a URL gs://
    func uploadAvatar(_ image: UIImage, userId: String) async throws -> String {
        // Comprimir a imagem com qualidade maior para avatares
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw StorageError.compressionFailed
        }
        
        // Nome do arquivo do avatar
        let filename = "avatar_\(UUID().uuidString).jpg"
        let path = "\(usersFolder)/\(userId)/\(filename)"
        
        // Referência no Storage
        let storageRef = storage.reference().child(path)
        
        // Metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload
        let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
        
        // Retornar URL no formato gs://
        return "gs://\(storageRef.bucket)/\(path)"
    }
    
    /// Deleta o avatar de um usuário
    func deleteAvatar(url: String) async throws {
        let storageRef = storage.reference(forURL: url)
        try await storageRef.delete()
    }
    
    /// Deleta todas as imagens de um usuário
    func deleteUserImages(userId: String) async throws {
        let folderRef = storage.reference().child("\(usersFolder)/\(userId)")
        
        // Listar todos os arquivos
        let result = try await folderRef.listAll()
        
        // Deletar cada arquivo
        for item in result.items {
            try await item.delete()
        }
    }
}

// MARK: - Tipos auxiliares

extension FirebaseStorageService {
    enum ImageType {
        case header
        case gallery
        
        var prefix: String {
            switch self {
            case .header: return "header"
            case .gallery: return "gallery"
            }
        }
    }
    
    enum StorageError: LocalizedError {
        case compressionFailed
        case uploadFailed
        case deleteFailed
        
        var errorDescription: String? {
            switch self {
            case .compressionFailed:
                return "Falha ao comprimir a imagem"
            case .uploadFailed:
                return "Falha ao fazer upload da imagem"
            case .deleteFailed:
                return "Falha ao deletar a imagem"
            }
        }
    }
}

#endif // canImport(FirebaseStorage)

