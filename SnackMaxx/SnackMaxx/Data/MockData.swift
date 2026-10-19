import Foundation

enum MockData {

    static let products: [Product] = [
        // chips / savory
        Product(id: "p01", category: .chips, kind: .chips,
                name: "Maxx Inferno", flavor: "Chili Hellfire",
                price: 2.20, stock: 7, hot: true, low: false, empty: false, kcal: 240,
                colorHex: 0xFF3D14, accentHex: 0xFFD23F, slot: "A2",
                tagline: "Pour les durs à cuire"),
        Product(id: "p02", category: .chips, kind: .chips,
                name: "Maxx Crunch", flavor: "Salt & Vinegar",
                price: 2.00, stock: 12, hot: false, low: false, empty: false, kcal: 220,
                colorHex: 0x2BB4E8, accentHex: 0xFFE4B0, slot: "A3",
                tagline: "Le claquement original"),
        Product(id: "p03", category: .chips, kind: .chips,
                name: "Maxx BBQ", flavor: "Barbecue Boss",
                price: 2.00, stock: 3, hot: false, low: true, empty: false, kcal: 250,
                colorHex: 0xC7281D, accentHex: 0xFFD23F, slot: "A5",
                tagline: "Fumé jusqu'à l'os"),

        // choco / bars
        Product(id: "p04", category: .choco, kind: .bar,
                name: "Maxx Mega", flavor: "Caramel Crunch",
                price: 1.80, stock: 18, hot: false, low: false, empty: false, kcal: 320,
                colorHex: 0x8B1A0E, accentHex: 0xFFD23F, slot: "B1",
                tagline: "Triple couche, zéro pardon"),
        Product(id: "p05", category: .choco, kind: .bar,
                name: "Maxx Choco-X", flavor: "Dark Choco",
                price: 1.60, stock: 9, hot: false, low: false, empty: false, kcal: 280,
                colorHex: 0x3A2F28, accentHex: 0xFF7A1F, slot: "B2",
                tagline: "Cacao 70%, attitude 100%"),
        Product(id: "p06", category: .choco, kind: .bar,
                name: "Maxx Hazel", flavor: "Noisette Folle",
                price: 1.80, stock: 0, hot: false, low: false, empty: true, kcal: 290,
                colorHex: 0xB07A00, accentHex: 0xFFE4B0, slot: "B4",
                tagline: "Croquant signature"),

        // cookies
        Product(id: "p07", category: .cookie, kind: .cookie,
                name: "Maxx Cookie", flavor: "Triple Choco",
                price: 1.50, stock: 14, hot: false, low: false, empty: false, kcal: 260,
                colorHex: 0xFFB300, accentHex: 0xC7281D, slot: "C1",
                tagline: "3 pépites par bouchée"),
        Product(id: "p08", category: .cookie, kind: .cookie,
                name: "Maxx Stuffd", flavor: "Cœur Coulant",
                price: 2.10, stock: 6, hot: true, low: false, empty: false, kcal: 330,
                colorHex: 0xFF7A1F, accentHex: 0xFFE4B0, slot: "C2",
                tagline: "Avec un cœur fondant"),

        // drinks
        Product(id: "p09", category: .drinks, kind: .can,
                name: "Maxx Fuel", flavor: "Energy Original",
                price: 2.50, stock: 22, hot: false, low: false, empty: false, kcal: 110,
                colorHex: 0x2BB4E8, accentHex: 0xFFD23F, slot: "D1",
                tagline: "Plein gaz, zéro filtre", sponsored: true),
        Product(id: "p10", category: .drinks, kind: .can,
                name: "Maxx Volt", flavor: "Lemon Voltage",
                price: 2.50, stock: 11, hot: true, low: false, empty: false, kcal: 95,
                colorHex: 0xFFB300, accentHex: 0x15110E, slot: "D2",
                tagline: "Acide & électrique"),
        Product(id: "p11", category: .drinks, kind: .bottle,
                name: "Maxx Berry", flavor: "Fruits Rouges",
                price: 2.30, stock: 4, hot: false, low: true, empty: false, kcal: 80,
                colorHex: 0xFF3D7F, accentHex: 0xFFE4B0, slot: "D4",
                tagline: "100% jus, 0% calme"),
        Product(id: "p12", category: .drinks, kind: .can,
                name: "Maxx Cola", flavor: "Cola Classic",
                price: 2.20, stock: 16, hot: false, low: false, empty: false, kcal: 140,
                colorHex: 0xC7281D, accentHex: 0xFFD23F, slot: "D5",
                tagline: "Recette OG"),

        // healthy
        Product(id: "p13", category: .fit, kind: .healthy,
                name: "Maxx Fit", flavor: "Noix & Miel",
                price: 2.40, stock: 8, hot: false, low: false, empty: false, kcal: 180,
                colorHex: 0x29C46B, accentHex: 0xFFD23F, slot: "E1",
                tagline: "Pour rouler longtemps"),
        Product(id: "p14", category: .fit, kind: .healthy,
                name: "Maxx Proteine", flavor: "Choco Whey",
                price: 2.80, stock: 5, hot: false, low: true, empty: false, kcal: 210,
                colorHex: 0x1376B8, accentHex: 0xFFE4B0, slot: "E2",
                tagline: "22g de protéines", sponsored: true),
    ]

