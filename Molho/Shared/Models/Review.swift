import Foundation

struct Review: Identifiable, Codable {
    var id: String
    var merchantId: String // ID do estabelecimento avaliado
    var userId: String // ID do usuário que fez a avaliação
    var userName: String // Nome do usuário que fez a avaliação
    var userAvatarUrl: String? // Avatar do usuário
    
    // Avaliação
    var rating: Int // 1 a 5 estrelas
    var comment: String? // Comentário opcional
    
    // Timestamps
    var createdAt: Date?
    var updatedAt: Date?
    
    // Inicializador padrão
    init(
        id: String = UUID().uuidString,
        merchantId: String,
        userId: String,
        userName: String,
        userAvatarUrl: String? = nil,
        rating: Int,
        comment: String? = nil,
        createdAt: Date? = Date(),
        updatedAt: Date? = Date()
    ) {
        self.id = id
        self.merchantId = merchantId
        self.userId = userId
        self.userName = userName
        self.userAvatarUrl = userAvatarUrl
        self.rating = rating
        self.comment = comment
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Review: Equatable {
    static func == (lhs: Review, rhs: Review) -> Bool {
        lhs.id == rhs.id
    }
}

