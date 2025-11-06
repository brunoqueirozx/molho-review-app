import Foundation
import Combine

enum SearchScope: String, CaseIterable {
    case all = "Todos"
    case favorites = "Favoritos"
    case drinkBars = "Bares de drink"
    case botecos = "Botecos"
    case izakayas = "Izakayas"
    
    var icon: String {
        switch self {
        case .all: return "list.bullet"
        case .favorites: return "heart.fill"
        case .drinkBars: return "🥃"
        case .botecos: return "🍺"
        case .izakayas: return "🥢"
        }
    }
}

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var displayedResults: [Merchant] = []
    @Published var allResults: [Merchant] = []
    @Published var selectedFilter: SearchScope = .all
    @Published var showingAll: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository: MerchantRepository
    private let maxInitialResults = 10

    init(repository: MerchantRepository? = nil) {
        #if canImport(FirebaseFirestore)
        self.repository = repository ?? FirebaseMerchantRepository()
        #else
        self.repository = repository ?? MerchantRepositoryStub()
        #endif
    }

    func loadAllMerchants() {
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                #if canImport(FirebaseFirestore)
                if let firebaseRepo = repository as? FirebaseMerchantRepository {
                    let merchants = try await firebaseRepo.searchMerchantsAsync(query: "")
                    self.allResults = merchants
                } else {
                    self.allResults = repository.searchMerchants(query: "")
                }
                #else
                self.allResults = repository.searchMerchants(query: "")
                #endif
                
                updateDisplayedResults()
                isLoading = false
            } catch {
                print("❌ Erro ao carregar merchants: \(error)")
                errorMessage = "Erro ao carregar estabelecimentos"
                isLoading = false
            }
        }
    }
    
    func search() {
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                #if canImport(FirebaseFirestore)
                if let firebaseRepo = repository as? FirebaseMerchantRepository {
                    let merchants = try await firebaseRepo.searchMerchantsAsync(query: query)
                    self.allResults = merchants
                } else {
                    self.allResults = repository.searchMerchants(query: query)
                }
                #else
                self.allResults = repository.searchMerchants(query: query)
                #endif
                
                showingAll = false
                updateDisplayedResults()
                isLoading = false
            } catch {
                print("❌ Erro ao buscar merchants: \(error)")
                errorMessage = "Erro ao buscar estabelecimentos"
                isLoading = false
            }
        }
    }
    
    func loadMore() {
        showingAll = true
        updateDisplayedResults()
    }
    
    private func updateDisplayedResults() {
        if showingAll || allResults.count <= maxInitialResults {
            displayedResults = allResults
        } else {
            displayedResults = Array(allResults.prefix(maxInitialResults))
        }
    }
    
    var hasMoreResults: Bool {
        return allResults.count > maxInitialResults && !showingAll
    }
}

