import SwiftUI

struct ColorGroupCardView: View {
    let redPurple: Int
    let orangeYellow: Int
    let blueBlack: Int
    let onAddRed: () -> Void
    let onAddOrange: () -> Void
    let onAddBlue: () -> Void
    let onDecRed: () -> Void
    let onDecOrange: () -> Void
    let onDecBlue: () -> Void

    private var totalColored: Int { redPurple + orangeYellow + blueBlack }
    private var colorsEaten: Int {
        var count = 0
        if redPurple > 0 { count += 1 }
        if orangeYellow > 0 { count += 1 }
        if blueBlack > 0 { count += 1 }
        return count
    }
    private var progressFraction: Double { min(Double(totalColored) / 3.0, 1.0) }

    var body: some View {
        VStack(spacing: 0) {
            // Header: title + combined progress + color dots
            HStack {
                Text("\u{1F308}")
                    .font(.system(size: 20))
                Text("Colored Produce")
                    .font(CupsTheme.bodyFont(14).bold())
                    .foregroundColor(CupsTheme.textPrimary)

                Spacer()

                // Color diversity dots
                HStack(spacing: 6) {
                    Circle()
                        .fill(redPurple > 0 ? Color(red: 0.94, green: 0.27, blue: 0.27) : Color.white.opacity(0.15))
                        .frame(width: 10, height: 10)
                    Circle()
                        .fill(orangeYellow > 0 ? Color(red: 0.96, green: 0.62, blue: 0.04) : Color.white.opacity(0.15))
                        .frame(width: 10, height: 10)
                    Circle()
                        .fill(blueBlack > 0 ? Color(red: 0.39, green: 0.4, blue: 0.95) : Color.white.opacity(0.15))
                        .frame(width: 10, height: 10)
                }

                Text("\(totalColored) / 3")
                    .font(CupsTheme.labelFont(13))
                    .foregroundColor(totalColored >= 3 ? CupsTheme.primaryAccent : CupsTheme.textSecondary)
                    .padding(.leading, 6)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // Combined progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 6)

                    // Stacked colored segments
                    HStack(spacing: 0) {
                        if redPurple > 0 {
                            Rectangle()
                                .fill(Color(red: 0.94, green: 0.27, blue: 0.27))
                                .frame(width: geo.size.width * min(Double(redPurple) / 3.0, 1.0))
                        }
                        if orangeYellow > 0 {
                            Rectangle()
                                .fill(Color(red: 0.96, green: 0.62, blue: 0.04))
                                .frame(width: geo.size.width * min(Double(orangeYellow) / 3.0, 1.0))
                        }
                        if blueBlack > 0 {
                            Rectangle()
                                .fill(Color(red: 0.39, green: 0.4, blue: 0.95))
                                .frame(width: geo.size.width * min(Double(blueBlack) / 3.0, 1.0))
                        }
                    }
                    .frame(height: 6)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 16)
            .padding(.bottom, 10)

            // Divider
            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 1)

            // Three sub-rows
            colorRow(emoji: "\u{1F534}", name: "Red & Purple", count: redPurple, color: Color(red: 0.94, green: 0.27, blue: 0.27), onAdd: onAddRed, onDec: onDecRed)

            Rectangle()
                .fill(Color.white.opacity(0.04))
                .frame(height: 1)
                .padding(.leading, 48)

            colorRow(emoji: "\u{1F7E0}", name: "Orange & Yellow", count: orangeYellow, color: Color(red: 0.96, green: 0.62, blue: 0.04), onAdd: onAddOrange, onDec: onDecOrange)

            Rectangle()
                .fill(Color.white.opacity(0.04))
                .frame(height: 1)
                .padding(.leading, 48)

            colorRow(emoji: "\u{1F535}", name: "Blue & Black", count: blueBlack, color: Color(red: 0.39, green: 0.4, blue: 0.95), onAdd: onAddBlue, onDec: onDecBlue)
        }
        .background(CupsTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(totalColored >= 3 ? CupsTheme.primaryAccent.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func colorRow(emoji: String, name: String, count: Int, color: Color, onAdd: @escaping () -> Void, onDec: @escaping () -> Void) -> some View {
        HStack(spacing: 10) {
            Text(emoji)
                .font(.system(size: 16))

            Text(name)
                .font(CupsTheme.bodyFont(13))
                .foregroundColor(CupsTheme.textPrimary)

            Spacer()

            if count > 0 {
                Text("\(count)")
                    .font(CupsTheme.bodyFont(13).bold())
                    .foregroundColor(color)
            }

            HStack(spacing: 16) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    onDec()
                }) {
                    Text("\u{2212}")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(CupsTheme.textSecondary)
                        .frame(width: 36, height: 36)
                }
                .disabled(count == 0)
                .opacity(count == 0 ? 0.3 : 1)

                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    onAdd()
                }) {
                    Text("+")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(CupsTheme.primaryAccent)
                        .frame(width: 36, height: 36)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
