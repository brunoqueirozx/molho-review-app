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
                    // GeoPoint não é usado no modelo atual
                    continue
                } else if let array = value as? [Any] {
                    // Processar arrays (pode conter Timestamps)
                    processedData[key] = array.map { item in
                        if let ts = item as? Timestamp {
                            return ts.dateValue().timeIntervalSince1970
                        }
                        return item
                    }
                } else {
                    processedData[key] = value
                }
            }
            
            // Garantir que campos obrigatórios existam
            guard let name = processedData["name"] as? String else {
                print("⚠️ Documento \(document.documentID) está faltando campo 'name'")
                return nil
            }
            
            // Latitude e longitude podem ter valores padrão se não existirem
            let latitude = processedData["latitude"] as? Double ?? 0.0
            let longitude = processedData["longitude"] as? Double ?? 0.0
            
            // Criar merchant manualmente para garantir compatibilidade
            let merchant = Merchant(
                id: document.documentID,
                name: name,
                headerImageUrl: processedData["headerImageUrl"] as? String,
                carouselImages: processedData["carouselImages"] as? [String],
                galleryImages: processedData["galleryImages"] as? [String],
                categories: processedData["categories"] as? [String],
                style: processedData["style"] as? String,
                criticRating: processedData["criticRating"] as? Double,
                publicRating: processedData["publicRating"] as? Double,
                likesCount: processedData["likesCount"] as? Int,
                bookmarksCount: processedData["bookmarksCount"] as? Int,
                viewsCount: processedData["viewsCount"] as? Int,
                description: processedData["description"] as? String,
                addressText: processedData["addressText"] as? String,
                latitude: latitude,
                longitude: longitude,
                openingHours: decodeOpeningHours(from: data["openingHours"]), // Usar data original, não processedData
                isOpen: processedData["isOpen"] as? Bool,
                createdAt: decodeDateFromProcessed(processedData["createdAt"]),
                updatedAt: decodeDateFromProcessed(processedData["updatedAt"])
            )
            
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
    
    // Decodificar Date de um valor já processado (TimeInterval)
    private func decodeDateFromProcessed(_ value: Any?) -> Date? {
        guard let value = value else { return nil }
        
        if let interval = value as? TimeInterval {
            return Date(timeIntervalSince1970: interval)
        } else if let double = value as? Double {
            return Date(timeIntervalSince1970: double)
        }
        
        return nil
    }
    
    // Decodificar Date diretamente do Firestore (Timestamp)
    private func decodeDate(from value: Any?) -> Date? {
        guard let value = value else { return nil }
        
        if let timestamp = value as? Timestamp {
            return timestamp.dateValue()
        } else if let interval = value as? TimeInterval {
            return Date(timeIntervalSince1970: interval)
        } else if let double = value as? Double {
            return Date(timeIntervalSince1970: double)
        }
        
        return nil
    }
    
    private func decodeOpeningHours(from value: Any?) -> OpeningHours? {
        // Pode vir como [String: Any] do Firestore ou já processado
        guard let dict = value as? [String: Any] else { return nil }
        
        // Decodificar cada dia, permitindo nil se não existir
        return OpeningHours(
            monday: decodeDayHours(from: dict["monday"]),
            tuesday: decodeDayHours(from: dict["tuesday"]),
            wednesday: decodeDayHours(from: dict["wednesday"]),
            thursday: decodeDayHours(from: dict["thursday"]),
            friday: decodeDayHours(from: dict["friday"]),
            saturday: decodeDayHours(from: dict["saturday"]),
            sunday: decodeDayHours(from: dict["sunday"])
        )
    }
    
    private func decodeDayHours(from value: Any?) -> DayHours? {
        guard let dict = value as? [String: Any],
              let open = dict["open"] as? String,
              let close = dict["close"] as? String,
              let isClosed = dict["isClosed"] as? Bool else {
            return nil
        }
        
        return DayHours(open: open, close: close, isClosed: isClosed)
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

