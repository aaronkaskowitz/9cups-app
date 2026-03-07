import SwiftUI

struct CategoryCardView: View {
    let emoji: String
    let name: String
    let current: Int
    let target: Int
    let unit: String
    let isCheckbox: Bool
    let isChecked: Bool
    let categoryKey: CategoryKey?
    let onIncrement: () -> Void
    let onDecrement: () -> Void

    @State private var showInfo = false

    init(
        emoji: String,
        name: String,
        current: Int,
        target: Int,
        unit: String = "cups",
        isCheckbox: Bool = false,
        isChecked: Bool = false,
        categoryKey: CategoryKey? = nil,
        onIncrement: @escaping () -> Void,
        onDecrement: @escaping () -> Void = {}
    ) {
        self.emoji = emoji
        self.name = name
        self.current = current
        self.target = target
        self.unit = unit
        self.isCheckbox = isCheckbox
        self.isChecked = isChecked
        self.categoryKey = categoryKey
        self.onIncrement = onIncrement
        self.onDecrement = onDecrement
    }

    private var progress: Double {
        guard target > 0 else { return 0 }
        return min(Double(current) / Double(target), 1.0)
    }

    private var isMet: Bool {
        isCheckbox ? isChecked : current >= target
    }

    var body: some View {
        HStack(spacing: 12) {
            // Emoji
            Text(emoji)
                .font(.system(size: 28))
                .frame(width: 44, height: 44)
                .accessibilityHidden(true)

            // Name + progress
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(name)
                        .font(CupsTheme.labelFont(15))
                        .foregroundColor(CupsTheme.textPrimary)

                    if categoryKey != nil {
                        Button {
                            showInfo = true
                        } label: {
                            Image(systemName: "info.circle")
                                .font(.system(size: 14))
                                .foregroundColor(CupsTheme.textSecondary.opacity(0.5))
                        }
                        .buttonStyle(.plain)
                    }
                }

                if isCheckbox {
                    Text(isChecked ? "Done" : "Not yet")
                        .font(CupsTheme.bodyFont(13))
                        .foregroundColor(isChecked ? CupsTheme.primaryAccent : CupsTheme.textSecondary)
                        .animation(.easeInOut(duration: 0.3), value: isChecked)
                } else {
                    // Progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(CupsTheme.background)
                                .frame(height: 6)
                            Capsule()
                                .fill(isMet ? CupsTheme.primaryAccent : CupsTheme.secondaryAccent)
                                .frame(width: geo.size.width * progress, height: 6)
                                .animation(.easeInOut(duration: 0.3), value: progress)
                        }
                    }
                    .frame(height: 6)

                    Text("\(current) / \(target) \(unit)")
                        .font(CupsTheme.bodyFont(13))
                        .foregroundColor(CupsTheme.textSecondary)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.3), value: current)
                }
            }

            Spacer()

            // Action buttons
            if isCheckbox {
                Button(action: { UIImpactFeedbackGenerator(style: .medium).impactOccurred(); onIncrement() }) {
                    Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 28))
                        .foregroundColor(isChecked ? CupsTheme.primaryAccent : CupsTheme.textSecondary)
                }
                .frame(minWidth: 48, minHeight: 48)
                .accessibilityLabel(isChecked ? "\(name) completed" : "Mark \(name) as done")
                .accessibilityHint("Double tap to toggle")
            } else {
                HStack(spacing: 8) {
                    Button(action: { UIImpactFeedbackGenerator(style: .light).impactOccurred(); onDecrement() }) {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 22))
                            .foregroundColor(current > 0 ? CupsTheme.textSecondary : CupsTheme.textSecondary.opacity(0.3))
                    }
                    .frame(minWidth: 48, minHeight: 48)
                    .disabled(current <= 0)
                    .accessibilityLabel("Remove one \(unit) of \(name)")
                    .accessibilityHint("Double tap to decrease by one")

                    Button(action: { UIImpactFeedbackGenerator(style: .light).impactOccurred(); onIncrement() }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(CupsTheme.primaryAccent)
                    }
                    .frame(minWidth: 48, minHeight: 48)
                    .accessibilityLabel("Add one \(unit) of \(name)")
                    .accessibilityHint("Double tap to increase by one")
                }
            }
        }
        .padding(14)
        .background(CupsTheme.cardBackground)
        .cornerRadius(CupsTheme.cornerRadius)
        .accessibilityElement(children: .contain)
        .sheet(isPresented: $showInfo) {
            if let key = categoryKey {
                CategoryInfoSheet(info: CategoryInfo.forKey(key))
            }
        }
    }
}
