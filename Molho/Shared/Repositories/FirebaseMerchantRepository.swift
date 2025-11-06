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
        // Por enquanto, retorna todos os merchants
        // TODO: Implementar busca geográfica usando GeoFirestore ou similar
        return searchMerchants(query: "")
        #else
        return []
        #endif
    }
    
    func searchMerchants(query: String) -> [Merchant] {
        #if canImport(FirebaseFirestore)
        // Implementação síncrona temporária - idealmente deveria ser async
        var results: [Merchant] = []
        let semaphore = DispatchSemaphore(value: 0)
        
        // Busca todos os merchants do Firestore
        db.collection(collectionName).getDocuments { snapshot, error in
            defer { semaphore.signal() }
            
            if let error = error {
                print("❌ Erro ao buscar merchants: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("⚠️ Nenhum documento encontrado")
                return
            }
            
            // Decodifica todos os merchants
            let allMerchants = documents.compactMap { doc in
                self.decodeMerchant(from: doc)
            }
            
            // Se houver query, filtra localmente
            if query.isEmpty {
                results = allMerchants
            } else {
                let queryLower = query.lowercased()
                results = allMerchants.filter { merchant in
                    merchant.name.lowercased().contains(queryLower)
                }
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
                print("❌ Erro ao buscar merchant: \(error.localizedDescription)")
                return
            }
            
            guard let doc = snapshot, doc.exists else {
                print("⚠️ Merchant com ID \(id) não encontrado")
                return
            }
            
            result = self.decodeMerchant(from: doc)
        }
        
        semaphore.wait()
        return result
        #else
        return nil
        #endif
    }
    
    // MARK: - Métodos auxiliares
    
    #if canImport(FirebaseFirestore)
    private func decodeMerchant(from document: DocumentSnapshot) -> Merchant? {
        guard let data = document.data() else { return nil }
        
        do {
            // Converter tipos do Firestore para tipos compatíveis com JSON
            var processedData: [String: Any] = [:]
            
            for (key, value) in data {
                // Converter Timestamp para Date (e depois para timestamp Unix)
                if let timestamp = value as? Timestamp {
                    processedData[key] = timestamp.dateValue().timeIntervalSince1970
                } else {
                    processedData[key] = value
                }
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: processedData)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            var merchant = try decoder.decode(Merchant.self, from: jsonData)
            merchant.id = document.documentID
            return merchant
        } catch {
            print("❌ Erro ao decodificar merchant \(document.documentID): \(error)")
            if let data = document.data() {
                print("   Dados recebidos: \(data.keys.joined(separator: ", "))")
            }
            return nil
        }
    }
    
    private func decodeMerchant(from document: QueryDocumentSnapshot) -> Merchant? {
        return decodeMerchant(from: document as DocumentSnapshot)
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

