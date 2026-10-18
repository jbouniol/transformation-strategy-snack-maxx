import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var state: AppState

    private var monthSpend: Double {
        state.purchases.reduce(0) { $0 + $1.price }
    }

    var body: some View {
        OverlayChrome(title: "Historique", onClose: { state.overlay = nil }) {
            VStack(spacing: 0) {
                summaryCard
                    .padding(.horizontal, 18)

                SectionHeader(title: "Toutes mes commandes")

                VStack(spacing: 10) {
                    ForEach(state.purchases) { h in
                        if let p = state.products.first(where: { $0.id == h.productId }),
                           let m = MockData.machines.first(where: { $0.id == h.machineId }) {
                            purchaseRow(purchase: h, product: p, machine: m)
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 130)
            }
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("CE MOIS")
                .font(MxFont.head(10))
                .tracking(1.4)
                .foregroundStyle(Mx.mute)
            HStack(alignment: .lastTextBaseline, spacing: 6) {
                Text(formatEur(monthSpend))
                    .font(MxFont.body(28, weight: .bold))
                    .foregroundStyle(Mx.ink)
                Text("· \(state.purchases.count) snacks")
                    .font(MxFont.body(12))
                    .foregroundStyle(Mx.mute)
            }
            Text("– \(formatEur(state.user.monthSaved)) grâce au club")
                .font(MxFont.body(12, weight: .semibold))
                .foregroundStyle(Mx.okFg)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .mxCard()
    }

    private func purchaseRow(purchase: Purchase, product: Product, machine: Machine) -> some View {
        HStack(spacing: 12) {
            Button {
                state.selectedProduct = product
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(LinearGradient(colors: [
                            product.color.shade(25), product.color.shade(-15)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing))
                    SnackPackage(product: product, size: CGSize(width: 36, height: 46))
                }
                .frame(width: 52, height: 52)
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 2) {
                Text(product.name)
                    .font(MxFont.body(14, weight: .bold))
                    .foregroundStyle(Mx.ink)
                Text("\(purchase.date) · \(machine.shortName)")
                    .font(MxFont.body(12))
                    .foregroundStyle(Mx.mute)
                HStack(spacing: 6) {
                    Text(formatEur(purchase.price))
                        .font(MxFont.body(11, weight: .bold))
                        .foregroundStyle(Mx.ink)
                    Text("· \(purchase.paid)")
                        .font(MxFont.body(10))
                        .foregroundStyle(Mx.mute)
                }
            }
            Spacer(minLength: 4)
            Button { state.reorder(product) } label: {
                HStack(spacing: 4) {
                    MxIcon(name: .bolt, size: 12, color: .white)
                    Text("Reprendre")
                        .font(MxFont.body(12, weight: .bold))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 12).padding(.vertical, 8)
                .background(Mx.ink)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .buttonStyle(.plain)
            .mxPress()
        }
        .padding(12)
        .mxCard()
    }
}
