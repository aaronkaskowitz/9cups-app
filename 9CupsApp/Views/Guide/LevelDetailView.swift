import SwiftUI

struct LevelDetailView: View {
    let level: ProtocolLevel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Level header
            VStack(alignment: .leading, spacing: 6) {
                Text("Level \(level.id): \(level.name)")
                    .font(CupsTheme.headerFont(20))
                    .foregroundColor(CupsTheme.primaryAccent)

                Text(level.description)
                    .font(CupsTheme.bodyFont(14))
                    .foregroundColor(CupsTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .cupsCard()
            .padding(.horizontal, 16)

            // Daily Targets
            sectionCard(title: "Daily Targets", items: level.dailyTargets, icon: "checkmark.circle.fill", iconColor: CupsTheme.primaryAccent)

            // Eliminate
            sectionCard(title: "Foods to Avoid", items: level.eliminate, icon: "xmark.circle.fill", iconColor: CupsTheme.ringRed.opacity(0.7))

            // Tips
            sectionCard(title: "Tips", items: level.tips, icon: "lightbulb.fill", iconColor: CupsTheme.secondaryAccent)
        }
    }

    private func sectionCard(title: String, items: [String], icon: String, iconColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(CupsTheme.headerFont(17))
                .foregroundColor(CupsTheme.textPrimary)

            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(iconColor)
                        .frame(width: 20, height: 20)
                        .accessibilityHidden(true)

                    Text(item)
                        .font(CupsTheme.bodyFont(14))
                        .foregroundColor(CupsTheme.textPrimary.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .cupsCard()
        .padding(.horizontal, 16)
        .accessibilityElement(children: .contain)
    }
}
