import SwiftUI

struct CupsTheme {
    // MARK: - Colors
    static let background = Color(hex: "1a2e1a")
    static let cardBackground = Color(hex: "2d4a2d")
    static let primaryAccent = Color(hex: "7fda85")
    static let secondaryAccent = Color(hex: "f5c542")
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)

    // Ring colors
    static let ringGreen = Color(hex: "4ade80")
    static let ringOrange = Color(hex: "fb923c")
    static let ringRed = Color(hex: "f87171")
    static let ringPurple = Color(hex: "a78bfa")
    static let ringWhite = Color(hex: "e2e8f0")

    // MARK: - Corner Radii
    static let cornerRadius: CGFloat = 16
    static let cornerRadiusSmall: CGFloat = 10
    static let cornerRadiusLarge: CGFloat = 24

    // MARK: - Typography
    static func headerFont(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func bodyFont(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    static func labelFont(_ size: CGFloat = 14) -> Font {
        .system(size: size, weight: .medium, design: .rounded)
    }

    // MARK: - Shadows
    static let cardShadow = Shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    static let glowShadow = Shadow(color: primaryAccent.opacity(0.4), radius: 12, x: 0, y: 0)

    struct Shadow {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }
}

// MARK: - View Modifiers

struct CupsCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(CupsTheme.cardBackground)
            .cornerRadius(CupsTheme.cornerRadius)
            .shadow(
                color: CupsTheme.cardShadow.color,
                radius: CupsTheme.cardShadow.radius,
                x: CupsTheme.cardShadow.x,
                y: CupsTheme.cardShadow.y
            )
    }
}

extension View {
    func cupsCard() -> some View {
        modifier(CupsCard())
    }
}

// MARK: - Color Hex Init

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
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
