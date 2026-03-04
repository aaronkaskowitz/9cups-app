import SwiftUI

// MARK: - Celebration Particle
private struct SparkParticle: View {
    let color: Color
    let angle: Double
    let delay: Double

    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 0

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 7, height: 7)
            .offset(y: -offset)
            .rotationEffect(.degrees(angle))
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.7).delay(delay)) {
                    offset = 130
                    opacity = 1
                }
                withAnimation(.easeIn(duration: 0.35).delay(delay + 0.45)) {
                    opacity = 0
                }
            }
    }
}

// MARK: - ColorRingView
struct ColorRingView: View {
    let leafyGreens: Int
    let redPurple: Int
    let orangeYellow: Int
    let blueBlack: Int
    let sulfurRich: Int
    let totalCups: Int
    let isComplete: Bool
    let seaweed: Bool
    let fermented: Bool

    @State private var glowPulse = false
    @State private var ringScale: CGFloat = 1.0
    @State private var celebrationID = UUID()
    @State private var showParticles = false
    @State private var wasComplete = false

    private let ringWidth: CGFloat = 20

    private let rainbowColors: [Color] = [
        Color(red: 0.29, green: 0.87, blue: 0.5),   // green
        Color(red: 0.94, green: 0.27, blue: 0.27),  // red
        Color(red: 0.96, green: 0.62, blue: 0.04),  // orange
        Color(red: 0.96, green: 0.90, blue: 0.04),  // yellow
        Color(red: 0.39, green: 0.4,  blue: 0.95),  // blue
        Color(red: 0.18, green: 0.83, blue: 0.75),  // teal
        Color(red: 0.65, green: 0.55, blue: 0.98),  // purple
        Color(red: 0.29, green: 0.87, blue: 0.5),   // green again
        Color(red: 0.94, green: 0.27, blue: 0.27),  // red again
        Color(red: 0.96, green: 0.62, blue: 0.04),  // orange again
        Color(red: 0.18, green: 0.83, blue: 0.75),  // teal again
        Color(red: 0.65, green: 0.55, blue: 0.98),  // purple again
    ]

    // Fractions (each category out of its target)
    private var leafyFrac: Double { min(Double(leafyGreens) / 3.0, 1.0) }
    private var redFrac: Double { min(Double(redPurple) / 1.0, 1.0) }
    private var orangeFrac: Double { min(Double(orangeYellow) / 1.0, 1.0) }
    private var blueFrac: Double { min(Double(blueBlack) / 1.0, 1.0) }
    private var sulfurFrac: Double { min(Double(sulfurRich) / 3.0, 1.0) }
    private var seaweedFrac: Double { seaweed ? 1.0 : 0.0 }
    private var fermentedFrac: Double { fermented ? 1.0 : 0.0 }

    // 7 segments: leafy(105), red(40), orange(40), blue(40), sulfur(105), seaweed(15), fermented(15) = 360
    private let gap: Double = 3

    private var segments: [(start: Double, span: Double, fraction: Double, color: Color)] {
        let leafySpan = 105.0
        let redSpan = 40.0
        let orangeSpan = 40.0
        let blueSpan = 40.0
        let sulfurSpan = 105.0
        let seaweedSpan = 15.0
        let fermentedSpan = 15.0

        var pos = 0.0
        var segs: [(Double, Double, Double, Color)] = []

        segs.append((pos + gap/2, leafySpan - gap, leafyFrac, Color(red: 0.29, green: 0.87, blue: 0.5)))
        pos += leafySpan
        segs.append((pos + gap/2, redSpan - gap, redFrac, Color(red: 0.94, green: 0.27, blue: 0.27)))
        pos += redSpan
        segs.append((pos + gap/2, orangeSpan - gap, orangeFrac, Color(red: 0.96, green: 0.62, blue: 0.04)))
        pos += orangeSpan
        segs.append((pos + gap/2, blueSpan - gap, blueFrac, Color(red: 0.39, green: 0.4, blue: 0.95)))
        pos += blueSpan
        segs.append((pos + gap/2, sulfurSpan - gap, sulfurFrac, Color(red: 0.78, green: 0.72, blue: 0.58)))
        pos += sulfurSpan
        segs.append((pos + gap/2, seaweedSpan - gap, seaweedFrac, Color(red: 0.18, green: 0.83, blue: 0.75)))
        pos += seaweedSpan
        segs.append((pos + gap/2, fermentedSpan - gap, fermentedFrac, Color(red: 0.65, green: 0.55, blue: 0.98)))

        return segs
    }

