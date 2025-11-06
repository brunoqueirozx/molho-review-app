import Foundation

// Horário de funcionamento para cada dia da semana
struct OpeningHours: Codable {
    var monday: DayHours?
    var tuesday: DayHours?
    var wednesday: DayHours?
    var thursday: DayHours?
    var friday: DayHours?
    var saturday: DayHours?
    var sunday: DayHours?
}

struct DayHours: Codable {
    var open: String // Formato: "HH:mm" (ex: "18:00")
    var close: String // Formato: "HH:mm" (ex: "23:00")
    var isClosed: Bool // Se o estabelecimento está fechado neste dia
}

struct Merchant: Identifiable, Codable {
    var id: String
    var name: String
    
    // Imagens
    var headerImageUrl: String? // Imagem principal de alta resolução
    var carouselImages: [String]? // Carrossel de até 10 imagens
    var galleryImages: [String]? // Galeria sem limite de fotos
    
    // Categorias e tags
    var categories: [String]? // Array de tags de categoria
    var style: String? // Ex: "Casual", "Elegante"
    
    // Avaliações (1.0 a 5.0, incrementos de 0.5)
    var criticRating: Double? // Avaliação do crítico (1.0 a 5.0)
    var publicRating: Double? // Avaliação do público (1.0 a 5.0)
    
    // Métricas sociais
    var likesCount: Int?
    var bookmarksCount: Int?
    var viewsCount: Int?
    
    // Descrição
    var description: String? // Até 1000 caracteres
    
    // Localização
    var addressText: String? // Endereço completo
    var latitude: Double
    var longitude: Double
    
    // Horário de funcionamento
    var openingHours: OpeningHours?
    
    // Status atual
    var isOpen: Bool? // Calculado baseado no horário atual
    
    // Timestamps
    var createdAt: Date?
    var updatedAt: Date?
    
    // Compatibilidade com código antigo
    var category: String? {
        get { categories?.first }
        set { categories = newValue != nil ? [newValue!] : nil }
    }
    
    var rating: Double? {
        get { publicRating }
        set { publicRating = newValue }
    }
    
    var reviewsCount: Double? {
        get { publicRating }
        set { publicRating = newValue }
    }
    
    var address: String? {
        get { addressText }
        set { addressText = newValue }
    }
    
    var imageUrl: String? {
        get { headerImageUrl }
        set { headerImageUrl = newValue }
    }
}
