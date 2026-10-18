import SwiftUI

struct HomeView: View {
    @EnvironmentObject var state: AppState

    private var featured: [Product] { state.products.filter { $0.hot } }
    private var lowStock: [Product] { state.products.filter { $0.low } }
    private var usuals: [(product: Product, times: Int)] {
        var counts: [String: Int] = [:]
        for p in state.purchases { counts[p.productId, default: 0] += 1 }
        return counts.sorted { $0.value > $1.value }.prefix(4).compactMap { dict in
            guard let p = state.products.first(where: { $0.id == dict.key }) else { return nil }
            return (product: p, times: dict.value)
        }
    }
    private var topPick: (product: Product, times: Int)? { usuals.first }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                AppHeader(
                    machine: state.machine,
                    onLocation: { state.switchTo(.map) },
                    onNotifications: { state.overlay = .notifs },
                    onTicket: { state.overlay = .ticket }
                )
                .padding(.top, 50)

                heroMachineCard
                    .padding(.horizontal, 18)
                    .padding(.top, 8)

                if let top = topPick {
                    personalizedBanner(for: top)
                        .padding(.horizontal, 18)
                        .padding(.top, 12)
                }

                SectionHeader(title: "Reprendre", actionLabel: "Historique") {
                    state.overlay = .history
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(state.purchases.prefix(4)) { p in
                            if let prod = state.products.first(where: { $0.id == p.productId }),
                               let mach = MockData.machines.first(where: { $0.id == p.machineId }) {
                                ReorderCard(product: prod, machine: mach, relative: p.relative) {
                                    state.reorder(prod)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                }

                SectionHeader(title: "Catégories", actionLabel: "Tout voir") {
                    state.switchTo(.snacks)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Array(SnackCategory.allCases.filter { $0 != .all }.enumerated()),
                                id: \.element) { i, cat in
                            CategoryTile(category: cat, index: i) {
                                state.switchTo(.snacks)
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                }

                SectionHeader(title: "À l'honneur", actionLabel: "Voir plus") {
                    state.switchTo(.snacks)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(featured) { p in
                            FeaturedCard(product: p) { state.selectedProduct = p }
                        }
                    }
                    .padding(.horizontal, 18)
                }

                LoyaltyTeaser(user: state.user) { state.overlay = .loyalty }
                    .padding(.horizontal, 18)
                    .padding(.top, 16)

                VoteTeaser(votes: state.votes, machine: state.machine) { state.overlay = .vote }
                    .padding(.horizontal, 18)
                    .padding(.top, 12)

                SectionHeader(title: "Ça part vite", actionLabel: "Voir tout") {
                    state.switchTo(.snacks)
                }

                VStack(spacing: 0) {
                    ForEach(Array(lowStock.enumerated()), id: \.element.id) { i, p in
                        Button { state.selectedProduct = p } label: {
                            HStack(spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(LinearGradient(colors: [
                                            p.color.shade(15), p.color.shade(-15)
                                        ], startPoint: .top, endPoint: .bottom))
                                    SnackPackage(product: p, size: CGSize(width: 34, height: 42))
                                }
                                .frame(width: 48, height: 48)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(p.name)
                                        .font(MxFont.body(14, weight: .bold))
                                        .foregroundStyle(Mx.ink)
                                    Text("Slot \(p.slot) · \(p.flavor)")
                                        .font(MxFont.body(12))
                                        .foregroundStyle(Mx.mute)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text(formatEur(p.price))
                                        .font(MxFont.body(15, weight: .bold))
                                        .foregroundStyle(Mx.ink)
                                    MxPill("\(p.stock) restant\(p.stock > 1 ? "s" : "")", kind: .warn)
                                }
                            }
                            .padding(.horizontal, 14).padding(.vertical, 12)
                            .background(Color.clear)
                            .overlay(alignment: .top) {
                                if i > 0 {
                                    Rectangle().fill(Mx.line2).frame(height: 1)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .mxPress()
                    }
                }
                .background(Mx.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Mx.line, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .padding(.horizontal, 18)
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Hero machine card

    private var heroMachineCard: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(colors: [Mx.orangeHot, Mx.orangeDeep, Mx.red],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            Canvas { ctx, size in
                var p = Path()
                p.move(to: CGPoint(x: -40, y: size.height * 0.55))
                p.addQuadCurve(to: CGPoint(x: size.width + 40, y: size.height * 0.5),
                               control: CGPoint(x: size.width / 2, y: size.height * 0.18))
                ctx.stroke(p, with: .color(Mx.blue.opacity(0.85)),
                           style: .init(lineWidth: 10, lineCap: .round))
                var q = Path()
                q.move(to: CGPoint(x: -40, y: size.height * 0.65))
                q.addQuadCurve(to: CGPoint(x: size.width + 40, y: size.height * 0.6),
                               control: CGPoint(x: size.width / 2, y: size.height * 0.28))
                ctx.stroke(q, with: .color(Mx.yellow.opacity(0.55)),
                           style: .init(lineWidth: 4, lineCap: .round))
            }
            .opacity(0.4)
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color(hex: 0x5BFFA0))
                        .frame(width: 8, height: 8)
                        .overlay(Circle().stroke(Color(hex: 0x5BFFA0).opacity(0.4), lineWidth: 4))
                    Text("STOCK EN DIRECT")
                        .font(MxFont.body(10, weight: .bold))
                        .tracking(1.8)
                        .foregroundStyle(.white.opacity(0.95))
                }
                VStack(alignment: .leading, spacing: 4) {
                    MaxxHead(text: state.machine.shortName, size: 26, color: .white)
                    Text(state.machine.subName.isEmpty ? state.machine.address : state.machine.subName)
                        .font(MxFont.body(13))
                        .foregroundStyle(.white.opacity(0.9))
                }
                HStack(spacing: 8) {
                    statBlock(label: "RÉFS", value: "\(state.machine.products)")
                    statBlock(label: "STOCK", value: "\(state.machine.stockHealth)%")
                    statBlock(label: "DISTANCE", value: state.machine.distanceLabel)
                }
                HStack(spacing: 10) {
                    MaxxButton("Scanner & payer", variant: .cream, size: .md,
                               action: { state.scanOpen = true }) {
                        MxIcon(name: .qrcode, size: 18, color: Mx.ink)
                    }
                    .frame(maxWidth: .infinity)
                    MaxxButton("Voir les snacks", variant: .dark, size: .md,
                               action: { state.switchTo(.snacks) }) {
                        MxIcon(name: .snack, size: 18, color: .white)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Mx.red.opacity(0.32), radius: 30, x: 0, y: 12)
    }

    private func statBlock(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(MxFont.head(10)).tracking(1.4)
                .foregroundStyle(.white.opacity(0.9))
            Text(value)
                .font(MxFont.body(20, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12).padding(.vertical, 9)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func personalizedBanner(for pick: (product: Product, times: Int)) -> some View {
        Button {
            state.selectedProduct = pick.product
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(LinearGradient(colors: [
                            pick.product.color.shade(25), pick.product.color.shade(-15)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing))
                    SnackPackage(product: pick.product, size: CGSize(width: 36, height: 46))
                }
                .frame(width: 52, height: 52)
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        MxIcon(name: .bolt, size: 11, color: Mx.orange)
                        Text("POUR TOI À CETTE HEURE")
                            .font(MxFont.head(10))
                            .tracking(1.4)
                            .foregroundStyle(Mx.orange)
                    }
                    Text("Ton \(pick.product.name), dispo à \(state.machine.distanceLabel).")
                        .font(MxFont.body(14, weight: .bold))
                        .foregroundStyle(Mx.ink)
                        .lineLimit(2)
                    Text("Tu l'as pris \(pick.times)× cette semaine.")
                        .font(MxFont.body(11))
                        .foregroundStyle(Mx.mute)
                }
                Spacer(minLength: 4)
                MxIcon(name: .chevron, size: 18, color: Mx.mute)
            }
            .padding(.leading, 10).padding(.trailing, 12).padding(.vertical, 10)
            .background(Mx.card)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Mx.line, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 14, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .mxPress()
    }
}

private struct ReorderCard: View {
    let product: Product
    let machine: Machine
    let relative: String
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                LinearGradient(colors: [
                    product.color.shade(28), product.color.shade(-15)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 80)
                SnackPackage(product: product, size: CGSize(width: 58, height: 70))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text(relative)
                    .font(MxFont.body(9, weight: .bold))
                    .foregroundStyle(Mx.ink)
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(.white.opacity(0.95))
                    .clipShape(Capsule())
                    .padding(6)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(product.name)
                    .font(MxFont.body(12, weight: .bold))
                    .foregroundStyle(Mx.ink)
                    .lineLimit(1)
                Text(machine.shortName)
                    .font(MxFont.body(10))
                    .foregroundStyle(Mx.mute)
                    .lineLimit(1)
                Button(action: action) {
                    Text("Reprendre · \(formatEur(product.price))")
                        .font(MxFont.body(11, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(Mx.ink)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .buttonStyle(.plain)
                .mxPress()
                .padding(.top, 4)
            }
            .padding(.horizontal, 10).padding(.vertical, 10)
        }
        .frame(width: 168)
        .background(Mx.card)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Mx.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 14, x: 0, y: 4)
    }
}
