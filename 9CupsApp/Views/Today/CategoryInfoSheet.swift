import SwiftUI

// MARK: - CategoryKey

enum CategoryKey: String, CaseIterable {
    case leafyGreens
    case redPurple
    case orangeYellow
    case blueBlack
    case sulfurRich
    case protein
    case seaweed
    case fermented
    case organMeat
}

// MARK: - CategoryInfo

struct CategoryInfo {
    let emoji: String
    let name: String
    let target: String
    let why: String
    let foods: [String]
    let note: String?

    static func forKey(_ key: CategoryKey) -> CategoryInfo {
        switch key {
        case .leafyGreens:
            return CategoryInfo(
                emoji: "\u{1F96C}",
                name: "Leafy Greens",
                target: "3 cups daily",
                why: "Packed with folate, B vitamins, and minerals that support myelin repair and brain function. Dr. Wahls calls these the foundation of the protocol.",
                foods: ["Kale", "Spinach", "Swiss Chard", "Collard Greens", "Arugula", "Romaine", "Bok Choy", "Mustard Greens", "Turnip Greens", "Watercress", "Dandelion Greens", "Lettuce", "Microgreens"],
                note: nil
            )
        case .redPurple:
            return CategoryInfo(
                emoji: "\u{1F534}",
                name: "Red & Purple",
                target: "1 cup daily",
                why: "Rich in resveratrol and anthocyanins -- potent antioxidants that protect neurons and reduce inflammation throughout the nervous system.",
                foods: ["Beets", "Red Cabbage", "Blueberries", "Blackberries", "Raspberries", "Cherries", "Cranberries", "Pomegranate", "Plums", "Eggplant", "Purple Grapes", "Red Onion", "Radicchio", "Blood Orange", "Watermelon", "Strawberries"],
                note: "Must be colored all the way through. Apples and bananas don't count."
            )
        case .orangeYellow:
            return CategoryInfo(
                emoji: "\u{1F7E0}",
                name: "Orange & Yellow",
                target: "1 cup daily",
                why: "High in carotenoids and vitamin C. These pigments support mitochondrial function and protect against oxidative stress.",
                foods: ["Carrots", "Sweet Potatoes", "Butternut Squash", "Turmeric", "Orange Bell Peppers", "Yellow Bell Peppers", "Mangoes", "Peaches", "Apricots", "Pumpkin", "Golden Beets", "Acorn Squash", "Papaya", "Oranges", "Nectarines"],
                note: nil
            )
        case .blueBlack:
            return CategoryInfo(
                emoji: "\u{1F535}",
                name: "Blue & Black",
                target: "1 cup daily",
                why: "Contain some of the highest antioxidant concentrations of any food. Blueberries specifically have been shown to improve cognitive function and slow neurodegeneration.",
                foods: ["Blueberries", "Blackberries", "Black Grapes", "Elderberries", "Black Currants", "Purple Carrots", "Black Rice", "Black Olives", "Figs", "Dark Plums", "Black Beans", "Açaí Berries"],
                note: "Must be colored all the way through. Apples and bananas don't count."
            )
        case .sulfurRich:
            return CategoryInfo(
                emoji: "\u{1F9C4}",
                name: "Sulfur-Rich",
                target: "3 cups daily",
                why: "Sulfur is essential for glutathione production -- your body's master antioxidant. Also supports liver detoxification and cell membrane health.",
                foods: ["Garlic", "Onions", "Leeks", "Shallots", "Chives", "Broccoli", "Cauliflower", "Brussels Sprouts", "Cabbage", "Turnips", "Radishes", "Mushrooms", "Asparagus", "Kohlrabi"],
                note: nil
            )
        case .protein:
            return CategoryInfo(
                emoji: "\u{1F969}",
                name: "Protein",
                target: "6-12 oz daily",
                why: "Provides the amino acids needed for neurotransmitter production and myelin repair. Prioritize wild-caught fish for omega-3s, and grass-fed/pasture-raised meats.",
                foods: ["Grass-Fed Beef", "Lamb", "Wild-Caught Salmon", "Wild-Caught Sardines", "Wild-Caught Mackerel", "Pastured Poultry", "Bison", "Venison", "Elk", "Wild-Caught Cod", "Wild-Caught Trout"],
                note: "Prioritize wild-caught fish and grass-fed/pasture-raised meats."
            )
        case .seaweed:
            return CategoryInfo(
                emoji: "\u{1F30A}",
                name: "Seaweed",
                target: "1 serving daily",
                why: "One of the richest sources of iodine and trace minerals that support thyroid function and brain health. Even small amounts daily make a difference.",
                foods: ["Nori", "Kelp", "Dulse", "Wakame", "Kombu", "Spirulina", "Chlorella", "Sea Lettuce"],
                note: nil
            )
        case .fermented:
            return CategoryInfo(
                emoji: "\u{1FAD9}",
                name: "Fermented Foods",
                target: "1 serving daily",
                why: "Feed the gut microbiome, which directly influences neurological inflammation. A diverse gut microbiome is strongly linked to reduced MS symptom severity.",
                foods: ["Sauerkraut", "Kimchi", "Kombucha", "Coconut Yogurt", "Water Kefir", "Fermented Vegetables", "Kvass", "Apple Cider Vinegar (raw)"],
                note: nil
            )
        case .organMeat:
            return CategoryInfo(
                emoji: "\u{1FAC0}",
                name: "Organ Meat",
                target: "12 oz weekly",
                why: "The most nutrient-dense foods on the planet. Liver alone provides CoQ10, B12, iron, zinc, and fat-soluble vitamins at concentrations no supplement can match.",
                foods: ["Liver (beef, chicken, lamb)", "Heart", "Kidney", "Tongue", "Brain", "Sweetbreads"],
                note: "Counts toward a weekly 12 oz target, not the daily ring."
            )
        }
    }
}

