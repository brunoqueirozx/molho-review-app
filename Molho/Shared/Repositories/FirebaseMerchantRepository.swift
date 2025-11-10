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
    
    /// Converte URLs do Firebase Storage (gs://) para URLs HTTP públicas
    private func convertStorageUrl(_ gsUrl: String) -> String {
        // Se já é uma URL HTTP, retorna como está
        if gsUrl.hasPrefix("http://") || gsUrl.hasPrefix("https://") {
            return gsUrl
        }
        
        // Se é uma URL gs://, converte para HTTP
        if gsUrl.hasPrefix("gs://") {
            // Extrair o bucket e o path
            // Formato: gs://bucket-name/path/to/file.png
            let withoutPrefix = gsUrl.replacingOccurrences(of: "gs://", with: "")
            
            if let firstSlashIndex = withoutPrefix.firstIndex(of: "/") {
                let bucket = String(withoutPrefix[..<firstSlashIndex])
                let path = String(withoutPrefix[firstSlashIndex...].dropFirst()) // remove a /
                
                // Codificar o path para URL (/ deve virar %2F)
                var allowedCharacters = CharacterSet.alphanumerics
                allowedCharacters.insert(charactersIn: "-_.~") // caracteres permitidos sem encoding
                let encodedPath = path.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? path
                
                // Construir URL HTTP do Firebase Storage
                let url = "https://firebasestorage.googleapis.com/v0/b/\(bucket)/o/\(encodedPath)?alt=media"
                print("🔄 Converteu: \(gsUrl)")
                print("   ➡️ Para: \(url)")
                return url
            }
        }
        
        // Se não conseguir converter, retorna a URL original
        return gsUrl
    }
    
    /// Converte array de URLs do Firebase Storage
    private func convertStorageUrls(_ urls: [String]?) -> [String]? {
        guard let urls = urls else { return nil }
        return urls.map { convertStorageUrl($0) }
    }
    
    private func decodeMerchant(from document: DocumentSnapshot) -> Merchant? {
        guard let data = document.data() else {
            print("⚠️ Documento \(document.documentID) não tem dados")
            return nil
        }
        
        // 🔍 DEBUG: Imprimir todos os campos disponíveis no documento
        print("\n📄 Documento: \(document.documentID)")
        print("🔑 Campos disponíveis: \(data.keys.sorted())")
        
        // Converter tipos do Firestore para tipos compatíveis com JSON
        var processedData: [String: Any] = [:]
        
        for (key, value) in data {
            // Converter Timestamp para Date (e depois para timestamp Unix)
            if let timestamp = value as? Timestamp {
                processedData[key] = timestamp.dateValue().timeIntervalSince1970
            } else if value is GeoPoint {
                // GeoPoint não é usado no modelo atual
                continue
            } else if let array = value as? [Any] {
                // Processar arrays (pode conter Timestamps)
                processedData[key] = array.map { (item) -> Any in
                    if let ts = item as? Timestamp {
                        return ts.dateValue().timeIntervalSince1970 as Any
                    }
                    return item
                }
            } else {
                processedData[key] = value
            }
        }
        
        // 🔍 DEBUG: Verificar campos de imagens especificamente
        // Tentar múltiplas variações de nomes para galleryImages
        var galleryImagesArray: [String]? = nil
        if let gallery = processedData["galleryImages"] as? [String] {
            galleryImagesArray = convertStorageUrls(gallery)
        } else if let gallery = processedData["gallery_images"] as? [String] {
            galleryImagesArray = convertStorageUrls(gallery)
        } else if let gallery = processedData["gallery"] as? [String] {
            galleryImagesArray = convertStorageUrls(gallery)
        }
        
        if let galleryImages = galleryImagesArray {
            print("🖼️ galleryImages encontrado: \(galleryImages.count) imagens")
            print("   ✅ URLs convertidas para HTTP:")
            galleryImages.enumerated().forEach { index, url in
                print("   [\(index)]: \(url)")
            }
        } else {
            print("⚠️ galleryImages NÃO encontrado")
            print("   Tentou: galleryImages, gallery_images, gallery")
            if let value = processedData["galleryImages"] {
                print("   Tipo recebido em 'galleryImages': \(type(of: value))")
                print("   Valor: \(value)")
            }
        }
        
        // Tentar múltiplas variações para headerImageUrl
        var headerImage: String? = nil
        if let header = processedData["headerImageUrl"] as? String {
            headerImage = convertStorageUrl(header)
        } else if let header = processedData["header_image_url"] as? String {
            headerImage = convertStorageUrl(header)
        } else if let header = processedData["headerImage"] as? String {
            headerImage = convertStorageUrl(header)
        } else if let header = processedData["imageUrl"] as? String {
            headerImage = convertStorageUrl(header)
        }
        
        if let headerImageUrl = headerImage {
            print("🖼️ headerImageUrl convertido: \(headerImageUrl)")
        } else {
            print("⚠️ headerImageUrl NÃO encontrado")
        }
        
        // Tentar múltiplas variações para carouselImages
        var carouselImagesArray: [String]? = nil
        if let carousel = processedData["carouselImages"] as? [String] {
            carouselImagesArray = convertStorageUrls(carousel)
        } else if let carousel = processedData["carousel_images"] as? [String] {
            carouselImagesArray = convertStorageUrls(carousel)
        } else if let carousel = processedData["carousel"] as? [String] {
            carouselImagesArray = convertStorageUrls(carousel)
        }
        
        if let carouselImages = carouselImagesArray {
            print("🖼️ carouselImages: \(carouselImages.count) imagens")
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
            headerImageUrl: headerImage,
            carouselImages: carouselImagesArray,
            galleryImages: galleryImagesArray,
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
        
        print("✅ Merchant '\(name)' decodificado com \(merchant.galleryImages?.count ?? 0) galleryImages\n")
        
        return merchant
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
    
    // MARK: - Métodos de debug
    
    func debugFetchDocument(id: String) async {
        print("\n🔍 ==================== DEBUG FETCH ====================")
        print("📄 Buscando documento: \(id)")
        
        do {
            let doc = try await db.collection(collectionName).document(id).getDocument()
            
            if !doc.exists {
                print("❌ Documento não existe!")
                return
            }
            
            guard let data = doc.data() else {
                print("❌ Documento sem dados")
                return
            }
            
            print("\n✅ Documento encontrado!")
            print("📦 Total de campos: \(data.count)")
            print("\n🔑 TODOS OS CAMPOS E VALORES:\n")
            
            // Ordenar campos alfabeticamente
            let sortedKeys = data.keys.sorted()
            
            for key in sortedKeys {
                let value = data[key]
                
                if let stringValue = value as? String {
                    print("   \(key): \"\(stringValue)\"")
                } else if let arrayValue = value as? [Any] {
                    print("   \(key): Array com \(arrayValue.count) itens")
                    if let stringArray = value as? [String] {
                        stringArray.enumerated().forEach { index, item in
                            print("      [\(index)]: \"\(item)\"")
                        }
                    } else {
                        arrayValue.enumerated().forEach { index, item in
                            print("      [\(index)]: \(item)")
                        }
                    }
                } else if let dictValue = value as? [String: Any] {
                    print("   \(key): Dictionary com \(dictValue.count) campos")
                    for (subKey, subValue) in dictValue {
                        print("      \(subKey): \(subValue)")
                    }
                } else if let numberValue = value as? NSNumber {
                    print("   \(key): \(numberValue)")
                } else if let timestamp = value as? Timestamp {
                    print("   \(key): \(timestamp.dateValue())")
                } else {
                    print("   \(key): \(value) (tipo: \(type(of: value)))")
                }
            }
            
            print("\n🔍 ==================== FIM DEBUG ====================\n")
            
        } catch {
            print("❌ Erro ao buscar documento: \(error)")
        }
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
