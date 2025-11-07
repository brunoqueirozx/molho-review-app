import Foundation
import MapKit
import Combine
import CoreLocation

@MainActor
final class HomeViewModel: ObservableObject {
    private let repository: MerchantRepository
    private var geocodeCache: [String: CLLocationCoordinate2D] = [:]

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
                    self.merchants = await resolveCoordinates(for: nearbyMerchants)
                } else {
                    let nearbyMerchants = repository.fetchMerchantsNear(latitude: -23.56, longitude: -46.68, radiusMeters: 1000)
                    self.merchants = await resolveCoordinates(for: nearbyMerchants)
                }
                #else
                let nearbyMerchants = repository.fetchMerchantsNear(latitude: -23.56, longitude: -46.68, radiusMeters: 1000)
                self.merchants = await resolveCoordinates(for: nearbyMerchants)
                #endif
                
                isLoading = false
            } catch {
                print("❌ Erro ao carregar merchants próximos: \(error)")
                errorMessage = "Erro ao carregar estabelecimentos"
                isLoading = false
            }
        }
    }

    private func resolveCoordinates(for merchants: [Merchant]) async -> [Merchant] {
        guard !merchants.isEmpty else { return merchants }
        var updatedMerchants = merchants

        for index in updatedMerchants.indices {
            guard !updatedMerchants[index].hasValidCoordinates,
                  let rawAddress = updatedMerchants[index].addressText,
                  !rawAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                continue
            }

            let formattedAddress = rawAddress.trimmingCharacters(in: .whitespacesAndNewlines)

            if let cachedCoordinate = geocodeCache[formattedAddress] {
                updatedMerchants[index].latitude = cachedCoordinate.latitude
                updatedMerchants[index].longitude = cachedCoordinate.longitude
                continue
            }

            if let coordinate = try? await geocode(address: formattedAddress) {
                geocodeCache[formattedAddress] = coordinate
                updatedMerchants[index].latitude = coordinate.latitude
                updatedMerchants[index].longitude = coordinate.longitude
            }
        }

        return updatedMerchants
    }

    private func geocode(address: String) async throws -> CLLocationCoordinate2D {
        try await withCheckedThrowingContinuation { continuation in
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = address

            let search = MKLocalSearch(request: request)
            search.start { response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                if let item = response?.mapItems.first {
                    // Prefer the new MapKit API: use the item's `location` for coordinates
                    let coord = item.location.coordinate
                    continuation.resume(returning: coord)
                    return
                } else {
                    continuation.resume(throwing: GeocodingError.notFound)
                }
            }
        }
    }
}

extension HomeViewModel {
    enum GeocodingError: Error {
        case notFound
    }
}

