import Foundation
import UIKit

struct PhotoIncrements {
    var leafyGreens: Int = 0
    var redPurple: Int = 0
    var orangeYellow: Int = 0
    var blueBlack: Int = 0
    var sulfurRich: Int = 0
    var proteinOz: Int = 0
    var seaweed: Bool = false
    var fermented: Bool = false
    var organMeatOz: Int = 0
    var foodsDetected: [String] = []
    var confidence: String = "none"

    var hasAnyFood: Bool {
        leafyGreens > 0 || redPurple > 0 || orangeYellow > 0 || blueBlack > 0
            || sulfurRich > 0 || proteinOz > 0 || seaweed || fermented || organMeatOz > 0
    }

    var lineItems: [(emoji: String, label: String, detail: String, key: String)] {
        var items: [(emoji: String, label: String, detail: String, key: String)] = []
        if leafyGreens > 0 { items.append(("🥬", "Leafy Greens", "+\(leafyGreens) cup\(leafyGreens > 1 ? "s" : "")", "leafy")) }
        if redPurple > 0 { items.append(("🔴", "Red & Purple", "+\(redPurple) cup\(redPurple > 1 ? "s" : "")", "redpurple")) }
        if orangeYellow > 0 { items.append(("🟠", "Orange & Yellow", "+\(orangeYellow) cup\(orangeYellow > 1 ? "s" : "")", "orangeyellow")) }
        if blueBlack > 0 { items.append(("🔵", "Blue & Black", "+\(blueBlack) cup\(blueBlack > 1 ? "s" : "")", "blueblack")) }
        if sulfurRich > 0 { items.append(("🧄", "Sulfur-Rich", "+\(sulfurRich) cup\(sulfurRich > 1 ? "s" : "")", "sulfur")) }
        if proteinOz > 0 { items.append(("🥩", "Protein", "+\(proteinOz) oz", "protein")) }
        if seaweed { items.append(("🌊", "Seaweed", "Serving logged", "seaweed")) }
        if fermented { items.append(("🫙", "Fermented", "Serving logged", "fermented")) }
        if organMeatOz > 0 { items.append(("🫀", "Organ Meat", "+\(organMeatOz) oz", "organ")) }
        return items
    }
}

enum AnalyzerError: LocalizedError {
    case noAPIKey
    case networkError(String)
    case parseError
    case noFoodsDetected

    var errorDescription: String? {
        switch self {
        case .noAPIKey: return "OpenAI API key not configured."
        case .networkError(let msg): return "Network error: \(msg)"
        case .parseError: return "Couldn't read the AI response."
        case .noFoodsDetected: return "No Wahls Protocol foods detected. Try a different angle or better lighting."
        }
    }
}

class FoodPhotoAnalyzer {
    static let shared = FoodPhotoAnalyzer()
    private init() {}

    private let systemPrompt = """
    You are a nutrition analyzer for the Wahls Protocol, a therapeutic diet for MS and autoimmune conditions.

    Analyze the food in the photo. For each visible food, map it to one of these Wahls categories:
    - leafy_greens: kale, spinach, swiss chard, collards, arugula, bok choy, lettuce, microgreens, watercress
    - red_purple: beets, red cabbage, berries, cherries, pomegranate, plums, radicchio, red onion, eggplant, strawberries
    - orange_yellow: carrots, sweet potato, winter squash, orange or yellow peppers, turmeric, pumpkin, mango, peaches
    - blue_black: blueberries, blackberries, black beans, figs, purple cabbage, black rice, acai
    - sulfur_rich: broccoli, cauliflower, brussels sprouts, cabbage, onions, garlic, leeks, mushrooms, asparagus, radishes
    - protein: grass-fed beef, lamb, wild fish (salmon, sardines, mackerel, cod, trout), pastured poultry, bison
    - seaweed: nori, kelp, dulse, wakame, spirulina (true/false, any seaweed present)
    - fermented: sauerkraut, kimchi, kombucha, coconut yogurt, kefir, fermented vegetables (true/false)
    - organ_meat: liver, heart, kidney (estimate oz visible)

    Return ONLY a valid JSON object, no other text:
    {
      "foods_detected": ["food1", "food2"],
      "increments": {
        "leafy_greens": 0,
        "red_purple": 0,
        "orange_yellow": 0,
        "blue_black": 0,
        "sulfur_rich": 0,
        "protein_oz": 0,
        "seaweed": false,
        "fermented": false,
        "organ_meat_oz": 0
      },
      "confidence": "high"
    }

    Rules:
    - Be conservative: 1 cup = a large handful. A full plate of kale = 2 cups max.
    - confidence: "high" if foods are clearly visible, "low" if unclear, "none" if no Wahls foods present.
    - If image is not food, return confidence "none" and all zeros.
    """

    func analyze(image: UIImage) async throws -> PhotoIncrements {
        guard let apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String,
              !apiKey.isEmpty, apiKey != "$(OPENAI_API_KEY)" else {
            throw AnalyzerError.noAPIKey
        }

        // Resize to max 512x512 to control token cost
        let resized = resizeImage(image, maxDimension: 512)
        guard let jpegData = resized.jpegData(compressionQuality: 0.8) else {
            throw AnalyzerError.parseError
        }
        let base64 = jpegData.base64EncodedString()
        let dataURL = "data:image/jpeg;base64,\(base64)"

        let body: [String: Any] = [
            "model": "gpt-4o",
            "max_tokens": 500,
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": [
                    ["type": "image_url", "image_url": ["url": dataURL, "detail": "low"]]
                ]]
            ]
        ]

        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw AnalyzerError.networkError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 30

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let msg = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw AnalyzerError.networkError(msg)
        }

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let message = choices.first?["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw AnalyzerError.parseError
        }

        return try parseIncrements(from: content)
    }

    private func parseIncrements(from content: String) throws -> PhotoIncrements {
        // Extract JSON from the response (may have surrounding text)
        let jsonString: String
        if let start = content.range(of: "{"), let end = content.range(of: "}", options: .backwards) {
            jsonString = String(content[start.lowerBound...end.upperBound])
        } else {
            throw AnalyzerError.parseError
        }

        guard let data = jsonString.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw AnalyzerError.parseError
        }

        let confidence = json["confidence"] as? String ?? "none"
        let foods = json["foods_detected"] as? [String] ?? []
        let inc = json["increments"] as? [String: Any] ?? [:]

        var result = PhotoIncrements()
        result.confidence = confidence
        result.foodsDetected = foods
        result.leafyGreens = inc["leafy_greens"] as? Int ?? 0
        result.redPurple = inc["red_purple"] as? Int ?? 0
        result.orangeYellow = inc["orange_yellow"] as? Int ?? 0
        result.blueBlack = inc["blue_black"] as? Int ?? 0
        result.sulfurRich = inc["sulfur_rich"] as? Int ?? 0
        result.proteinOz = inc["protein_oz"] as? Int ?? 0
        result.seaweed = inc["seaweed"] as? Bool ?? false
        result.fermented = inc["fermented"] as? Bool ?? false
        result.organMeatOz = inc["organ_meat_oz"] as? Int ?? 0

        if confidence == "none" || !result.hasAnyFood {
            throw AnalyzerError.noFoodsDetected
        }

        return result
    }

    private func resizeImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        let size = image.size
        guard size.width > maxDimension || size.height > maxDimension else { return image }
        let scale = maxDimension / max(size.width, size.height)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in image.draw(in: CGRect(origin: .zero, size: newSize)) }
    }
}
