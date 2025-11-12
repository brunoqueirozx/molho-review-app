import Foundation
import Combine

@MainActor
class ReviewsListViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var averageRating: Double = 0.0
    
    private let reviewRepository: ReviewRepository
    private let merchant: Merchant
    
    init(merchant: Merchant, reviewRepository: ReviewRepository) {
        self.merchant = merchant
        self.reviewRepository = reviewRepository
    }
    
    convenience init(merchant: Merchant) {
        self.init(merchant: merchant, reviewRepository: FirebaseReviewRepository())
    }
    
    func loadReviews() async {
        isLoading = true
        errorMessage = nil
        
        do {
            reviews = try await reviewRepository.fetchReviews(for: merchant.id)
            averageRating = try await reviewRepository.calculateAverageRating(for: merchant.id)
            isLoading = false
            print("✅ \(reviews.count) avaliações carregadas. Média: \(averageRating)")
        } catch {
            isLoading = false
            errorMessage = "Erro ao carregar avaliações"
            print("❌ Erro ao carregar avaliações: \(error.localizedDescription)")
        }
    }
}

