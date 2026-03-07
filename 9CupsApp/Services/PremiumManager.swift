import Foundation
import StoreKit

@MainActor
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()

    @Published var isPremium: Bool = false
    @Published var isPurchasing: Bool = false

    private let productID = "com.9cups.premium.lifetime"
    private let premiumKey = "isPremiumUnlocked"

    private init() {
        isPremium = UserDefaults.standard.bool(forKey: premiumKey)
        Task { await checkPurchaseStatus() }
    }

    func checkPurchaseStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let tx) = result, tx.productID == productID {
                isPremium = true
                UserDefaults.standard.set(true, forKey: premiumKey)
                return
            }
        }
    }

    func purchase() async throws {
        isPurchasing = true
        defer { isPurchasing = false }

        let products = try await Product.products(for: [productID])
        guard let product = products.first else {
            throw PremiumError.productNotFound
        }

        let result = try await product.purchase()
        switch result {
        case .success(let verificationResult):
            if case .verified(let tx) = verificationResult {
                isPremium = true
                UserDefaults.standard.set(true, forKey: premiumKey)
                await tx.finish()
            }
        case .userCancelled:
            break
        case .pending:
            break
        @unknown default:
            break
        }
    }

    func restore() async throws {
        try await AppStore.sync()
        await checkPurchaseStatus()
    }

    enum PremiumError: LocalizedError {
        case productNotFound
        var errorDescription: String? {
            switch self {
            case .productNotFound: return "Premium product not found. Please try again later."
            }
        }
    }
}
