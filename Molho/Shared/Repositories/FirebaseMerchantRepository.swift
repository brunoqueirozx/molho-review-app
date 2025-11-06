import Foundation
import Combine

#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

final class FirebaseMerchantRepository: MerchantRepository {
    #if canImport(FirebaseFirestore)
    private let db = Firestore.firestore()
    private let collectionName = "merchants"
    #endif
    
    func fetchMerchantsNear(latitude: Double, longitude: Double, radiusMeters: Double) -> [Merchant] {
        #if canImport(FirebaseFirestore)
        // TODO: Implementar busca geográfica usando GeoFirestore ou similar
        // Por enquanto, retorna todos os merchants
        return []
        #else
        return []
        #endif
    }
    
    func searchMerchants(query: String) -> [Merchant] {
        #if canImport(FirebaseFirestore)
        // Implementação síncrona temporária - idealmente deveria ser async
        var results: [Merchant] = []
        let semaphore = DispatchSemaphore(value: 0)
        
        var queryRef: Query = db.collection(collectionName)
        
        if !query.isEmpty {
            // Busca por nome (case-insensitive)
            queryRef = queryRef
                .whereField("name", isGreaterThanOrEqualTo: query)
                .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
        }
        
        queryRef.getDocuments { snapshot, error in
            defer { semaphore.signal() }
            
            if let error = error {
                print("Erro ao buscar merchants: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                return
            }
            
            results = documents.compactMap { doc in
                try? self.decodeMerchant(from: doc)
            }
        }
        
        semaphore.wait()
        return results
        #else
        return []
        #endif
    }
    
    func merchantById(id: String) -> Merchant? {
        #if canImport(FirebaseFirestore)
        var result: Merchant?
        let semaphore = DispatchSemaphore(value: 0)
        
        db.collection(collectionName).document(id).getDocument { snapshot, error in
            defer { semaphore.signal() }
            
            if let error = error {
                print("Erro ao buscar merchant: \(error.localizedDescription)")
                return
            }
            
            guard let doc = snapshot, doc.exists else {
                return
            }
            
            result = try? self.decodeMerchant(from: doc)
        }
        
        semaphore.wait()
        return result
        #else
        return nil
        #endif
    }
    
    // MARK: - Métodos auxiliares
    
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
    
    // MARK: - Métodos de escrita (para uso futuro)
    
    func createMerchant(_ merchant: Merchant) async throws {
        #if canImport(FirebaseFirestore)
        let data = try Firestore.Encoder().encode(merchant)
        try await db.collection(collectionName).document(merchant.id).setData(data)
        #endif
    }
    
    func updateMerchant(_ merchant: Merchant) async throws {
        #if canImport(FirebaseFirestore)
        let data = try Firestore.Encoder().encode(merchant)
        try await db.collection(collectionName).document(merchant.id).updateData(data)
        #endif
    }
    
    func deleteMerchant(id: String) async throws {
        #if canImport(FirebaseFirestore)
        try await db.collection(collectionName).document(id).delete()
        #endif
    }
}