// MARK: - FlowLayout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(width: maxWidth, height: currentY + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > bounds.maxX && currentX > bounds.minX {
                currentX = bounds.minX
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: .unspecified)
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// MARK: - CategoryInfoSheet

struct CategoryInfoSheet: View {
    let info: CategoryInfo

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Drag indicator
                Capsule()
                    .fill(CupsTheme.textSecondary.opacity(0.4))
                    .frame(width: 36, height: 5)
                    .padding(.top, 8)

                // Emoji
                Text(info.emoji)
                    .font(.system(size: 52))

                // Name
                Text(info.name)
                    .font(CupsTheme.headerFont(26))
                    .foregroundColor(CupsTheme.textPrimary)

                // Target pill
                Text(info.target)
                    .font(CupsTheme.labelFont(13))
                    .foregroundColor(CupsTheme.primaryAccent)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(CupsTheme.primaryAccent.opacity(0.15))
                    .clipShape(Capsule())

                // Why it matters
                VStack(alignment: .leading, spacing: 10) {
                    Text("Why it matters")
                        .font(CupsTheme.labelFont(15))
                        .foregroundColor(CupsTheme.textPrimary)

                    Text(info.why)
                        .font(CupsTheme.bodyFont(15))
                        .foregroundColor(CupsTheme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(CupsTheme.cardBackground)
                .cornerRadius(CupsTheme.cornerRadius)

                // What counts
                VStack(alignment: .leading, spacing: 12) {
                    Text("What counts")
                        .font(CupsTheme.labelFont(15))
                        .foregroundColor(CupsTheme.textPrimary)

                    FlowLayout(spacing: 8) {
                        ForEach(info.foods, id: \.self) { food in
                            Text(food)
                                .font(CupsTheme.bodyFont(14))
                                .foregroundColor(CupsTheme.textPrimary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(CupsTheme.background)
                                .cornerRadius(CupsTheme.cornerRadiusSmall)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(CupsTheme.cardBackground)
                .cornerRadius(CupsTheme.cornerRadius)

                // Note
                if let note = info.note {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(CupsTheme.secondaryAccent)
                            .font(.system(size: 14))
                            .padding(.top, 2)

                        Text(note)
                            .font(CupsTheme.bodyFont(13))
                            .foregroundColor(CupsTheme.secondaryAccent)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(CupsTheme.secondaryAccent.opacity(0.1))
                    .cornerRadius(CupsTheme.cornerRadius)
                }

                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
        }
        .background(CupsTheme.background.ignoresSafeArea())
        .presentationDetents([.medium, .large])
    }
}
