import Foundation
import Combine

@MainActor
protocol ReviewRepository {
    /// Adiciona uma nova avaliação
    func addReview(_ review: Review) async throws
    
    /// Atualiza uma avaliação existente
    func updateReview(_ review: Review) async throws
    
    /// Deleta uma avaliação
    func deleteReview(reviewId: String) async throws
    
    /// Busca todas as avaliações de um estabelecimento
    func fetchReviews(for merchantId: String) async throws -> [Review]
    
    /// Busca avaliações de um usuário específico
    func fetchUserReviews(userId: String) async throws -> [Review]
    
    /// Busca a avaliação de um usuário para um estabelecimento específico
    func fetchUserReview(userId: String, merchantId: String) async throws -> Review?
    
    /// Calcula a média de avaliações de um estabelecimento
    func calculateAverageRating(for merchantId: String) async throws -> Double
    
    /// Conta o total de avaliações de um estabelecimento
    func countReviews(for merchantId: String) async throws -> Int
}

