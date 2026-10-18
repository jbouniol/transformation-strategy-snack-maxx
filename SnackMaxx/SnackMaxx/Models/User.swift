import SwiftUI

enum LoyaltyTier: String, Codable, CaseIterable, Identifiable {
    case bronze, silver, gold
    var id: String { rawValue }
    var label: String {
        switch self {
        case .bronze: return "Bronze"
        case .silver: return "Silver"
        case .gold:   return "Gold"
        }
    }
    var color: Color {
        switch self {
        case .bronze: return Mx.bronze
        case .silver: return Mx.silver
        case .gold:   return Mx.gold
        }
    }
    var bg: Color {
        switch self {
        case .bronze: return Mx.bronzeBg
        case .silver: return Mx.silverBg
        case .gold:   return Mx.goldBg
        }
    }
    var perks: [String] {
        switch self {
        case .bronze:
            return ["1 boisson offerte / mois", "Restock alerts"]
        case .silver:
            return ["1 boisson offerte / mois", "Accès anticipé aux nouveautés", "Pas de frais sur les bundles"]
        case .gold:
            return ["Tout Silver", "Snack offert / semaine", "Bundles exclusifs", "Vote x2"]
        }
    }
    var unlockHint: String {
        switch self {
        case .bronze: return "à 0 pts"
        case .silver: return "à 200 pts"
        case .gold:   return "à 500 pts"
        }
    }
}

struct SnackUser: Codable, Equatable {
    var name: String
    var email: String
    var city: String
    var tier: LoyaltyTier
    var streak: Int
    var bestStreak: Int
    var monthSpend: Double
    var monthSaved: Double
    var nextPerkPts: Int

    var firstName: String {
        name.components(separatedBy: " ").first ?? name
    }
    var initials: String {
        let parts = name.split(separator: " ")
        if parts.isEmpty { return "" }
        if parts.count == 1 {
            return String(parts[0].prefix(2)).uppercased()
        }
        let first = parts.first?.first.map { String($0) } ?? ""
        let last  = parts.dropFirst().first?.first.map { String($0) } ?? ""
        return (first + last).uppercased()
    }

    static let mock = SnackUser(
        name: "Jules Bouniol",
        email: "jules@snackmaxx.com",
        city: "Paris 11e",
        tier: .silver,
        streak: 4,
        bestStreak: 12,
        monthSpend: 18.40,
        monthSaved: 2.10,
        nextPerkPts: 60
    )
}
