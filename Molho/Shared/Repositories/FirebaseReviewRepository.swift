import Foundation
import Combine

#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

@MainActor
class FirebaseReviewRepository: ReviewRepository {
    private let db = Firestore.firestore()
    private let reviewsCollection = "reviews"
    
    // MARK: - Add Review
    
    func addReview(_ review: Review) async throws {
        do {
            let reviewData = try Firestore.Encoder().encode(review)
            try await db.collection(reviewsCollection).document(review.id).setData(reviewData)
            
            // Atualizar as métricas do estabelecimento
            try await updateMerchantMetrics(merchantId: review.merchantId)
            
            print("✅ Avaliação adicionada com sucesso: \(review.id)")
        } catch {
            print("❌ Erro ao adicionar avaliação: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Update Review
    
    func updateReview(_ review: Review) async throws {
        do {
            var updatedReview = review
            updatedReview.updatedAt = Date()
            
            let reviewData = try Firestore.Encoder().encode(updatedReview)
            try await db.collection(reviewsCollection).document(review.id).setData(reviewData)
            
            // Atualizar as métricas do estabelecimento
            try await updateMerchantMetrics(merchantId: review.merchantId)
            
            print("✅ Avaliação atualizada com sucesso: \(review.id)")
        } catch {
            print("❌ Erro ao atualizar avaliação: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Delete Review
    
    func deleteReview(reviewId: String) async throws {
        do {
            // Primeiro buscar a avaliação para saber qual merchant atualizar
            let document = try await db.collection(reviewsCollection).document(reviewId).getDocument()
            
            if let data = document.data(),
               let merchantId = data["merchantId"] as? String {
                // Deletar a avaliação
                try await db.collection(reviewsCollection).document(reviewId).delete()
                
                // Atualizar as métricas do estabelecimento
                try await updateMerchantMetrics(merchantId: merchantId)
                
                print("✅ Avaliação deletada com sucesso: \(reviewId)")
            }
        } catch {
            print("❌ Erro ao deletar avaliação: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Fetch Reviews
    
    func fetchReviews(for merchantId: String) async throws -> [Review] {
        do {
            let snapshot = try await db.collection(reviewsCollection)
                .whereField("merchantId", isEqualTo: merchantId)
                .order(by: "createdAt", descending: true)
                .getDocuments()
            
            let reviews = try snapshot.documents.compactMap { document -> Review? in
                try document.data(as: Review.self)
            }
            
            print("✅ \(reviews.count) avaliações encontradas para o estabelecimento: \(merchantId)")
            return reviews
        } catch {
            print("❌ Erro ao buscar avaliações: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Fetch User Reviews
    
    func fetchUserReviews(userId: String) async throws -> [Review] {
        do {
            let snapshot = try await db.collection(reviewsCollection)
                .whereField("userId", isEqualTo: userId)
                .order(by: "createdAt", descending: true)
                .getDocuments()
            
            let reviews = try snapshot.documents.compactMap { document -> Review? in
                try document.data(as: Review.self)
            }
            
            print("✅ \(reviews.count) avaliações encontradas do usuário: \(userId)")
            return reviews
        } catch {
            print("❌ Erro ao buscar avaliações do usuário: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Fetch User Review for Merchant
    
    func fetchUserReview(userId: String, merchantId: String) async throws -> Review? {
        do {
            let snapshot = try await db.collection(reviewsCollection)
                .whereField("userId", isEqualTo: userId)
                .whereField("merchantId", isEqualTo: merchantId)
                .limit(to: 1)
                .getDocuments()
            
            guard let document = snapshot.documents.first else {
                print("ℹ️ Nenhuma avaliação encontrada para usuário \(userId) no estabelecimento \(merchantId)")
                return nil
            }
            
            let review = try document.data(as: Review.self)
            print("✅ Avaliação encontrada: \(review.id)")
            return review
        } catch {
            print("❌ Erro ao buscar avaliação do usuário: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Calculate Average Rating
    
    func calculateAverageRating(for merchantId: String) async throws -> Double {
        do {
            let reviews = try await fetchReviews(for: merchantId)
            
            guard !reviews.isEmpty else {
                return 0.0
            }
            
            let sum = reviews.reduce(0) { $0 + $1.rating }
            let average = Double(sum) / Double(reviews.count)
            
            print("✅ Média de avaliações calculada: \(average) (\(reviews.count) avaliações)")
            return average
        } catch {
            print("❌ Erro ao calcular média de avaliações: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Count Reviews
    
    func countReviews(for merchantId: String) async throws -> Int {
        do {
            let snapshot = try await db.collection(reviewsCollection)
                .whereField("merchantId", isEqualTo: merchantId)
                .count
                .getAggregation(source: .server)
            
            let count = Int(truncating: snapshot.count)
            print("✅ Total de avaliações: \(count)")
            return count
        } catch {
            print("❌ Erro ao contar avaliações: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func updateMerchantMetrics(merchantId: String) async throws {
        do {
            let average = try await calculateAverageRating(for: merchantId)
            let count = try await countReviews(for: merchantId)
            
            // Atualizar o documento do merchant
            try await db.collection("merchants").document(merchantId).updateData([
                "publicRating": average,
                "reviewsCount": count,
                "updatedAt": Timestamp(date: Date())
            ])
            
            print("✅ Métricas do estabelecimento atualizadas: rating=\(average), count=\(count)")
        } catch {
            print("❌ Erro ao atualizar métricas do estabelecimento: \(error.localizedDescription)")
            throw error
        }
    }
}

