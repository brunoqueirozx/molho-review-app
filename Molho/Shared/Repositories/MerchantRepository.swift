import Foundation

protocol MerchantRepository {
    func fetchMerchantsNear(latitude: Double, longitude: Double, radiusMeters: Double) -> [Merchant]
    func searchMerchants(query: String) -> [Merchant]
    func merchantById(id: String) -> Merchant?
}

// Para uso futuro com async/await (iOS 15+)
@available(iOS 15.0, *)
protocol MerchantRepositoryAsync {
    func fetchMerchantsNearAsync(latitude: Double, longitude: Double, radiusMeters: Double) async throws -> [Merchant]
    func searchMerchantsAsync(query: String) async throws -> [Merchant]
    func merchantByIdAsync(id: String) async throws -> Merchant?
}

// TODO: Conectar com Firebase Firestore aqui.
final class MerchantRepositoryStub: MerchantRepository {
    func fetchMerchantsNear(latitude: Double, longitude: Double, radiusMeters: Double) -> [Merchant] {
        return sampleMerchants()
    }

    func searchMerchants(query: String) -> [Merchant] {
        if query.isEmpty {
            // Se a query estiver vazia, retorna todos os merchants
            return sampleMerchants()
        }
        // Filtra por nome que contém a query
        return sampleMerchants().filter { $0.name.lowercased().contains(query.lowercased()) }
    }

    func merchantById(id: String) -> Merchant? {
        return sampleMerchants().first { $0.id == id }
    }

