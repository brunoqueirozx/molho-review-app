import Foundation
import Combine

#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

// Versão assíncrona do repositório usando async/await
@available(iOS 15.0, *)
final class FirebaseMerchantRepositoryAsync: MerchantRepository {
    #if canImport(FirebaseFirestore)
    private let db = Firestore.firestore()
    private let collectionName = "merchants"
    #endif
    
    func fetchMerchantsNear(latitude: Double, longitude: Double, radiusMeters: Double) -> [Merchant] {
        // Implementação síncrona para compatibilidade
        // Use fetchMerchantsNearAsync para versão async
        return []
    }
    
    func searchMerchants(query: String) -> [Merchant] {
        // Implementação síncrona para compatibilidade
        // Use searchMerchantsAsync para versão async
        return []
    }
    
    func merchantById(id: String) -> Merchant? {
        // Implementação síncrona para compatibilidade
        // Use merchantByIdAsync para versão async
        return nil
    }
    
    // MARK: - Métodos assíncronos
    
    @available(iOS 15.0, *)
    func fetchMerchantsNearAsync(latitude: Double, longitude: Double, radiusMeters: Double) async throws -> [Merchant] {
        #if canImport(FirebaseFirestore)
        // TODO: Implementar busca geográfica
        let snapshot = try await db.collection(collectionName).getDocuments()
        return snapshot.documents.compactMap { doc in
            try? decodeMerchant(from: doc)
        }
        #else
        return []
        #endif
    }
    
    @available(iOS 15.0, *)
    func searchMerchantsAsync(query: String) async throws -> [Merchant] {
        #if canImport(FirebaseFirestore)
        var queryRef: Query = db.collection(collectionName)
        
        if !query.isEmpty {
            queryRef = queryRef
                .whereField("name", isGreaterThanOrEqualTo: query)
                .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
        }
        
        let snapshot = try await queryRef.getDocuments()
        return snapshot.documents.compactMap { doc in
            try? decodeMerchant(from: doc)
        }
        #else
        return []
        #endif
    }
    
    @available(iOS 15.0, *)
    func merchantByIdAsync(id: String) async throws -> Merchant? {
        #if canImport(FirebaseFirestore)
        let doc = try await db.collection(collectionName).document(id).getDocument()
        guard doc.exists else { return nil }
        return try decodeMerchant(from: doc)
        #else
        return nil
        #endif
    }
    
    #if canImport(FirebaseFirestore)
    private func decodeMerchant(from document: DocumentSnapshot) throws -> Merchant? {
        guard let data = document.data() else { return nil }
        var merchant = try Firestore.Decoder().decode(Merchant.self, from: data)
        merchant.id = document.documentID
        return merchant
    }
    
    private func decodeMerchant(from document: QueryDocumentSnapshot) throws -> Merchant? {
        var merchant = try Firestore.Decoder().decode(Merchant.self, from: document.data())
        merchant.id = document.documentID
        return merchant
    }
    #endif
}

