import SwiftUI

struct MerchantPinView: View {
    let merchant: Merchant

    private var emoji: String {
        // Prioridade 1: Emoji baseado no estilo
        if let style = merchant.style?.lowercased() {
            switch style {
            case "calmo":
                return "🧘"
            case "romântico", "romantico":
                return "💕"
            case "elegante":
                return "✨"
            case "casual":
                return "😊"
            case "moderno":
                return "🏙️"
            case "rústico", "rustico":
                return "🌾"
            case "tropical":
                return "🌴"
            case "industrial":
                return "🏭"
            case "aconchegante":
                return "🏠"
            case "sofisticado":
                return "🎩"
            default:
                break
            }
        }
        
        // Prioridade 2: Emoji baseado no tipo/categoria
        let normalizedCategories = merchant.categories?.map { $0.lowercased() } ?? []
        
        if normalizedCategories.contains(where: { $0.contains("bar") || $0.contains("pub") }) {
            return "🍸"
        }
        if normalizedCategories.contains(where: { $0.contains("pizzaria") || $0.contains("pizza") }) {
            return "🍕"
        }
        if normalizedCategories.contains(where: { $0.contains("café") || $0.contains("cafe") }) {
            return "☕"
        }
        if normalizedCategories.contains(where: { $0.contains("padaria") }) {
            return "🥖"
        }
        if normalizedCategories.contains(where: { $0.contains("fast food") }) {
            return "🍔"
        }
        if normalizedCategories.contains(where: { $0.contains("food truck") }) {
            return "🚚"
        }
        if normalizedCategories.contains(where: { $0.contains("bistrô") || $0.contains("bistro") }) {
            return "🍷"
        }
        if normalizedCategories.contains(where: { $0.contains("vinícola") || $0.contains("vinicola") }) {
            return "🍇"
        }

        // Padrão
        return "🍽️"
    }

    private var criticRatingText: String {
        // Prioridade: nota do crítico, depois nota pública
        let rating = merchant.criticRating ?? merchant.publicRating
        guard let rating = rating else { return "--" }
        return String(format: "%.1f", rating)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 24))

                Text(criticRatingText)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.96))
            .overlay {
                RoundedRectangle(cornerRadius: 100, style: .continuous)
                    .stroke(Color.black.opacity(0.05))
            }
            .clipShape(RoundedRectangle(cornerRadius: 100, style: .continuous))
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

