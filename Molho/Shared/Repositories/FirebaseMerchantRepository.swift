import Foundation
import Combine

#if canImport(FirebaseFirestore)
import FirebaseFirestore

final class FirebaseMerchantRepository: MerchantRepository {
    private let db = Firestore.firestore()
    private let collectionName = "merchants"
    
    func fetchMerchantsNear(latitude: Double, longitude: Double, radiusMeters: Double) -> [Merchant] {
        // Por enquanto, retorna todos os merchants
        // TODO: Implementar busca geográfica usando GeoFirestore ou similar
        return searchMerchants(query: "")
    }
    
    func searchMerchants(query: String) -> [Merchant] {
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
            
            print("📦 Documentos encontrados: \(documents.count)")
            
            // Decodifica todos os merchants
            let allMerchants = documents.compactMap { doc in
                self.decodeMerchant(from: doc)
            }
            
            print("✅ Merchants decodificados: \(allMerchants.count)")
            
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
    }
    
    // Versão async/await para melhor performance
    @available(iOS 15.0, *)
    func searchMerchantsAsync(query: String) async throws -> [Merchant] {
        print("🔍 Buscando merchants no Firestore...")
        
        let snapshot = try await db.collection(collectionName).getDocuments()
        
        guard !snapshot.documents.isEmpty else {
            print("⚠️ Nenhum documento encontrado na coleção '\(collectionName)'")
            return []
        }
        
        print("📦 Documentos encontrados: \(snapshot.documents.count)")
        
        // Decodifica todos os merchants
        let allMerchants = snapshot.documents.compactMap { doc in
            self.decodeMerchant(from: doc)
        }
        
        print("✅ Merchants decodificados: \(allMerchants.count)")
        
        // Se houver query, filtra localmente
        if query.isEmpty {
            return allMerchants
        } else {
            let queryLower = query.lowercased()
            return allMerchants.filter { merchant in
                merchant.name.lowercased().contains(queryLower)
            }
        }
    }
    
    func merchantById(id: String) -> Merchant? {
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
    }
    
    // MARK: - Métodos auxiliares
    
    private func decodeMerchant(from document: DocumentSnapshot) -> Merchant? {
        guard let data = document.data() else {
            print("⚠️ Documento \(document.documentID) não tem dados")
            return nil
        }
        
        do {
            // Converter tipos do Firestore para tipos compatíveis com JSON
            var processedData: [String: Any] = [:]
            
            for (key, value) in data {
                // Converter Timestamp para Date (e depois para timestamp Unix)
                if let timestamp = value as? Timestamp {
                    processedData[key] = timestamp.dateValue().timeIntervalSince1970
                } else if let geoPoint = value as? GeoPoint {
                    // GeoPoint não é usado no modelo atual, mas pode ser necessário no futuro
                    continue
                } else {
                    processedData[key] = value
                }
            }
            
            // Garantir que campos obrigatórios existam
            guard let name = processedData["name"] as? String,
                  let latitude = processedData["latitude"] as? Double,
                  let longitude = processedData["longitude"] as? Double else {
                print("⚠️ Documento \(document.documentID) está faltando campos obrigatórios")
                return nil
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: processedData)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            var merchant = try decoder.decode(Merchant.self, from: jsonData)
            merchant.id = document.documentID
            return merchant
        } catch {
            print("❌ Erro ao decodificar merchant \(document.documentID): \(error)")
            print("   Erro detalhado: \(error.localizedDescription)")
            if let data = document.data() {
                print("   Campos disponíveis: \(data.keys.joined(separator: ", "))")
            }
            return nil
        }
    }
    
    private func decodeMerchant(from document: QueryDocumentSnapshot) -> Merchant? {
        return decodeMerchant(from: document as DocumentSnapshot)
    }
    
    // MARK: - Métodos de escrita (para uso futuro)
    
    func createMerchant(_ merchant: Merchant) async throws {
        let data = try Firestore.Encoder().encode(merchant)
        try await db.collection(collectionName).document(merchant.id).setData(data)
    }
    
    func updateMerchant(_ merchant: Merchant) async throws {
        let data = try Firestore.Encoder().encode(merchant)
        try await db.collection(collectionName).document(merchant.id).updateData(data)
    }
    
    func deleteMerchant(id: String) async throws {
        try await db.collection(collectionName).document(id).delete()
    }
}

#endif // canImport(FirebaseFirestore)

