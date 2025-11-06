import SwiftUI

enum Theme {
    static let spacing8: CGFloat = 8
    static let spacing12: CGFloat = 12
    static let spacing16: CGFloat = 16
    static let spacing24: CGFloat = 24
    static let spacing32: CGFloat = 32
    static let corner12: CGFloat = 12
    static let corner24: CGFloat = 24
    static let corner100: CGFloat = 100
    
    // Cores do Figma
    static let primaryGreen = Color(hex: "#496a3a")
    static let backgroundGray = Color(hex: "#e5e5e2")
    static let darkGray = Color(hex: "#4a4a4a")
    static let textPrimary = Color(hex: "#141414")
    static let textSecondary = Color(hex: "#3d3d3d")
    static let textNeutral = Color(hex: "#6b6b6b")
    static let accentGold = Color(hex: "#c3a575")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


