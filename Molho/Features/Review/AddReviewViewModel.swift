import Foundation
import Combine

@MainActor
class AddReviewViewModel: ObservableObject {
    @Published var rating: Int = 0
    @Published var comment: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let reviewRepository: ReviewRepository
    private let merchant: Merchant
    private var existingReview: Review?
    
    var isEditing: Bool {
        existingReview != nil
    }
    
    var canSubmit: Bool {
        rating > 0 && !isLoading
    }
    
    init(merchant: Merchant, reviewRepository: ReviewRepository) {
        self.merchant = merchant
        self.reviewRepository = reviewRepository
    }
    
    convenience init(merchant: Merchant) {
        self.init(merchant: merchant, reviewRepository: FirebaseReviewRepository())
    }
    
    // MARK: - Load Existing Review
    
    func loadExistingReview(userId: String) async {
        do {
            existingReview = try await reviewRepository.fetchUserReview(
                userId: userId,
                merchantId: merchant.id
            )
            
            if let review = existingReview {
                rating = review.rating
                comment = review.comment ?? ""
                print("✅ Avaliação existente carregada: \(review.id)")
            }
        } catch {
            print("❌ Erro ao carregar avaliação existente: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Submit Review
    
    func submitReview(userId: String, userName: String, userAvatarUrl: String?) async {
        guard canSubmit else {
            errorMessage = "Por favor, selecione uma quantidade de estrelas"
            return
        }
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            if let existing = existingReview {
                // Atualizar avaliação existente
                var updatedReview = existing
                updatedReview.rating = rating
                updatedReview.comment = comment.isEmpty ? nil : comment
                
                try await reviewRepository.updateReview(updatedReview)
                successMessage = "Avaliação atualizada com sucesso!"
                print("✅ Avaliação atualizada: \(updatedReview.id)")
            } else {
                // Criar nova avaliação
                let newReview = Review(
                    merchantId: merchant.id,
                    userId: userId,
                    userName: userName,
                    userAvatarUrl: userAvatarUrl,
                    rating: rating,
                    comment: comment.isEmpty ? nil : comment
                )
                
                try await reviewRepository.addReview(newReview)
                successMessage = "Avaliação enviada com sucesso!"
                print("✅ Nova avaliação criada: \(newReview.id)")
            }
            
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Erro ao enviar avaliação. Tente novamente."
            print("❌ Erro ao enviar avaliação: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete Review
    
    func deleteReview() async {
        guard let review = existingReview else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await reviewRepository.deleteReview(reviewId: review.id)
            successMessage = "Avaliação removida com sucesso!"
            
            // Limpar campos
            rating = 0
            comment = ""
            existingReview = nil
            
            isLoading = false
            print("✅ Avaliação deletada: \(review.id)")
        } catch {
            isLoading = false
            errorMessage = "Erro ao remover avaliação. Tente novamente."
            print("❌ Erro ao deletar avaliação: \(error.localizedDescription)")
        }
    }
}

