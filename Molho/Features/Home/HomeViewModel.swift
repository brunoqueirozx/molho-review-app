import Foundation
import MapKit
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    private let repository: MerchantRepository

    @Published var merchants: [Merchant] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(repository: MerchantRepository? = nil) {
        #if canImport(FirebaseFirestore)
        self.repository = repository ?? FirebaseMerchantRepository()
        #else
        self.repository = repository ?? MerchantRepositoryStub()
        #endif
        Task { @MainActor in
            loadNearby()
        }
    }

    func loadNearby() {
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                #if canImport(FirebaseFirestore)
                if let firebaseRepo = repository as? FirebaseMerchantRepository {
                    let nearbyMerchants = try await firebaseRepo.searchMerchantsAsync(query: "")
                    self.merchants = nearbyMerchants
                } else {
                    self.merchants = repository.fetchMerchantsNear(latitude: -23.56, longitude: -46.68, radiusMeters: 1000)
                }
                #else
                self.merchants = repository.fetchMerchantsNear(latitude: -23.56, longitude: -46.68, radiusMeters: 1000)
                #endif
                
                isLoading = false
            } catch {
                print("❌ Erro ao carregar merchants próximos: \(error)")
                errorMessage = "Erro ao carregar estabelecimentos"
                isLoading = false
            }
        }
    }
}

