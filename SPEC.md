# 9 Cups — MVP Build Spec

## What This Is
A free iOS app for people following the Wahls Protocol for MS and autoimmune conditions.
Daily serving tracker with a visual color ring. No AI features, no backend, no subscriptions.
Pure local-first SwiftUI app. Ships this weekend.

## Design System
Copy the design patterns from ~/Projects/pulse-app/ (PulseTheme, dark background, amber accents).
Adapt the color palette: forest green primary instead of navy, keep amber warm as accent.
Same rounded fonts, same corner radius, same accessibility patterns.

## App Structure

### Tab Bar (3 tabs)
1. **Today** — Daily tracker (main screen)
2. **Guide** — Protocol reference
3. **Profile** — Settings and level selection

### Tab 1: Today (Daily Tracker)

**Hero Element: The Color Ring**
A circular ring divided into 7 segments (degrees, clockwise from top):
- Leafy greens: 105° (green #4ade80)
- Red & Purple: 40° (red #ef4444)
- Orange & Yellow: 40° (orange #f59e0b)
- Blue & Black: 40° (indigo #6366f1)
- Sulfur-rich: 105° (cream #c7b894)
- Seaweed: 15° sliver (teal #2dd4bf)
- Fermented: 15° sliver (purple #a78bfa)
3° gap between each segment. Each segment fills proportionally as you log.
totalCups = min(leafy, 3) + min(colored total, 3) + min(sulfur, 3) — capped at target per category, max 9.
Color cards show target of 1 each (3 total combined). Indented under "🌈 Colored Produce" header.

The ring fills as you log food. Empty in morning, full by dinner.
Center shows: "X / 9 cups" with percentage.

**Below the ring: Category Cards**
Each category is a tappable card showing:
- Emoji + category name
- Progress dots (filled/unfilled) or progress bar
- Current count vs target

Categories:
1. 🥬 Leafy Greens — 3 cups daily (kale, spinach, arugula, chard, collards, bok choy, watercress, lettuce, microgreens)
2. 🌈 Colored Produce — 3 cups daily (combined), aim for 3 different colors:
   - 🔴 Red & Purple (beets, berries, red cabbage, cherries, pomegranate, plums, radicchio, red onion)
   - 🟠 Orange & Yellow (carrots, sweet potato, winter squash, orange/yellow peppers, turmeric root, pumpkin)
   - 🔵 Blue & Black (blueberries, blackberries, black beans, figs, purple cabbage, eggplant, black rice)
   Note: Produce must be "colored all the way through" (apples, bananas don't count)
3. 🧄 Sulfur-Rich — 3 cups daily (broccoli, cauliflower, Brussels sprouts, cabbage, onions, garlic, leeks, mushrooms, asparagus, radishes)
4. 🥩 Protein — 6-12 oz daily (grass-fed beef, lamb, wild fish, poultry)
5. 🌊 Seaweed — 1 serving daily (checkbox)
6. 🫙 Fermented — 1 serving daily (checkbox)
7. 🫀 Organ Meat — 12 oz weekly target (card shows rolling 7-day sum, +/- logs to today, excluded from daily score/rainbow)



**Streak Counter**
"🔥 X day streak" at the top or bottom. Tracks consecutive days with 70%+ score.

### Tab 2: Guide (Protocol Reference)

**Level Selector at top** (segmented control: Level 1 / Level 2 / Level 3)

**For each level, show:**
- What to eat (daily targets)
- What to avoid (elimination list)
- Meal timing recommendations
- Quick tips

**Food Reference**
Tappable sections:
- "What counts as leafy greens?" → list of foods
- "What counts as sulfur-rich?" → list of foods
- "What counts as colored produce?" → list by color (red/purple, orange/yellow, blue/black) with "colored all the way through" note
- "Best protein sources" → list
- "Fermented foods to try" → list
- "Seaweed options" → list

**Meal Timing Section**
- Level 1-2: 3 meals, 12-hour overnight fast
- Level 3: 2 meals, 16-hour fast window
- Visual timeline showing suggested eating windows

### Tab 3: Profile

- **Current Level** selector (1, 2, 3) — changes targets throughout the app
- **Display Name** (first name or alias, for greeting)
- **Weekly Summary** — simple 7-day grid showing daily scores
- **About** — app info, disclaimer, credits
- **Reset Data** — clear tracking data

## Data Model (CoreData, local only)

### DailyLog entity
- id: UUID
- date: Date
- leafyGreens: Int16 (cups)
- redPurple: Int16 (cups)
- orangeYellow: Int16 (cups)
- blueBlack: Int16 (cups)
- sulfurRich: Int16 (cups)
- proteinOz: Int16 (ounces)
- seaweed: Bool
- fermented: Bool
- organMeatOz: Int16 (ounces)
- score: Int16 (calculated from 6 daily categories only; organ meat excluded)

### UserSettings entity
- id: UUID
- displayName: String
- level: Int16 (1, 2, or 3)
- streakCount: Int16
- lastLogDate: Date

## Key UX Details

### MS-Friendly Design
- Minimum 48pt tap targets
- High contrast (dark bg, bright text/accents)
- Large, readable fonts
- Minimal steps to log anything
- No guilt language (missed days are just blank, no red/warnings)
- Dark mode only (easier on sensitive eyes)
- VoiceOver accessible

### The Color Ring Animation
When all 9 cups are logged, the ring completes with a subtle glow animation.
Not over the top. Gentle celebration. Maybe a small "✨ Complete" badge.

### Daily Score Calculation
Score = weighted average of all categories hitting their targets:
- Leafy: current/3 (capped at 1.0)
- Colored: current/3 (capped at 1.0)
- Sulfur: current/3 (capped at 1.0)
- Protein: current/target (6 or 12, based on level)
- Seaweed: 1.0 if checked, 0.0 if not
- Fermented: 1.0 if checked, 0.0 if not
Total = average of all × 100

### Streak Logic
A day counts toward the streak if score >= 70%.
Streak resets if a day is missed entirely (no logs at all).
Streak is visible on the Today tab.

## What NOT to Build

- No AI features (no API costs)
- No backend/server/cloud sync
- No user accounts or authentication
- No subscription/paywall
- No social features
- No recipe generation
- No shopping lists
- No push notifications (for now)
- No Apple HealthKit integration (for now)

## Color Palette

- Background: #1a2e1a (deep forest green, very dark)
- Card background: #2d4a2d (muted green)
- Primary accent: #7fda85 (fresh green)
- Secondary accent: #f5c542 (warm amber, from Pulse)
- Text primary: #ffffff
- Text secondary: rgba(255,255,255,0.6)
- Ring colors: green (#4ade80), orange (#fb923c), red (#f87171), purple (#a78bfa), white (#e2e8f0)

## File Structure
```
9CupsApp/
├── App/
│   └── NineCupsApp.swift          # App entry point
├── Theme/
│   └── CupsTheme.swift            # Colors, fonts, radii
├── CoreData/
│   ├── DataModel.swift            # CoreData model definition
│   ├── CDClasses.swift            # NSManagedObject subclasses
│   └── PersistenceController.swift
├── Models/
│   ├── FoodDatabase.swift         # All food lists by category
│   └── ProtocolLevels.swift       # Level definitions and targets
├── Views/
│   ├── MainTabView.swift          # Tab bar container
│   ├── Today/
│   │   ├── TodayView.swift        # Main daily tracker
│   │   ├── ColorRingView.swift    # The signature ring
│   │   ├── CategoryCardView.swift # Individual category cards
│   ├── Guide/
│   │   ├── GuideView.swift        # Protocol reference
│   │   ├── LevelDetailView.swift  # Per-level info
│   │   └── FoodListView.swift     # Food category lists
│   └── Profile/
│       ├── ProfileView.swift      # Settings
│       └── WeeklySummaryView.swift # 7-day overview
├── State/
│   └── AppState.swift             # App state management
└── Assets.xcassets/
```

## Xcode Project
- Deployment target: iOS 17.0
- Bundle ID: com.aaronkaskowitz.9cups (placeholder)
- App name: "9 Cups"

## Reference Code
Use ~/Projects/pulse-app/ as reference for:
- PulseTheme.swift → adapt to CupsTheme
- PersistenceController.swift → same pattern
- CDClasses.swift → same pattern
- AppState.swift → same pattern
- Any SwiftUI patterns (grids, cards, buttons)

Do NOT copy Pulse code verbatim. Use it as a pattern reference only.

## Build Target
Must compile and run on iOS Simulator (iPhone 17, iOS 26.2).
