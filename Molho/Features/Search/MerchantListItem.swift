import SwiftUI

struct MerchantListItem: View {
    let merchant: Merchant
    
    var body: some View {
        HStack(spacing: 10) {
            // Imagem à esquerda (96x96, rounded 24px)
            Group {
                if let imageUrl = merchant.headerImageUrl, !imageUrl.isEmpty {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            // Loading
                            RoundedRectangle(cornerRadius: Theme.corner24)
                                .fill(Color.gray.opacity(0.2))
                                .overlay {
                                    ProgressView()
                                        .tint(.gray)
                                }
                        case .success(let image):
                            // Imagem carregada - crop quadrado
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 96, height: 96)
                                .clipShape(RoundedRectangle(cornerRadius: Theme.corner24))
                        case .failure:
                            // Erro ao carregar - placeholder
                            RoundedRectangle(cornerRadius: Theme.corner24)
                                .fill(Color.gray.opacity(0.3))
                                .overlay {
                                    Image(systemName: "photo")
                                        .font(.system(size: 32))
                                        .foregroundColor(.gray.opacity(0.6))
                                }
                        @unknown default:
                            // Fallback
                            RoundedRectangle(cornerRadius: Theme.corner24)
                                .fill(Color.gray.opacity(0.3))
                        }
                    }
                    .frame(width: 96, height: 96)
                } else {
                    // Sem imagem - placeholder
                    RoundedRectangle(cornerRadius: Theme.corner24)
                        .fill(Color.gray.opacity(0.3))
                        .overlay {
                            Image(systemName: "photo")
                                .font(.system(size: 32))
                                .foregroundColor(.gray.opacity(0.6))
                        }
                        .frame(width: 96, height: 96)
                }
            }
            
            // Conteúdo à direita
            VStack(alignment: .leading, spacing: Theme.spacing8) {
                // Nome do estabelecimento (semibold, 17px)
                Text(merchant.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                    .tracking(-0.43)
                
                // Tags: categoria • estilo
                HStack(spacing: Theme.spacing8) {
                    if let category = merchant.category {
                        Text(category)
                            .font(.system(size: 17))
                            .foregroundStyle(Theme.textNeutral)
                            .tracking(-0.43)
                        
                        Circle()
                            .fill(Theme.textNeutral)
                            .frame(width: 3, height: 3)
                    }
                    
                    if let style = merchant.style {
                        Text(style)
                            .font(.system(size: 17))
                            .foregroundStyle(Theme.textNeutral)
                            .tracking(-0.43)
                    }
                }
                
                // Reviews: star, bubble, eye, bookmark
                HStack(spacing: Theme.spacing16) {
                    MerchantMetricItem(icon: "star.fill", value: String(format: "%.1f", merchant.rating ?? 0.0))
                    MerchantMetricItem(icon: "bubble.left", value: String(format: "%.1f", merchant.reviewsCount ?? 0.0))
                    MerchantMetricItem(icon: "eye", value: "\(merchant.viewsCount ?? 0)")
                    MerchantMetricItem(icon: "bookmark", value: "\(merchant.bookmarksCount ?? 0)")
                }
            }
            
            Spacer()
        }
    }
}

struct MerchantMetricItem: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundStyle(Theme.accentGold)
            Text(value)
                .font(.system(size: 15))
                .foregroundStyle(Theme.textNeutral)
        }
    }
}

