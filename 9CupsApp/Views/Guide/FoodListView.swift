import SwiftUI

struct FoodListView: View {
    let category: FoodCategory
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header (tappable)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(category.emoji)
                        .font(.system(size: 22))
                        .accessibilityHidden(true)

                    Text("What counts as \(category.name.lowercased())?")
                        .font(CupsTheme.labelFont(15))
                        .foregroundColor(CupsTheme.textPrimary)

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(CupsTheme.textSecondary)
                }
                .padding(14)
                .frame(minHeight: 48)
            }
            .accessibilityLabel("\(category.name) food list")
            .accessibilityHint(isExpanded ? "Collapse list" : "Expand list")

            // Food list (expandable)
            if isExpanded {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(category.foods, id: \.self) { food in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(CupsTheme.primaryAccent.opacity(0.5))
                                .frame(width: 6, height: 6)
                                .accessibilityHidden(true)
                            Text(food)
                                .font(CupsTheme.bodyFont(14))
                                .foregroundColor(CupsTheme.textPrimary.opacity(0.85))
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(CupsTheme.cardBackground)
        .cornerRadius(CupsTheme.cornerRadius)
        .padding(.horizontal, 16)
    }
}