    static let machines: [Machine] = [
        Machine(id: "m01", name: "Campus Sorbonne — Hall B",
                distance: 0.045, status: .live, products: 38,
                restock: "il y a 2h", address: "Paris 5e · Niveau -1",
                open: true, stockHealth: 86),
        Machine(id: "m02", name: "Université Paris Dauphine — Cafétéria",
                distance: 0.320, status: .live, products: 42,
                restock: "il y a 6h", address: "Paris 16e · RDC Aile Est",
                open: true, stockHealth: 92),
        Machine(id: "m03", name: "Sciences Po — Bibliothèque",
                distance: 0.680, status: .live, products: 28,
                restock: "hier, 21:30", address: "Paris 7e · 27 rue Saint-Guillaume",
                open: true, stockHealth: 64),
        Machine(id: "m04", name: "Station Châtelet — Sortie 1",
                distance: 1.10, status: .live, products: 19,
                restock: "il y a 3 jours", address: "Paris 1er · Hall correspondances",
                open: true, stockHealth: 74),
        Machine(id: "m05", name: "Gare du Nord — Quai Transilien",
                distance: 2.30, status: .offline, products: 0,
                restock: "il y a 1h", address: "Paris 10e · Niveau -1 (Maintenance)",
                open: false, stockHealth: 0),
    ]

    static let purchases: [Purchase] = [
        Purchase(id: "h01", productId: "p09", machineId: "m01", date: "Auj. · 14:22", relative: "il y a 1h",  price: 2.50, paid: "Apple Pay"),
        Purchase(id: "h02", productId: "p07", machineId: "m01", date: "Auj. · 09:08", relative: "ce matin",   price: 1.50, paid: "Apple Pay"),
        Purchase(id: "h03", productId: "p09", machineId: "m02", date: "Hier · 18:40", relative: "hier",       price: 2.50, paid: "Carte"),
        Purchase(id: "h04", productId: "p04", machineId: "m01", date: "Hier · 12:11", relative: "hier",       price: 1.80, paid: "Apple Pay"),
        Purchase(id: "h05", productId: "p10", machineId: "m03", date: "Lun · 17:02",  relative: "lundi",      price: 2.50, paid: "Apple Pay"),
        Purchase(id: "h06", productId: "p09", machineId: "m01", date: "Lun · 09:14",  relative: "lundi",      price: 2.50, paid: "Apple Pay"),
        Purchase(id: "h07", productId: "p07", machineId: "m02", date: "Dim · 19:30",  relative: "dim.",       price: 1.50, paid: "Carte"),
    ]

    static let votes: [VoteRequest] = [
        VoteRequest(id: "v01", name: "Kinder Bueno",         brand: "Ferrero",   category: .choco,  votes: 47, voted: true,  trend: "+12"),
        VoteRequest(id: "v02", name: "Pringles Sour Cream",  brand: "Pringles",  category: .chips,  votes: 32, voted: false, trend: "+5"),
        VoteRequest(id: "v03", name: "Red Bull Sugarfree",   brand: "Red Bull",  category: .drinks, votes: 28, voted: false, trend: "+8"),
        VoteRequest(id: "v04", name: "Granola Honey & Nuts", brand: "Belvita",   category: .cookie, votes: 19, voted: false, trend: "+3"),
        VoteRequest(id: "v05", name: "Oreo Original",        brand: "Mondelēz",  category: .cookie, votes: 14, voted: true,  trend: "+2"),
        VoteRequest(id: "v06", name: "Coca-Cola Zero",       brand: "Coca-Cola", category: .drinks, votes: 11, voted: false, trend: "+1"),
    ]

    static let votesFulfilled: [VoteFulfilled] = [
        VoteFulfilled(id: "f01", name: "Maxx Inferno", date: "il y a 2 semaines", machine: "Campus Sorbonne"),
        VoteFulfilled(id: "f02", name: "Maxx Volt",    date: "il y a 1 mois",     machine: "Gare du Nord"),
    ]

    static let ticketTypes: [TicketType] = [
        TicketType(id: "jam",     label: "Machine bloquée",       icon: "alert"),
        TicketType(id: "empty",   label: "Slot vide alors qu'affiché plein", icon: "package"),
        TicketType(id: "wrong",   label: "Mauvais produit livré", icon: "shuffle"),
        TicketType(id: "expired", label: "Produit périmé",        icon: "clock"),
        TicketType(id: "payment", label: "Problème de paiement",  icon: "credit"),
        TicketType(id: "other",   label: "Autre",                 icon: "info"),
    ]

    static let pastTickets: [PastTicket] = [
        PastTicket(id: "t01", date: "Hier · 19:00", machine: "Sciences Po", type: "Slot vide",      status: "Remboursé", color: .ok),
        PastTicket(id: "t02", date: "Lun · 11:32",  machine: "Campus Sorbonne",  type: "Mauvais produit", status: "En cours",  color: .warn),
    ]

    /// Top usuals derived from purchases (productId, count).
    static func usuals() -> [(product: Product, times: Int)] {
        var counts: [String: Int] = [:]
        for p in purchases { counts[p.productId, default: 0] += 1 }
        return counts
            .sorted { $0.value > $1.value }
            .prefix(4)
            .compactMap { (id, n) in
                products.first(where: { $0.id == id }).map { ($0, n) }
            }
    }
}
