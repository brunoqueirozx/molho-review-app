import Foundation
import MapKit
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    private let repository: MerchantRepository

    @Published var merchants: [Merchant] = []

    init(repository: MerchantRepository = MerchantRepositoryStub()) {
        self.repository = repository
        Task { @MainActor in
            loadNearby()
        }
    }

    func loadNearby() {
        // Futuramente chamará Firestore via repository
        merchants = repository.fetchMerchantsNear(latitude: -23.56, longitude: -46.68, radiusMeters: 1000)
    }
}