    var body: some View {
        ZStack {
            // Background ring segments (dimmed)
            ForEach(Array(segments.enumerated()), id: \.offset) { _, seg in
                ArcShape(
                    startAngle: .degrees(seg.start),
                    endAngle: .degrees(seg.start + seg.span),
                    lineWidth: ringWidth
                )
                .stroke(seg.color.opacity(0.12), style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                .frame(width: 200, height: 200)
            }

            // Filled arcs
            ForEach(Array(segments.enumerated()), id: \.offset) { _, seg in
                if seg.fraction > 0 {
                    ArcShape(
                        startAngle: .degrees(seg.start),
                        endAngle: .degrees(seg.start + seg.span * seg.fraction),
                        lineWidth: ringWidth
                    )
                    .stroke(seg.color, style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                    .frame(width: 200, height: 200)
                }
            }

            // Glow effect when complete
            if isComplete {
                Circle()
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.29, green: 0.87, blue: 0.5),
                                Color(red: 0.94, green: 0.27, blue: 0.27),
                                Color(red: 0.96, green: 0.62, blue: 0.04),
                                Color(red: 0.39, green: 0.4, blue: 0.95),
                                Color(red: 0.78, green: 0.72, blue: 0.58),
                                Color(red: 0.18, green: 0.83, blue: 0.75),
                                Color(red: 0.65, green: 0.55, blue: 0.98),
                                Color(red: 0.29, green: 0.87, blue: 0.5),
                            ]),
                            center: .center
                        ),
                        lineWidth: ringWidth + 8
                    )
                    .frame(width: 200, height: 200)
                    .opacity(glowPulse ? 0.5 : 0.2)
                    .blur(radius: 12)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                            glowPulse = true
                        }
                    }
            }

            // Celebration sparkle particles
            if showParticles {
                ZStack {
                    ForEach(Array(rainbowColors.enumerated()), id: \.offset) { index, color in
                        SparkParticle(
                            color: color,
                            angle: Double(index) * (360.0 / Double(rainbowColors.count)),
                            delay: Double(index) * 0.04
                        )
                    }
                }
                .id(celebrationID)
            }

            // Center text
            VStack(spacing: 4) {
                Text("\(totalCups) / 9")
                    .font(CupsTheme.headerFont(32))
                    .foregroundColor(CupsTheme.textPrimary)

                Text("cups")
                    .font(CupsTheme.labelFont(14))
                    .foregroundColor(CupsTheme.textSecondary)

                if isComplete {
                    Text("🌈 Complete!")
                        .font(CupsTheme.labelFont(12))
                        .foregroundColor(CupsTheme.secondaryAccent)
                        .padding(.top, 2)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .scaleEffect(ringScale)
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: 220)
        .onChange(of: isComplete) { _, newValue in
            if newValue && !wasComplete {
                triggerCelebration()
            }
            wasComplete = newValue
        }
        .onAppear {
            wasComplete = isComplete
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: leafyGreens)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: redPurple)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: orangeYellow)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: blueBlack)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: sulfurRich)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: seaweed)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: fermented)
        .animation(.easeInOut(duration: 0.5), value: isComplete)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Rainbow ring showing \(totalCups) of 9 cups. \(leafyGreens) leafy greens, \(redPurple) red, \(orangeYellow) orange, \(blueBlack) blue, \(sulfurRich) sulfur-rich. Seaweed \(seaweed ? "done" : "not yet"). Fermented \(fermented ? "done" : "not yet").")
    }

    private func triggerCelebration() {
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        // Ring bounce
        withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
            ringScale = 1.12
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.2)) {
            ringScale = 1.0
        }

        // Sparks burst
        celebrationID = UUID()
        showParticles = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showParticles = false
        }
    }
}

struct ArcShape: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var lineWidth: CGFloat

    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(startAngle.degrees, endAngle.degrees) }
        set {
            startAngle = .degrees(newValue.first)
            endAngle = .degrees(newValue.second)
        }
    }

    func path(in rect: CGRect) -> Path {
        guard endAngle > startAngle else { return Path() }
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle - .degrees(90),
            endAngle: endAngle - .degrees(90),
            clockwise: false
        )
        return path
    }
}
