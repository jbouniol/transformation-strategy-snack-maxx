import SwiftUI

enum AppTab: String, Identifiable, CaseIterable {
    case home, snacks, scan, map, profile
    var id: String { rawValue }
}

enum AppOverlay: Identifiable, Equatable {
    case loyalty
    case history
    case vote
    case ticket
    case notifs
    var id: String {
        switch self {
        case .loyalty: return "loyalty"
        case .history: return "history"
        case .vote:    return "vote"
        case .ticket:  return "ticket"
        case .notifs:  return "notifs"
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    @Published var tab: AppTab = .home
    @Published var machine: Machine = MockData.machines[0]
    @Published var selectedProduct: Product? = nil
    @Published var overlay: AppOverlay? = nil
    @Published var scanOpen: Bool = false
    @Published var payTargetProduct: Product? = nil
    @Published var payTargetMachine: Machine? = nil
    @Published var votes: [VoteRequest] = MockData.votes
    @Published var products: [Product] = MockData.products
    @Published var purchases: [Purchase] = MockData.purchases
    @Published var extraPoints: Int = 0
    @Published var pastTickets: [PastTicket] = MockData.pastTickets

    @AppStorage("user.name") var userName: String = ""
    @AppStorage("user.onboarded") var onboarded: Bool = false

    var user: SnackUser {
        get {
            var u = SnackUser.mock
            if !userName.isEmpty {
                u.name = userName
                let first = u.firstName.lowercased()
                u.email = "\(first)@snackmaxx.com"
            }
            u.monthSpend = purchases.reduce(0) { $0 + $1.price }
            return u
        }
    }

    func completePurchase(product: Product) {
        if let idx = products.firstIndex(where: { $0.id == product.id }) {
            products[idx].stock = max(0, products[idx].stock - 1)
        }
        let newPurchase = Purchase(id: UUID().uuidString, product: product, machine: machine.name, price: product.price, date: Date())
        purchases.insert(newPurchase, at: 0)
        extraPoints += Int(product.price * 10)
        closePay()
    }

    func openPay(product: Product, machine: Machine? = nil) {
        payTargetProduct = product
        payTargetMachine = machine ?? self.machine
    }
    func closePay() {
        payTargetProduct = nil
        payTargetMachine = nil
    }

    func toggleVote(id: String) {
        if let idx = votes.firstIndex(where: { $0.id == id }) {
            var v = votes[idx]
            if v.voted { v.votes -= 1 } else { v.votes += 1 }
            v.voted.toggle()
            votes[idx] = v
        }
    }

    func switchTo(_ tab: AppTab) {
        self.overlay = nil
        self.selectedProduct = nil
        self.tab = tab
    }

    func reorder(_ product: Product) {
        selectedProduct = nil
        openPay(product: product)
    }
}
