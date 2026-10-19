import SwiftUI

struct ProductCard: View {
    let product: Product
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    LinearGradient(colors: [
                        product.color.shade(30), product.color.shade(-20)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: 150)
                    SnackPackage(product: product, size: CGSize(width: 108, height: 130))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // status pill
                    if product.empty {
                        MxPill("Épuisé", kind: .bad)
                            .padding(10)
                    } else if product.hot {
                        HStack(spacing: 4) {
                            MxIcon(name: .flame, size: 12, color: Mx.red)
                            Text("Nouveau")
                                .font(MxFont.body(11, weight: .semibold))
                                .foregroundStyle(Mx.red)
                        }
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(.white.opacity(0.95))
                        .clipShape(Capsule())
                        .padding(10)
                    } else if product.low {
                        MxPill("Stock bas", kind: .warn)
                            .padding(10)
                    }
                    // slot label
                    VStack { Spacer()
                        HStack { Spacer()
                            Text("Slot \(product.slot)")
                                .font(MxFont.body(10, weight: .bold))
                                .foregroundStyle(.white.opacity(0.85))
                                .padding(.trailing, 10).padding(.bottom, 8)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.name)
                        .font(MxFont.body(14, weight: .bold))
                        .foregroundStyle(Mx.ink)
                        .lineLimit(1)
                    Text(product.flavor)
                        .font(MxFont.body(11))
                        .foregroundStyle(Mx.mute)
                        .lineLimit(1)
                    if product.sponsored {
                        Text("SPONSORISÉ")
                            .font(MxFont.body(9, weight: .bold))
                            .tracking(0.5)
                            .foregroundStyle(Mx.mute)
                            .padding(.horizontal, 4).padding(.vertical, 2)
                            .background(Mx.line)
                            .cornerRadius(4)
                            .padding(.top, 2)
                    }
                    HStack(spacing: 6) {
                        Text(String(format: "%.2f €", product.price).replacingOccurrences(of: ".", with: ","))
                            .font(MxFont.body(16, weight: .bold))
                            .foregroundStyle(Mx.ink)
                        Spacer()
                        HStack(spacing: 4) {
                            MxStatusDot(kind: product.empty ? .bad : (product.low ? .warn : .ok))
                            Text(product.empty ? "Vide" : "\(product.stock) en stock")
                                .font(MxFont.body(11))
                                .foregroundStyle(product.empty ? Mx.badFg
                                                 : (product.low ? Mx.warnFg : Mx.mute))
                        }
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
            }
            .background(Mx.card)
            .opacity(product.empty ? 0.55 : 1)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(Mx.line, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 14, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .mxPress()
    }
}
