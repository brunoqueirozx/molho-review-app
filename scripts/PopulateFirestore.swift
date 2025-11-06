// Script Swift para popular o Firestore diretamente do app
// Use esta função uma vez quando o Firebase estiver configurado
// 
// Como usar:
// 1. Configure o Firebase no app (GoogleService-Info.plist)
// 2. Adicione FirebaseFirestore via SPM
// 3. Chame populateFirestore() uma vez (ex: em um botão de admin ou no AppDelegate)

#if canImport(FirebaseFirestore)
import FirebaseFirestore
import Foundation

func populateFirestore() async throws {
    let db = Firestore.firestore()
    
    let merchants: [[String: Any]] = [
        [
            "name": "Guarita Bar",
            "categories": ["Bar de drinks / coquetéis", "Happy hour"],
            "style": "Casual",
            "criticRating": 3.5,
            "publicRating": 3.6,
            "likesCount": 380,
            "bookmarksCount": 350,
            "viewsCount": 380,
            "description": "Bar aconchegante com drinks clássicos e autorais, petiscos e luz baixa. Perfeito para encontros e happy hour.",
            "addressText": "R. Simão Álvares, 952 - Pinheiros, São Paulo - SP, 05417-020",
            "latitude": -23.56,
            "longitude": -46.68,
            "openingHours": [
                "monday": ["open": "18:00", "close": "23:00", "isClosed": false],
                "tuesday": ["open": "18:00", "close": "23:00", "isClosed": false],
                "wednesday": ["open": "18:00", "close": "23:00", "isClosed": false],
                "thursday": ["open": "18:00", "close": "23:00", "isClosed": false],
                "friday": ["open": "18:00", "close": "01:00", "isClosed": false],
                "saturday": ["open": "18:00", "close": "01:00", "isClosed": false],
                "sunday": ["open": "18:00", "close": "23:00", "isClosed": false]
            ],
            "isOpen": true,
            "createdAt": Timestamp(),
            "updatedAt": Timestamp()
        ],
        [
            "name": "Pizzaria Paulista",
            "categories": ["Italiana", "Family friendly"],
            "style": "Casual",
            "criticRating": 4.0,
            "publicRating": 4.2,
            "likesCount": 250,
            "bookmarksCount": 180,
            "viewsCount": 250,
            "description": "Pizzaria tradicional com forno a lenha e ambiente descontraído.",
            "addressText": "Av. Paulista, 1000",
            "latitude": -23.561,
            "longitude": -46.681,
            "openingHours": [
                "monday": ["open": "18:00", "close": "00:00", "isClosed": false],
                "tuesday": ["open": "18:00", "close": "00:00", "isClosed": false],
                "wednesday": ["open": "18:00", "close": "00:00", "isClosed": false],
                "thursday": ["open": "18:00", "close": "00:00", "isClosed": false],
                "friday": ["open": "18:00", "close": "00:00", "isClosed": false],
                "saturday": ["open": "18:00", "close": "00:00", "isClosed": false],
                "sunday": ["open": "18:00", "close": "00:00", "isClosed": false]
            ],
            "isOpen": true,
            "createdAt": Timestamp(),
            "updatedAt": Timestamp()
        ]
        // Adicione os outros 10 merchants seguindo o mesmo padrão
    ]
    
    let batch = db.batch()
    
    for merchant in merchants {
        let docRef = db.collection("merchants").document()
        batch.setData(merchant, forDocument: docRef)
    }
    
    try await batch.commit()
    print("✅ \(merchants.count) merchants adicionados ao Firestore!")
}

// Para usar no app:
// Task {
//     do {
//         try await populateFirestore()
//     } catch {
//         print("Erro: \(error)")
//     }
// }
#endif

