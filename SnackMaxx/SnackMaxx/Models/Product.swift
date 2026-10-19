import SwiftUI

enum SnackKind: String, Codable {
    case chips, bar, cookie, can, bottle, healthy
}

enum SnackCategory: String, Codable, CaseIterable, Identifiable {
    case all, chips, choco, cookie, drinks, fit
    var id: String { rawValue }
    var label: String {
        switch self {
        case .all:    return "Tout"
        case .chips:  return "Chips"
        case .choco:  return "Choco"
        case .cookie: return "Cookies"
        case .drinks: return "Boissons"
        case .fit:    return "Healthy"
        }
    }
}

struct Product: Identifiable, Hashable {
    let id: String
    let category: SnackCategory
    let kind: SnackKind
    let name: String
    let flavor: String
    let price: Double
    var stock: Int
    let hot: Bool
    let low: Bool
    var empty: Bool
    let kcal: Int
    let colorHex: UInt32
    let accentHex: UInt32
    let slot: String
    let tagline: String
    var sponsored: Bool = false

    var color: Color { Color(hex: colorHex) }
    var accent: Color { Color(hex: accentHex) }
    var shortLabel: String {
        let base = name.replacingOccurrences(of: "Maxx ", with: "", options: [.caseInsensitive])
        return String(base.prefix(8)).uppercased()
    }
}
