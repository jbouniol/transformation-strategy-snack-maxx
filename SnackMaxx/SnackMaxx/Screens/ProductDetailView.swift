import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var state: AppState
    let product: Product

    var body: some View {
        ZStack {
            Mx.paper.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // hero
                    ZStack(alignment: .top) {
                        LinearGradient(colors: [product.color.shade(25), product.color.shade(-10)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                        Canvas { ctx, size in
                            var p = Path()
                            p.move(to: CGPoint(x: -40, y: size.height * 0.6))
                            p.addQuadCurve(to: CGPoint(x: size.width + 40, y: size.height * 0.5),
                                           control: CGPoint(x: size.width / 2, y: size.height * 0.15))
                            ctx.stroke(p, with: .color(.white.opacity(0.45)), lineWidth: 6)
                        }
                        VStack(spacing: 18) {
                            HStack {
                                circleGlass(icon: .back, action: { state.selectedProduct = nil })
                                Spacer()
                                MxPill("Slot \(product.slot)", kind: .neutral)
                                    .opacity(0.95)
                                Spacer()
                                circleGlass(icon: .heart, action: {})
                            }
                            SnackPackage(product: product, size: CGSize(width: 200, height: 240))
                                .padding(.bottom, 18)
                        }
                        .padding(.horizontal, 18)
                        .padding(.top, 50)
                    }
                    .frame(height: 380)
                    .clipShape(RoundedCornerShape(radius: 28, corners: [.bottomLeft, .bottomRight]))

                    // info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.flavor.uppercased())
                            .font(MxFont.head(10))
                            .tracking(1.6)
                            .foregroundStyle(Mx.orange)
                        HStack(alignment: .lastTextBaseline) {
                            MaxxHead(text: product.name, size: 30)
                            Spacer()
                            Text(formatEur(product.price))
                                .font(MxFont.body(22, weight: .bold))
                                .foregroundStyle(Mx.ink)
                        }
                        Text("\(product.tagline).")
                            .font(MxFont.body(14))
                            .foregroundStyle(Mx.ink2)
                            .lineSpacing(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18).padding(.top, 20)

                    HStack(spacing: 10) {
                        infoCard(title: "STOCK",
                                 value: product.empty ? "0" : "\(product.stock)",
                                 unit: "unités",
                                 pill: (
                                    product.empty
                                    ? ("Rupture", PillStyleKind.bad)
                                    : (product.low ? ("Bas", .warn) : ("Disponible", .ok))
                                 ),
                                 valueColor: product.empty ? Mx.badFg : Mx.ink)
                        infoCard(title: "CALORIES", value: "\(product.kcal)", unit: "kcal",
                                 pill: nil, valueColor: Mx.ink,
                                 footer: "Portion \(product.category == .drinks ? "33cl" : "45g")")
                    }
                    .padding(.horizontal, 18).padding(.top, 14)

                    nutriRow
                        .padding(.horizontal, 18).padding(.top, 12)

                    machineRow
                        .padding(.horizontal, 18).padding(.top, 12)

                    if product.empty {
                        MaxxButton("Me prévenir au restock", variant: .dark, size: .lg, full: true,
                                   action: {}) { MxIcon(name: .bell, size: 20, color: .white) }
                            .padding(.horizontal, 18).padding(.top, 18)
                    } else {
                        Button {
                            state.openPay(product: product)
                            state.selectedProduct = nil
                        } label: {
                            HStack(spacing: 8) {
                                MxIcon(name: .apple, size: 20, color: .white)
                                Text("Payer · \(formatEur(product.price))")
                                    .font(MxFont.body(16, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity).frame(height: 54)
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.32), radius: 22, x: 0, y: 8)
                        }
                        .buttonStyle(.plain)
                        .mxPress()
                        .padding(.horizontal, 18).padding(.top, 18)
                    }
                    Text(product.empty
                         ? "On te ping dès que le slot est rechargé."
                         : "Paiement instantané · livraison sur le slot.")
                        .font(MxFont.body(11))
                        .foregroundStyle(Mx.mute)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8).padding(.bottom, 40)
                }
            }
        }
    }

    private func circleGlass(icon: MxIconName, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle().fill(.white.opacity(0.18))
                    .background(.ultraThinMaterial, in: Circle())
                MxIcon(name: icon, size: 20, color: .white)
            }
            .frame(width: 40, height: 40)
        }
        .buttonStyle(.plain)
    }

    private func infoCard(title: String, value: String, unit: String,
                          pill: (String, PillStyleKind)?,
                          valueColor: Color = Mx.ink,
                          footer: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(MxFont.head(10))
                .tracking(1.6)
                .foregroundStyle(Mx.mute)
            HStack(alignment: .lastTextBaseline, spacing: 6) {
                Text(value)
                    .font(MxFont.body(28, weight: .bold))
                    .foregroundStyle(valueColor)
                Text(unit)
                    .font(MxFont.body(12))
                    .foregroundStyle(Mx.mute)
            }
            if let (label, kind) = pill {
                MxPill(label, kind: kind).padding(.top, 6)
            }
            if let footer {
                Text(footer)
                    .font(MxFont.body(12))
                    .foregroundStyle(Mx.mute)
                    .padding(.top, 6)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .mxCard()
    }

    private var nutriRow: some View {
        HStack(spacing: 0) {
            if product.category == .drinks {
                nutriItem("PROTÉINES", "0g", showDivider: true)
                nutriItem("GLUCIDES", product.kcal == 0 ? "0g" : "11g", showDivider: true)
                nutriItem("SUCRES", product.kcal == 0 ? "0g" : "11g", showDivider: true)
                nutriItem("SEL", "0.0g", showDivider: false)
            } else if product.category == .fit {
                nutriItem("PROTÉINES", product.name.contains("Proteine") ? "22g" : "15g", showDivider: true)
                nutriItem("GLUCIDES",  "14g", showDivider: true)
                nutriItem("SUCRES",    "2g", showDivider: true)
                nutriItem("SEL",       "0.2g", showDivider: false)
            } else {
                nutriItem("PROTÉINES", "6g", showDivider: true)
                nutriItem("GLUCIDES",  "28g", showDivider: true)
                nutriItem("SUCRES",    "12g", showDivider: true)
                nutriItem("SEL",       "0.8g", showDivider: false)
            }
        }
        .padding(.vertical, 12)
        .mxCard()
    }

    private func nutriItem(_ k: String, _ v: String, showDivider: Bool) -> some View {
        VStack(spacing: 2) {
            Text(k).font(MxFont.head(10)).tracking(1.4).foregroundStyle(Mx.mute)
            Text(v).font(MxFont.body(16, weight: .bold)).foregroundStyle(Mx.ink)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .trailing) {
            if showDivider {
                Rectangle().fill(Mx.line2).frame(width: 1, height: 28)
            }
        }
    }

    private var machineRow: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Mx.orange.opacity(0.10))
                MxIcon(name: .pin, size: 18, color: Mx.orange)
            }
            .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text("DISPONIBLE SUR")
                    .font(MxFont.head(10)).tracking(1.4).foregroundStyle(Mx.mute)
                Text(state.machine.name)
                    .font(MxFont.body(14, weight: .bold)).foregroundStyle(Mx.ink)
                Text("\(state.machine.distanceLabel) · \(state.machine.address)")
                    .font(MxFont.body(12)).foregroundStyle(Mx.mute)
            }
            Spacer()
            MxIcon(name: .chevron, size: 18, color: Mx.mute)
        }
        .padding(14)
        .mxCard()
    }
}

/// Used for the hero's bottom-only rounded corners.
struct RoundedCornerShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(roundedRect: rect, byRoundingCorners: corners,
                          cornerRadii: CGSize(width: radius, height: radius)).cgPath)
    }
}
