import Foundation

struct FoodCategory: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let foods: [String]
}

enum FoodDatabase {
    static let leafyGreens = FoodCategory(
        name: "Leafy Greens",
        emoji: "\u{1F96C}",
        foods: [
            "Kale", "Spinach", "Swiss Chard", "Collard Greens",
            "Arugula", "Romaine", "Bok Choy", "Mustard Greens",
            "Turnip Greens", "Watercress", "Dandelion Greens",
            "Lettuce", "Microgreens",
        ]
    )

    static let redPurple = FoodCategory(
        name: "Red & Purple",
        emoji: "\u{1F534}",
        foods: [
            "Beets", "Red Cabbage", "Blueberries", "Blackberries",
            "Raspberries", "Cherries", "Cranberries", "Pomegranate",
            "Plums", "Eggplant", "Purple Grapes", "Red Onion",
            "Radicchio", "Blood Orange", "Watermelon", "Strawberries",
        ]
    )

    static let orangeYellow = FoodCategory(
        name: "Orange & Yellow",
        emoji: "\u{1F7E0}",
        foods: [
            "Carrots", "Sweet Potatoes", "Butternut Squash", "Turmeric",
            "Orange Bell Peppers", "Yellow Bell Peppers", "Mangoes",
            "Peaches", "Apricots", "Pumpkin", "Golden Beets",
            "Acorn Squash", "Papaya", "Oranges", "Nectarines",
        ]
    )

    static let blueBlack = FoodCategory(
        name: "Blue & Black",
        emoji: "\u{1F535}",
        foods: [
            "Blueberries", "Blackberries", "Black Grapes", "Elderberries",
            "Black Currants", "Purple Carrots", "Black Rice",
            "Black Olives", "Figs", "Dark Plums", "Black Beans",
            "Açaí Berries",
        ]
    )

    static let sulfurRich = FoodCategory(
        name: "Sulfur-Rich",
        emoji: "\u{1F9C4}",
        foods: [
            "Garlic", "Onions", "Leeks", "Shallots", "Chives",
            "Broccoli", "Cauliflower", "Brussels Sprouts", "Cabbage",
            "Turnips", "Radishes", "Mushrooms", "Asparagus",
            "Kohlrabi",
        ]
    )

    static let protein = FoodCategory(
        name: "Protein",
        emoji: "\u{1F969}",
        foods: [
            "Grass-Fed Beef", "Lamb", "Wild-Caught Salmon",
            "Wild-Caught Sardines", "Wild-Caught Mackerel",
            "Pastured Poultry", "Bison", "Venison", "Elk",
            "Wild-Caught Cod", "Wild-Caught Trout",
        ]
    )

    static let seaweed = FoodCategory(
        name: "Seaweed",
        emoji: "\u{1F30A}",
        foods: [
            "Nori", "Kelp", "Dulse", "Wakame", "Kombu",
            "Spirulina", "Chlorella", "Sea Lettuce",
        ]
    )

    static let fermented = FoodCategory(
        name: "Fermented Foods",
        emoji: "\u{1FAD9}",
        foods: [
            "Sauerkraut", "Kimchi", "Kombucha", "Coconut Yogurt",
            "Water Kefir", "Fermented Vegetables", "Kvass",
            "Apple Cider Vinegar (raw)",
        ]
    )

    static let organMeat = FoodCategory(
        name: "Organ Meat",
        emoji: "\u{1FAC0}",
        foods: [
            "Liver (beef, chicken, lamb)", "Heart", "Kidney",
            "Tongue", "Brain", "Sweetbreads",
        ]
    )

    static let allCategories: [FoodCategory] = [
        leafyGreens, redPurple, orangeYellow, blueBlack, sulfurRich, protein, seaweed, fermented, organMeat,
    ]
}
