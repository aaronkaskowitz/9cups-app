# 9 Cups — v1.1 Build Spec + Premium Roadmap

## Overview
Version 1.1 ships two features:
1. **Category Info Modal** (free) — tap any category card to get a food guide sheet
2. **Snap & Track** (premium, $4.99 one-time) — AI photo check-in via GPT-4o Vision

Plus the full **StoreKit 2 Premium infrastructure** to support all future paid features.

---

## Status

### Already Built (compiles clean)
- `Services/PremiumManager.swift` — StoreKit 2, lifetime unlock, UserDefaults persistence
- `Services/FoodPhotoAnalyzer.swift` — GPT-4o Vision API, resizes image, maps to Wahls categories
- `Views/Premium/PremiumUpgradeSheet.swift` — paywall UI, buy + restore
- `Views/Today/PhotoCheckInView.swift` — full photo check-in flow
- `State/AppState.swift` — `applyPhotoIncrements()` added
- `Views/Today/TodayView.swift` — camera button in nav bar, premium gate
- `App/NineCupsApp.swift` — PremiumManager injected app-wide

### Still To Build
- `Views/Today/CategoryInfoSheet.swift` — category detail modal (NEW, free feature)
- Wire `CategoryCardView` to open `CategoryInfoSheet` on tap
- Add `CategoryInfo` data model with per-category descriptions and context

---

## Feature 1: Category Info Modal (Free, v1.1)

### What It Is
Tapping anywhere on a category card (not the +/- buttons) opens a bottom sheet
showing the category's Wahls Protocol context, why it matters, and the full
qualifying foods list. Dismiss and return to logging. No tab switching.

### Entry Point
- Tap on the card body (name/emoji/progress area)
- Small "ⓘ" icon on the right of the card name to signal it's tappable
- The +/- increment buttons still work independently — only the card body triggers the sheet

### Sheet Content
For each category, show:

**Header:**
- Large emoji (48pt)
- Category name (bold, 24pt)
- Subtitle: Wahls target (e.g., "3 cups daily")

**Why it matters (1-2 sentences):**
Copy per category (see below)

**What qualifies — food list:**
Use existing FoodDatabase foods, displayed as a clean tag cloud or bulleted list

**Special notes where relevant:**
- Colored produce: "Must be colored all the way through — apples, bananas, and pears don't count"
- Organ meat: "Counts toward a weekly 12oz target, not the daily ring"
- Protein: "Prioritize wild-caught fish and grass-fed/pasture-raised meats"

### Category Copy (per category)

**Leafy Greens**
Why: "Packed with folate, B vitamins, and minerals that support myelin repair and brain function. Dr. Wahls calls these the foundation of the protocol."

**Red & Purple**
Why: "Rich in resveratrol and anthocyanins — potent antioxidants that protect neurons and reduce inflammation throughout the nervous system."

**Orange & Yellow**
Why: "High in carotenoids and vitamin C. These pigments support mitochondrial function and protect against oxidative stress."

**Blue & Black**
Why: "Contain some of the highest antioxidant concentrations of any food. Blueberries specifically have been shown to improve cognitive function and slow neurodegeneration."
Note: "Must be colored all the way through. Apples and bananas don't count."

**Sulfur-Rich**
Why: "Sulfur is essential for glutathione production — your body's master antioxidant. Also supports liver detoxification and cell membrane health."

**Protein**
Why: "Provides the amino acids needed for neurotransmitter production and myelin repair. Prioritize wild-caught fish for omega-3s, and grass-fed/pasture-raised meats."

**Seaweed**
Why: "One of the richest sources of iodine and trace minerals that support thyroid function and brain health. Even small amounts daily make a difference."

**Fermented Foods**
Why: "Feed the gut microbiome, which directly influences neurological inflammation. A diverse gut microbiome is strongly linked to reduced MS symptom severity."

**Organ Meat**
Why: "The most nutrient-dense foods on the planet. Liver alone provides CoQ10, B12, iron, zinc, and fat-soluble vitamins at concentrations no supplement can match."

### New File: CategoryInfoSheet.swift
Location: `Views/Today/CategoryInfoSheet.swift`

```swift
struct CategoryInfo {
    let emoji: String
    let name: String
    let target: String        // e.g., "3 cups daily"
    let why: String
    let foods: [String]
    let note: String?
}
```

Provide a static `CategoryInfo.all` dictionary keyed by a `CategoryKey` enum
matching the categories in FoodDatabase.

### Modify: CategoryCardView.swift
- Add `onInfoTap: (() -> Void)?` parameter (optional, defaults to nil)
- Add `@State private var showInfo = false` 
- Wrap the name+emoji+progress area in a Button that calls `onInfoTap`
- Add a small `Image(systemName: "info.circle")` in the header row, muted color
- Sheet: `.sheet(isPresented: $showInfo) { CategoryInfoSheet(info: ...) }`

OR pass the sheet directly into CategoryCardView so it owns the presentation state.

### Modify: TodayView.swift
Pass the appropriate CategoryInfo to each CategoryCardView.

---

## Feature 2: Snap & Track (Premium — $4.99 one-time)

### IAP Product ID
`com.9cups.premium.lifetime`

### Already built. Key wiring notes:
- Camera button appears in TodayView nav bar (top right)
- Lock icon overlay when not premium — tapping opens PremiumUpgradeSheet
- Premium users go straight to PhotoCheckInView
- After analysis, user sees results sheet with toggleable line items
- "Looks good" applies increments via `appState.applyPhotoIncrements()`
- API key read from Info.plist `OPENAI_API_KEY` (placeholder already set)

### Still needed before ship:
- Aaron adds real OpenAI API key to Xcode Build Settings as `OPENAI_API_KEY`
- Create IAP product in App Store Connect: `com.9cups.premium.lifetime`, $4.99
- Test StoreKit in sandbox before submitting

---

## Version Bump
1.0 → 1.1

App Store "What's New":
"Tap any food category to instantly see what qualifies and why it matters.
Plus: Snap & Track uses AI to analyze a photo of your meal and fill your cups automatically — available with 9 Cups Premium ($4.99 one-time)."

---

## Premium Roadmap (all unlock with $4.99)

| # | Feature | Version |
|---|---------|---------|
| 1 | Snap & Track (AI photo check-in) | v1.1 |
| 2 | Trends & Insights (30-day history, category heatmaps, streak analysis) | v1.2 |
| 3 | Weekly Recap (in-app: 7-day ring grid, missed cups, AI insight) | v1.2 |
| 4 | Meal Suggestions ("need 2 more sulfur servings" → 5 quick options) | v1.3 |
| 5 | Home Screen Widget (live ring progress, WidgetKit) | v1.3 |
| 6 | Smart Reminders (adaptive, pattern-based alerts) | v1.4 |
| 7 | Multiple Profiles (track for a partner on Wahls) | v1.4 |
| 8 | Apple Health Sync (write nutrition data to Health.app) | v1.5 |
| 9 | Wahls Recipes (curated recipes organized by cups they fill) | v1.5 |

---

## Design Rules
- Follow CupsTheme throughout (background, cardBackground, primaryAccent, textPrimary, textSecondary)
- Dark mode only (preferredColorScheme .dark)
- Haptic feedback on all confirming actions
- No em dashes in any user-facing copy
- Rounded SF Pro font throughout
- Sheets use .presentationDetents([.medium, .large]) where appropriate
