# Snack Maxx — Mobile App Demo

SwiftUI demo of the Snack Maxx app, matching the Claude Design DA. Built for the **Albert School deliverable on May 28, 2026**.

## What's in the box

A functional iOS app you can run on your iPhone in front of an audience. Everything works, nothing is real:

- Account creation (Apple/Google/Email mock → name entry)
- Scan-to-pay flow (animated QR viewfinder → fake Face ID → recovery code)
- Machine locator with stylized Paris map (5 mock distributors with live stock %)
- Product voting (live count toggles, persistent per session)
- Loyalty club with streak grid and 3 tiers
- Purchase history with one-tap re-order
- 6-type ticket flow with auto-refund toggle
- Notification preferences

No real payment / no real backend / no real machine connection. Designed to look real.

The full plan with screen list and design tokens is in [`tasks/todo.md`](tasks/todo.md).
The design source (HTML/CSS/JS Claude Design export) is in [`claude-design/`](claude-design/).

## Tech stack

- **Xcode 26.5+** required (uses iOS 26.5 SDK; deployment target iOS 17.0)
- SwiftUI only, no third-party dependencies
- Custom fonts: Bowlby One, Archivo Black, Space Grotesk, Bungee (bundled, OFL)

## First-time setup (one-time, ~5 min)

> [!IMPORTANT]
> Xcode 26.5 ships with the iOS SDK but **not** the iOS Simulator runtime / device platform. Without it, `xcodebuild` will fail with `iOS 26.5 is not installed`. Fix this *before* opening the project.

### 1. Install the iOS platform

Open **Xcode** → **Settings…** (⌘,) → **Platforms** tab → click **+** → **iOS** → wait for the download to finish (~3–5 GB). Or via terminal (slower but headless):

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -downloadPlatform iOS
```

### 2. Install `xcodegen` (only if you need to regenerate the project)

```bash
brew install xcodegen
```

The `.xcodeproj` is already generated and committed — you only need this if you modify `SnackMaxx/project.yml`.

## Run in the iOS Simulator

```bash
open SnackMaxx/SnackMaxx.xcodeproj
```

In Xcode:
1. Pick the **iPhone 16 Pro** simulator (top-left scheme runner)
2. Hit **⌘R** → app boots into Splash → Auth → Name → Home

Or from the command line:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  xcodebuild \
    -project SnackMaxx/SnackMaxx.xcodeproj \
    -scheme SnackMaxx \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
    build
```

## Deploy to your iPhone (for the May 28 demo)

> [!TIP]
> Free Apple ID gives you a 7-day provisioning profile. **Install on May 26–27**, not earlier, or the app will expire before the demo. If your team has a paid developer account, use that team in step 3 below — it gives a 1-year profile.

1. **Plug iPhone into Mac** with cable. Unlock + trust the computer.
2. **In Xcode**, top-left → **device picker** → select your iPhone.
3. **Project navigator** → click `SnackMaxx` (blue icon) → **Signing & Capabilities** tab → set **Team** to your Apple ID (sign in via Xcode → Settings → Accounts if needed). Bundle ID `com.jbouniol.snackmaxx` may conflict — change the prefix to something unique per team member if needed.
4. Hit **⌘R**. The first build pushes the app + cert to your phone.
5. **On your iPhone**: Settings → General → **VPN & Device Management** → tap your developer cert → **Trust**. Now the app icon works.

### Demo flow to walk on stage (≈3 min)

1. **Cold launch** → tap **Commencer** on the splash
2. **Continuer avec Apple** → fake Face ID pulse (~800ms)
3. **Type your name** → **Continuer**
4. **Home** appears with hero machine card (Lycée Voltaire, 94% stock), personalized banner ("ton Maxx Fuel, dispo à 50 m"), Reprendre carousel, Loyalty teaser, Vote teaser, low-stock list
5. Tap **Scanner & payer** (or the orange QR FAB in the tab bar) → animated viewfinder → auto-resolves after 2s to Snacks screen
6. Tap **Maxx Inferno** → product detail screen with package art, stock pill, nutri
7. Tap **Payer · 2,20 €** → pay sheet:
   - Phase 1: totals with Silver discount, +22 pts
   - Tap **Payer avec Apple Pay** → Face ID pulse
   - Tap **Simuler la validation** → green check + recovery code **A2-4F** on orange ticket
8. Tap **Récupéré, merci !** → back to Home
9. Tap **Loyalty teaser** (dark card) → Club Maxx with streak grid + 3 tiers
10. **Carte** tab → stylized map with 5 pins
11. **Profil** tab → identity + stats + activities → tap **Mes votes** → vote on Kinder Bueno, see count tick up + button turns orange

## File layout

```
transformation-strategy-snack-maxx/
├── CLAUDE.md                       # Project context for AI agents
├── README.md                       # ← you are here
├── claude-design/                  # HTML/CSS/JS source design (do not edit)
├── Docs/                           # Customer objectives, draft solutions, A/B plan
├── SnackMaxx/                      # ← the iOS app
│   ├── SnackMaxx.xcodeproj/
│   ├── project.yml                 # xcodegen config; run `xcodegen generate` to rebuild .xcodeproj
│   └── SnackMaxx/
│       ├── SnackMaxxApp.swift      # @main
│       ├── RootView.swift          # gates onboarding vs main
│       ├── AppState.swift          # ObservableObject
│       ├── Theme/                  # Colors, Fonts, Modifiers
│       ├── Models/
│       ├── Data/MockData.swift     # everything mock
│       ├── Components/             # MaxxButton, ChromeText, SnackPackage, etc.
│       ├── Onboarding/             # Splash, AuthMethod, NameEntry
│       ├── Screens/                # Home, Snacks, Map, Profile + overlays
│       ├── Assets.xcassets/        # logo + app icon + colors
│       └── Fonts/                  # 4 OFL-licensed TTFs
└── tasks/
    ├── todo.md                     # build progress
    └── lessons.md                  # corrections collected during dev
```

## Re-generating the Xcode project

If you change `SnackMaxx/project.yml` (e.g. to add fonts, change bundle id):

```bash
cd SnackMaxx
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodegen generate
```

## Known limitations (deliberate)

- No real Apple Pay — visual simulation only
- No real QR scan — animated viewfinder + fake resolve
- No real geo map — stylized SwiftUI Canvas
- No backend — `AppState` in-memory + a single `@AppStorage` blob for the onboarded name
- The MAXX dark-intensity mode toggle from the design is not shipped (Phase F stretch goal)

## Troubleshooting

**"iOS 26.5 is not installed" when building**: see *First-time setup* — install the platform via Xcode → Settings → Platforms.

**Fonts look like the system font instead of Bowlby One / Archivo Black**: in Xcode, select the project → **SnackMaxx** target → **Build Phases** → **Copy Bundle Resources** — make sure all 4 `.ttf` files appear. Re-run `xcodegen generate` if any are missing.

**App expires after a week**: that's the free Apple ID provisioning profile. Re-build & re-deploy, or use a paid team for a 1-year cert.

**Black logo on splash**: the `LogoSnackMaxx.imageset` needs the PNG at 1x slot. Already wired in `Assets.xcassets/LogoSnackMaxx.imageset/Contents.json`.
