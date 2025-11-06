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

final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var displayedResults: [Merchant] = []
    @Published var allResults: [Merchant] = []
    @Published var selectedFilter: SearchScope = .all
    @Published var showingAll: Bool = false
    
    private let repository: MerchantRepository
    private let maxInitialResults = 10

    init(repository: MerchantRepository = FirebaseMerchantRepository()) {
        self.repository = repository
        loadAllMerchants()
    }

    func loadAllMerchants() {
        // Futuramente chamará Firestore via repository
        // Por enquanto, carrega todos os merchants disponíveis
        allResults = repository.searchMerchants(query: "")
        updateDisplayedResults()
    }
    
    func search() {
        // Futuramente chamará Firestore via repository
        if query.isEmpty {
            // Se a query estiver vazia, mostra todos os merchants
            allResults = repository.searchMerchants(query: "")
        } else {
            // Se houver query, filtra os resultados
            allResults = repository.searchMerchants(query: query)
        }
        showingAll = false
        updateDisplayedResults()
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

