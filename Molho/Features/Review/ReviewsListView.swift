import SwiftUI

struct ReviewsListView: View {
    let merchant: Merchant
    @StateObject private var viewModel: ReviewsListViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(merchant: Merchant) {
        self.merchant = merchant
        _viewModel = StateObject(wrappedValue: ReviewsListViewModel(merchant: merchant))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading && viewModel.reviews.isEmpty {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.primaryGreen))
                } else if viewModel.reviews.isEmpty {
                    VStack(spacing: Theme.spacing16) {
                        Image(systemName: "star")
                            .font(.system(size: 48))
                            .foregroundStyle(Color.gray.opacity(0.5))
                        
                        Text("Nenhuma avaliação ainda")
                            .font(.system(size: 17))
                            .foregroundStyle(Theme.textNeutral)
                        
                        Text("Seja o primeiro a avaliar!")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.gray.opacity(0.7))
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: Theme.spacing16) {
                            // Resumo das avaliações
                            VStack(spacing: Theme.spacing16) {
                                HStack(alignment: .firstTextBaseline, spacing: Theme.spacing8) {
                                    Text(String(format: "%.1f", viewModel.averageRating))
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundStyle(Color(hex: "#1f1f1f"))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(spacing: 4) {
                                            ForEach(0..<5) { index in
                                                Image(systemName: index < Int(viewModel.averageRating.rounded()) ? "star.fill" : "star")
                                                    .font(.system(size: 16))
                                                    .foregroundStyle(Color(hex: "#FFD700"))
                                            }
                                        }
                                        
                                        Text("\(viewModel.reviews.count) avaliações")
                                            .font(.system(size: 15))
                                            .foregroundStyle(Theme.textNeutral)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Theme.spacing24)
                            }
                            .background(Color(hex: "#F5F5F5"))
                            .cornerRadius(Theme.corner12)
                            .padding(.horizontal, Theme.spacing16)
                            .padding(.top, Theme.spacing16)
                            
                            // Lista de avaliações
                            ForEach(viewModel.reviews) { review in
                                ReviewItemView(review: review)
                                    .padding(.horizontal, Theme.spacing16)
                                
                                Divider()
                                    .padding(.horizontal, Theme.spacing16)
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Theme.primaryGreen))
                                    .padding(.vertical, Theme.spacing16)
                            }
                        }
                        .padding(.bottom, Theme.spacing24)
                    }
                    .refreshable {
                        await viewModel.loadReviews()
                    }
                }
            }
            .navigationTitle("Avaliações")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(hex: "#1f1f1f"))
                    }
                }
            }
            .task {
                await viewModel.loadReviews()
            }
        }
    }
}

struct ReviewItemView: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing12) {
            // Header com avatar e nome
            HStack(spacing: Theme.spacing12) {
                // Avatar
                if let avatarUrl = review.userAvatarUrl, let url = URL(string: avatarUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        default:
                            Circle()
                                .fill(Theme.primaryGreen.opacity(0.2))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(String(review.userName.prefix(1)).uppercased())
                                        .font(.system(size: 17, weight: .medium))
                                        .foregroundStyle(Theme.primaryGreen)
                                )
                        }
                    }
                } else {
                    Circle()
                        .fill(Theme.primaryGreen.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(String(review.userName.prefix(1)).uppercased())
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(Theme.primaryGreen)
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(review.userName)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color(hex: "#1f1f1f"))
                    
                    if let createdAt = review.createdAt {
                        Text(formatDate(createdAt))
                            .font(.system(size: 13))
                            .foregroundStyle(Theme.textNeutral)
                    }
                }
                
                Spacer()
            }
            
            // Estrelas
            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Image(systemName: index < review.rating ? "star.fill" : "star")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "#FFD700"))
                }
            }
            
            // Comentário
            if let comment = review.comment, !comment.isEmpty {
                Text(comment)
                    .font(.system(size: 15))
                    .foregroundStyle(Color(hex: "#3d3d3d"))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, Theme.spacing8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    ReviewsListView(merchant: Merchant(
        id: "1",
        name: "Restaurante Exemplo",
        latitude: 0,
        longitude: 0
    ))
}