    private func sampleMerchants() -> [Merchant] {
        return [
            Merchant(
                id: "1",
                name: "Guarita Bar",
                category: "Bar de drink",
                style: "Casual",
                rating: 3.6,
                reviewsCount: 3.2,
                viewsCount: 380,
                bookmarksCount: 350,
                description: "Bar aconchegante com drinks clássicos e autorais, petiscos e luz baixa. Perfeito para encontros e happy hour.",
                latitude: -23.56,
                longitude: -46.68,
                address: "R. Simão Álvares, 952 - Pinheiros, São Paulo - SP, 05417-020",
                openingHours: "Fecha 23:00",
                isOpen: true,
                imageUrl: nil,
                galleryImages: nil
            ),
            Merchant(
                id: "2",
                name: "Pizzaria Paulista",
                category: "Pizza",
                style: "Casual",
                rating: 4.2,
                reviewsCount: 4.5,
                viewsCount: 250,
                bookmarksCount: 180,
                description: "Pizzaria tradicional com forno a lenha e ambiente descontraído.",
                latitude: -23.561,
                longitude: -46.681,
                address: "Av. Paulista, 1000",
                openingHours: "Fecha 00:00",
                isOpen: true,
                imageUrl: nil,
                galleryImages: nil
            ),
            Merchant(
                id: "3",
                name: "Sushi House",
                category: "Japonês",
                style: "Elegante",
                rating: 4.8,
                reviewsCount: 4.9,
                viewsCount: 520,
                bookmarksCount: 420,
                description: "Sushi fresco e autêntico em ambiente moderno.",
                latitude: -23.562,
                longitude: -46.682,
                address: "Rua dos Três Irmãos, 200",
                openingHours: "Fecha 22:30",
                isOpen: true,
                imageUrl: nil,
                galleryImages: nil
            ),
            Merchant(
                id: "4",
                name: "Boteco do João",
                category: "Boteco",
                style: "Casual",
                rating: 4.0,
                reviewsCount: 3.8,
                viewsCount: 320,
                bookmarksCount: 280,
                description: "Boteco tradicional com petiscos e cerveja gelada.",
                latitude: -23.563,
                longitude: -46.683,
                address: "Av. Brigadeiro, 500",
                openingHours: "Fecha 01:00",
                isOpen: true,
                imageUrl: nil,
                galleryImages: nil
            ),
            Merchant(
                id: "5",
                name: "Izakaya Tokyo",
                category: "Izakaya",
                style: "Casual",
                rating: 4.5,
                reviewsCount: 4.2,
                viewsCount: 410,
                bookmarksCount: 360,
                description: "Autêntico izakaya japonês com ambiente acolhedor.",
                latitude: -23.564,
                longitude: -46.684,
                address: "Rua Harmonia, 300",
                openingHours: "Fecha 23:30",
                isOpen: true,
                imageUrl: nil,
                galleryImages: nil
            ),
            Merchant(
                id: "6",
                name: "Cervejaria Artesanal",
                category: "Cervejaria",
                style: "Casual",
                rating: 4.3,
                reviewsCount: 4.0,
                viewsCount: 290,
                bookmarksCount: 240,
                description: "Cervejas artesanais e petiscos selecionados.",
                latitude: -23.565,
                longitude: -46.685,
                address: "Rua Cardeal, 150",
                openingHours: "Fecha 00:00",
                isOpen: true,
                imageUrl: nil,
                galleryImages: nil
            ),
            Merchant(
                id: "7",
                name: "Bar do Zé",
                category: "Bar",
                style: "Casual",
                rating: 3.9,
                reviewsCount: 3.5,
                viewsCount: 180,
                bookmarksCount: 150,
                description: "Bar descontraído com música ao vivo.",
                latitude: -23.566,
                longitude: -46.686,
                address: "Rua das Flores, 80",
                openingHours: "Fecha 02:00",
                isOpen: true,
                imageUrl: nil,
                galleryImages: nil
            ),
            Merchant(
                id: "8",
                name: "Restaurante Italiano",
                category: "Italiano",
                style: "Elegante",
                rating: 4.6,
                reviewsCount: 4.4,
                viewsCount: 450,
                bookmarksCount: 380,
                description: "Culinária italiana autêntica em ambiente sofisticado.",
                latitude: -23.567,
                longitude: -46.687,
                address: "Av. Faria Lima, 1200",
                openingHours: "Fecha 23:00",
                isOpen: true,
                imageUrl: nil,
                galleryImages: nil
            ),
            Merchant(
                id: "9",
                name: "Taco Loco",
                category: "Mexicano",
                style: "Casual",
                rating: 4.1,
                reviewsCount: 3.9,
                viewsCount: 220,
                bookmarksCount: 190,
                description: "Tacos autênticos e margaritas geladas.",
                latitude: -23.568,
                longitude: -46.688,
                address: "Rua dos Pinheiros, 400",
                openingHours: "Fecha 23:30",
                isOpen: true,
                imageUrl: nil,
                galleryImages: nil
            ),
            Merchant(
                id: "10",
                name: "Hamburgueria Premium",
                category: "Hambúrguer",
                style: "Casual",
                rating: 4.4,
                reviewsCount: 4.1,
                viewsCount: 380,
                bookmarksCount: 320,
                description: "Hambúrgueres artesanais com ingredientes selecionados.",
                latitude: -23.569,
                longitude: -46.689,
                address: "Rua Teodoro Sampaio, 600",
                openingHours: "Fecha 00:00",
                isOpen: true,
                imageUrl: nil,
                galleryImages: nil
            ),
            Merchant(
                id: "11",
                name: "Churrascaria Gaúcha",
                category: "Churrascaria",
                style: "Elegante",
                rating: 4.7,
                reviewsCount: 4.5,
                viewsCount: 550,
                bookmarksCount: 480,
                description: "Churrasco gaúcho autêntico com rodízio completo.",
                latitude: -23.570,
                longitude: -46.690,
                address: "Av. Rebouças, 800",
                openingHours: "Fecha 23:30",
                isOpen: true,
                imageUrl: nil,
                galleryImages: nil
            ),
            Merchant(
                id: "12",
                name: "Padaria Artesanal",
                category: "Padaria",
                style: "Casual",
                rating: 4.0,
                reviewsCount: 3.7,
                viewsCount: 200,
                bookmarksCount: 170,
                description: "Pães e doces artesanais feitos diariamente.",
                latitude: -23.571,
                longitude: -46.691,
                address: "Rua dos Jardins, 250",
                openingHours: "Fecha 20:00",
                isOpen: false,
                imageUrl: nil,
                galleryImages: nil
            )
        ]
    }
}


