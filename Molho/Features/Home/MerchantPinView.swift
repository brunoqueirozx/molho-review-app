import SwiftUI

struct MerchantPinView: View {
    let merchant: Merchant

    private var emoji: String {
        let normalizedCategories = merchant.categories?.map { $0.lowercased() } ?? []

        let barKeywords = [
            "bar", "boteco", "pub", "cervej", "drink", "coquetel"
        ]

        if normalizedCategories.contains(where: { category in
            barKeywords.contains(where: { keyword in category.contains(keyword) })
        }) {
            return "🍸"
        }

        return "🍽️"
    }

    private var criticRatingText: String {
        guard let rating = merchant.criticRating else { return "--" }
        return String(format: "%.1f", rating)
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 10) {
                    Text(emoji)
                        .font(.system(size: 24))

                    VStack(alignment: .leading, spacing: 6) {
                        Text(merchant.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                            .lineLimit(1)

                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Theme.accentGold)

                            Text(criticRatingText)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Theme.textPrimary)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.96))
            .overlay {
                RoundedRectangle(cornerRadius: Theme.corner12, style: .continuous)
                    .stroke(Color.black.opacity(0.05))
            }
            .clipShape(RoundedRectangle(cornerRadius: Theme.corner12, style: .continuous))
            .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 12)

            PinPointer()
                .fill(Color.white.opacity(0.96))
                .frame(width: 18, height: 10)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

private struct PinPointer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

