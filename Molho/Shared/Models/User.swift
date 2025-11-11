import Foundation

struct User: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var phone: String
    var avatarUrl: String? // URL da imagem do avatar no Firebase Storage
    
    // Timestamps
    var createdAt: Date?
    var updatedAt: Date?
    
    // Inicializador padrão
    init(
        id: String = UUID().uuidString,
        name: String = "",
        email: String = "",
        phone: String = "",
        avatarUrl: String? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.avatarUrl = avatarUrl
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

