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
        // Helper para criar OpeningHours padrão
        let defaultOpeningHours = OpeningHours(
            monday: DayHours(open: "18:00", close: "23:00", isClosed: false),
            tuesday: DayHours(open: "18:00", close: "23:00", isClosed: false),
            wednesday: DayHours(open: "18:00", close: "23:00", isClosed: false),
            thursday: DayHours(open: "18:00", close: "23:00", isClosed: false),
            friday: DayHours(open: "18:00", close: "01:00", isClosed: false),
            saturday: DayHours(open: "18:00", close: "01:00", isClosed: false),
            sunday: DayHours(open: "18:00", close: "23:00", isClosed: false)
        )
        
        return [
            Merchant(
                id: "1",
                name: "Guarita Bar",
                headerImageUrl: "https://picsum.photos/id/1040/400/200",
                carouselImages: ["https://picsum.photos/id/1041/200/150", "https://picsum.photos/id/1042/200/150"],
                galleryImages: ["https://picsum.photos/id/1043/200/200", "https://picsum.photos/id/1044/200/200"],
                categories: ["Bar de drinks / coquetéis", "Happy hour"],
                style: "Casual",
                criticRating: 3.5,
                publicRating: 3.6,
                likesCount: 380,
                bookmarksCount: 350,
                viewsCount: 380,
                description: "Bar aconchegante com drinks clássicos e autorais, petiscos e luz baixa. Perfeito para encontros e happy hour.",
                addressText: "R. Simão Álvares, 952 - Pinheiros, São Paulo - SP, 05417-020",
                latitude: -23.56,
                longitude: -46.68,
                openingHours: defaultOpeningHours,
                isOpen: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            Merchant(
                id: "2",
                name: "Pizzaria Paulista",
                headerImageUrl: "https://picsum.photos/id/1050/400/200",
                carouselImages: ["https://picsum.photos/id/1051/200/150"],
                galleryImages: ["https://picsum.photos/id/1052/200/200"],
                categories: ["Italiana", "Family friendly"],
                style: "Casual",
                criticRating: 4.0,
                publicRating: 4.2,
                likesCount: 250,
                bookmarksCount: 180,
                viewsCount: 250,
                description: "Pizzaria tradicional com forno a lenha e ambiente descontraído.",
                addressText: "Av. Paulista, 1000",
                latitude: -23.561,
                longitude: -46.681,
                openingHours: OpeningHours(
                    monday: DayHours(open: "18:00", close: "00:00", isClosed: false),
                    tuesday: DayHours(open: "18:00", close: "00:00", isClosed: false),
                    wednesday: DayHours(open: "18:00", close: "00:00", isClosed: false),
                    thursday: DayHours(open: "18:00", close: "00:00", isClosed: false),
                    friday: DayHours(open: "18:00", close: "00:00", isClosed: false),
                    saturday: DayHours(open: "18:00", close: "00:00", isClosed: false),
                    sunday: DayHours(open: "18:00", close: "00:00", isClosed: false)
                ),
                isOpen: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            Merchant(
                id: "3",
                name: "Sushi House",
                headerImageUrl: "https://picsum.photos/id/1055/400/200",
                carouselImages: ["https://picsum.photos/id/1056/200/150"],
                galleryImages: ["https://picsum.photos/id/1057/200/200"],
                categories: ["Japonesa"],
                style: "Elegante",
                criticRating: 4.8,
                publicRating: 4.8,
                likesCount: 520,
                bookmarksCount: 420,
                viewsCount: 520,
                description: "Sushi fresco e autêntico em ambiente moderno.",
                addressText: "Rua dos Três Irmãos, 200",
                latitude: -23.562,
                longitude: -46.682,
                openingHours: defaultOpeningHours,
                isOpen: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            Merchant(
                id: "4",
                name: "Boteco do João",
                headerImageUrl: "https://picsum.photos/id/1060/400/200",
                carouselImages: ["https://picsum.photos/id/1061/200/150"],
                galleryImages: ["https://picsum.photos/id/1062/200/200"],
                categories: ["Boteco brasileiro"],
                style: "Casual",
                criticRating: 4.0,
                publicRating: 4.0,
                likesCount: 320,
                bookmarksCount: 280,
                viewsCount: 320,
                description: "Boteco tradicional com petiscos e cerveja gelada.",
                addressText: "Av. Brigadeiro, 500",
                latitude: -23.563,
                longitude: -46.683,
                openingHours: defaultOpeningHours,
                isOpen: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            Merchant(
                id: "5",
                name: "Izakaya Tokyo",
                headerImageUrl: "https://picsum.photos/id/1065/400/200",
                carouselImages: ["https://picsum.photos/id/1066/200/150"],
                galleryImages: ["https://picsum.photos/id/1067/200/200"],
                categories: ["Izakayas"],
                style: "Casual",
                criticRating: 4.5,
                publicRating: 4.5,
                likesCount: 410,
                bookmarksCount: 360,
                viewsCount: 410,
                description: "Autêntico izakaya japonês com ambiente acolhedor.",
                addressText: "Rua Harmonia, 300",
                latitude: -23.564,
                longitude: -46.684,
                openingHours: defaultOpeningHours,
                isOpen: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            Merchant(
                id: "6",
                name: "Cervejaria Artesanal",
                headerImageUrl: "https://picsum.photos/id/1070/400/200",
                carouselImages: ["https://picsum.photos/id/1071/200/150"],
                galleryImages: ["https://picsum.photos/id/1072/200/200"],
                categories: ["Pub / Cervejaria"],
                style: "Casual",
                criticRating: 4.3,
                publicRating: 4.3,
                likesCount: 290,
                bookmarksCount: 240,
                viewsCount: 290,
                description: "Cervejas artesanais e petiscos selecionados.",
                addressText: "Rua Cardeal, 150",
                latitude: -23.565,
                longitude: -46.685,
                openingHours: defaultOpeningHours,
                isOpen: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            Merchant(
                id: "7",
                name: "Bar do Zé",
                headerImageUrl: "https://picsum.photos/id/1075/400/200",
                carouselImages: ["https://picsum.photos/id/1076/200/150"],
                galleryImages: ["https://picsum.photos/id/1077/200/200"],
                categories: ["Bar temático"],
                style: "Casual",
                criticRating: 3.9,
                publicRating: 3.9,
                likesCount: 180,
                bookmarksCount: 150,
                viewsCount: 180,
                description: "Bar descontraído com música ao vivo.",
                addressText: "Rua das Flores, 80",
                latitude: -23.566,
                longitude: -46.686,
                openingHours: OpeningHours(
                    monday: DayHours(open: "18:00", close: "02:00", isClosed: false),
                    tuesday: DayHours(open: "18:00", close: "02:00", isClosed: false),
                    wednesday: DayHours(open: "18:00", close: "02:00", isClosed: false),
                    thursday: DayHours(open: "18:00", close: "02:00", isClosed: false),
                    friday: DayHours(open: "18:00", close: "02:00", isClosed: false),
                    saturday: DayHours(open: "18:00", close: "02:00", isClosed: false),
                    sunday: DayHours(open: "18:00", close: "02:00", isClosed: false)
                ),
                isOpen: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            Merchant(
                id: "8",
                name: "Restaurante Italiano",
                headerImageUrl: "https://picsum.photos/id/1080/400/200",
                carouselImages: ["https://picsum.photos/id/1081/200/150"],
                galleryImages: ["https://picsum.photos/id/1082/200/200"],
                categories: ["Italiana", "Fine dining"],
                style: "Elegante",
                criticRating: 4.6,
                publicRating: 4.6,
                likesCount: 450,
                bookmarksCount: 380,
                viewsCount: 450,
                description: "Culinária italiana autêntica em ambiente sofisticado.",
                addressText: "Av. Faria Lima, 1200",
                latitude: -23.567,
                longitude: -46.687,
                openingHours: defaultOpeningHours,
                isOpen: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            Merchant(
                id: "9",
                name: "Taco Loco",
                headerImageUrl: "https://picsum.photos/id/1085/400/200",
                carouselImages: ["https://picsum.photos/id/1086/200/150"],
                galleryImages: ["https://picsum.photos/id/1087/200/200"],
                categories: ["Temática (mexicana)"],
                style: "Casual",
                criticRating: 4.1,
                publicRating: 4.1,
                likesCount: 220,
                bookmarksCount: 190,
                viewsCount: 220,
                description: "Tacos autênticos e margaritas geladas.",
                addressText: "Rua dos Pinheiros, 400",
                latitude: -23.568,
                longitude: -46.688,
                openingHours: defaultOpeningHours,
                isOpen: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            Merchant(
                id: "10",
                name: "Hamburgueria Premium",
                headerImageUrl: "https://picsum.photos/id/1090/400/200",
                carouselImages: ["https://picsum.photos/id/1091/200/150"],
                galleryImages: ["https://picsum.photos/id/1092/200/200"],
                categories: ["Fast-casual"],
                style: "Casual",
                criticRating: 4.4,
                publicRating: 4.4,
                likesCount: 380,
                bookmarksCount: 320,
                viewsCount: 380,
                description: "Hambúrgueres artesanais com ingredientes selecionados.",
                addressText: "Rua Teodoro Sampaio, 600",
                latitude: -23.569,
                longitude: -46.689,
                openingHours: defaultOpeningHours,
                isOpen: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            Merchant(
                id: "11",
                name: "Churrascaria Gaúcha",
                headerImageUrl: "https://picsum.photos/id/1095/400/200",
                carouselImages: ["https://picsum.photos/id/1096/200/150"],
                galleryImages: ["https://picsum.photos/id/1097/200/200"],
                categories: ["Churrascaria", "Rodízio"],
                style: "Elegante",
                criticRating: 4.7,
                publicRating: 4.7,
                likesCount: 550,
                bookmarksCount: 480,
                viewsCount: 550,
                description: "Churrasco gaúcho autêntico com rodízio completo.",
                addressText: "Av. Rebouças, 800",
                latitude: -23.570,
                longitude: -46.690,
                openingHours: defaultOpeningHours,
                isOpen: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            Merchant(
                id: "12",
                name: "Padaria Artesanal",
                headerImageUrl: "https://picsum.photos/id/1100/400/200",
                carouselImages: ["https://picsum.photos/id/1101/200/150"],
                galleryImages: ["https://picsum.photos/id/1102/200/200"],
                categories: ["Café / Brunch"],
                style: "Casual",
                criticRating: 4.0,
                publicRating: 4.0,
                likesCount: 200,
                bookmarksCount: 170,
                viewsCount: 200,
                description: "Pães e doces artesanais feitos diariamente.",
                addressText: "Rua dos Jardins, 250",
                latitude: -23.571,
                longitude: -46.691,
                openingHours: OpeningHours(
                    monday: DayHours(open: "06:00", close: "14:00", isClosed: false),
                    tuesday: DayHours(open: "06:00", close: "14:00", isClosed: false),
                    wednesday: DayHours(open: "06:00", close: "14:00", isClosed: false),
                    thursday: DayHours(open: "06:00", close: "14:00", isClosed: false),
                    friday: DayHours(open: "06:00", close: "14:00", isClosed: false),
                    saturday: DayHours(open: "06:00", close: "14:00", isClosed: false),
                    sunday: DayHours(open: "06:00", close: "14:00", isClosed: true)
                ),
                isOpen: false,
                createdAt: Date(),
                updatedAt: Date()
            )
        ]
    }
}

