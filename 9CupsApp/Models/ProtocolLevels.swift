import Foundation

struct ProtocolLevel: Identifiable {
    let id: Int
    let name: String
    let description: String
    let dailyTargets: [String]
    let eliminate: [String]
    let mealTiming: String
    let tips: [String]
}

enum NineCupsProtocol {
    static let levels: [ProtocolLevel] = [level1, level2, level3]

    static let level1 = ProtocolLevel(
        id: 1,
        name: "Foundation",
        description: "Foundation level inspired by the Wahls Protocol\u{00AE}. Focus on 9 cups of vegetables and fruits daily while removing gluten, dairy, and eggs.",
        dailyTargets: [
            "3 cups leafy greens",
            "3 cups deeply colored fruits & vegetables",
            "3 cups sulfur-rich vegetables",
            "6 oz high-quality protein",
            "1 serving seaweed",
            "1 serving fermented food",
            "12 oz organ meat per week",
        ],
        eliminate: [
            "Gluten-containing grains (wheat, barley, rye)",
            "Dairy products (milk, cheese, yogurt, butter)",
            "Eggs",
            "Refined sugar",
            "Processed foods",
        ],
        mealTiming: "3 meals per day with a 12-hour overnight fast. For example, eat between 7am and 7pm.",
        tips: [
            "Start by adding vegetables before removing foods",
            "Prep greens in batches for the week",
            "Smoothies count toward your cups",
            "Frozen vegetables are perfectly fine",
            "Focus on progress, not perfection",
        ]
    )

    static let level2 = ProtocolLevel(
        id: 2,
        name: "Paleo",
        description: "Intermediate paleo level inspired by the Wahls Protocol\u{00AE}. Removes grains, legumes, and nightshades. More organ meats and fermented foods.",
        dailyTargets: [
            "3 cups leafy greens",
            "3 cups deeply colored fruits & vegetables",
            "3 cups sulfur-rich vegetables",
            "9 oz high-quality protein",
            "1 serving seaweed",
            "1 serving fermented food",
            "12 oz organ meat per week",
        ],
        eliminate: [
            "All grains (including gluten-free)",
            "All dairy products",
            "Eggs",
            "Legumes (beans, lentils, peanuts, soy)",
            "Nightshades (tomatoes, potatoes, peppers, eggplant)",
            "Refined sugar and sweeteners",
            "Processed foods",
        ],
        mealTiming: "3 meals per day with a 12-hour overnight fast. For example, eat between 7am and 7pm.",
        tips: [
            "Coconut products are great dairy alternatives",
            "Sweet potatoes replace regular potatoes",
            "Try bone broth as a warm drink",
            "Increase organ meat gradually",
            "Seaweed flakes are an easy daily addition",
        ]
    )

    static let level3 = ProtocolLevel(
        id: 3,
        name: "Paleo Plus",
        description: "Advanced ketogenic level inspired by the Wahls Protocol\u{00AE}. High fat, very low carb for maximum therapeutic benefit.",
        dailyTargets: [
            "3 cups leafy greens",
            "3 cups deeply colored fruits & vegetables",
            "3 cups sulfur-rich vegetables",
            "12 oz high-quality protein",
            "1 serving seaweed",
            "1 serving fermented food",
            "12 oz organ meat per week",
            "Coconut oil or full-fat coconut milk daily",
        ],
        eliminate: [
            "All grains",
            "All dairy products",
            "Eggs",
            "All legumes",
            "All nightshades",
            "All sweeteners (including honey and maple syrup)",
            "All processed foods",
            "Most fruits (berries only, in small amounts)",
            "Starchy vegetables limited",
        ],
        mealTiming: "2 meals per day with a 16-hour fasting window. For example, eat between 11am and 7pm.",
        tips: [
            "MCT oil or coconut oil helps achieve ketosis",
            "Avocados are your best friend",
            "Track net carbs to stay under 20g",
            "Broth fasting can ease the transition",
            "Listen to your body and adjust gradually",
        ]
    )
}
