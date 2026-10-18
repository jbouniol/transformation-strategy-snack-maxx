import SwiftUI

struct PayConfirmView: View {
    @EnvironmentObject var state: AppState
    let product: Product
    let machine: Machine

    @State private var phase: Phase = .confirm
    enum Phase { case confirm, auth, success }

    var body: some View {
        ZStack {
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { state.closePay() }
            VStack {
                Spacer()
                sheet
            }
            .ignoresSafeArea()
        }
    }

    private var sheet: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(.black.opacity(0.15))
                .frame(width: 40, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 8)
            content
                .padding(.horizontal, 18)
                .padding(.bottom, 28)
                .animation(.easeInOut(duration: 0.25), value: phase)
        }
        .background(.white)
        .clipShape(RoundedCornerShape(radius: 28, corners: [.topLeft, .topRight]))
        .shadow(color: .black.opacity(0.35), radius: 30, x: 0, y: -10)
    }

    @ViewBuilder private var content: some View {
        switch phase {
        case .confirm: confirmPhase
        case .auth:    authPhase
        case .success: successPhase
        }
    }

    // MARK: - Phase 1

    private var confirmPhase: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("CONFIRMATION")
                .font(MxFont.head(11))
                .tracking(1.8)
                .foregroundStyle(Mx.orange)
            MaxxHead(text: "Payer ton snack", size: 24)
                .padding(.top, 4)

            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(LinearGradient(colors: [
                            product.color.shade(25), product.color.shade(-15)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing))
                    SnackPackage(product: product, size: CGSize(width: 40, height: 50))
                }
                .frame(width: 56, height: 56)
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.name)
                        .font(MxFont.body(14, weight: .bold)).foregroundStyle(Mx.ink)
                    Text("Slot \(product.slot) · \(machine.shortName)")
                        .font(MxFont.body(12)).foregroundStyle(Mx.mute)
                }
                Spacer()
                Text(formatEur(product.price))
                    .font(MxFont.body(18, weight: .bold))
                    .foregroundStyle(Mx.ink)
            }
            .padding(12)
            .mxCard()
            .padding(.top, 14)

            totalsBox
                .padding(.top, 10)

            Button {
                phase = .auth
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    if phase == .auth { phase = .success }
                }
            } label: {
                HStack(spacing: 8) {
                    MxIcon(name: .apple, size: 20, color: .white)
                    Text("Payer avec Apple Pay")
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
            .padding(.top, 18)

            HStack(spacing: 8) {
                MxIcon(name: .credit, size: 18, color: Mx.ink)
                Text("Visa •• 4242")
                    .font(MxFont.body(14, weight: .semibold))
                    .foregroundStyle(Mx.ink)
            }
            .frame(maxWidth: .infinity).frame(height: 50)
            .background(Mx.paper2)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Mx.line, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.top, 8)

            Text("Transaction sécurisée · livraison instantanée à la machine")
                .font(MxFont.body(11))
                .foregroundStyle(Mx.mute)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
        }
    }

    private var totalsBox: some View {
        VStack(spacing: 6) {
            totalsRow(label: "Snack", value: formatEur(product.price), color: Mx.ink2)
            totalsRow(label: "Réduction Silver", value: "– 0,10 €", color: Mx.okFg)
            totalsRow(label: "Points gagnés",
                      value: "+\(Int(product.price * 10)) pts",
                      color: Mx.orange)
            Rectangle().fill(Mx.line).frame(height: 1).padding(.top, 2)
            HStack {
                Text("Total")
                    .font(MxFont.body(15, weight: .bold)).foregroundStyle(Mx.ink)
                Spacer()
                Text(formatEur(product.price - 0.10))
                    .font(MxFont.body(18, weight: .bold)).foregroundStyle(Mx.ink)
            }
        }
        .padding(12)
        .background(Mx.paper2)
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Mx.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func totalsRow(label: String, value: String, color: Color) -> some View {
        HStack {
            Text(label)
                .font(MxFont.body(13))
                .foregroundStyle(Mx.ink2)
            Spacer()
            Text(value)
                .font(MxFont.body(13, weight: .semibold))
                .foregroundStyle(color)
        }
    }

    // MARK: - Phase 2

    @State private var pulse = false

    private var authPhase: some View {
        VStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.black)
                MxIcon(name: .face, size: 50, color: .white, weight: .light)
            }
            .frame(width: 96, height: 96)
            .scaleEffect(pulse ? 1.06 : 0.96)
            .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 6)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
            MaxxHead(text: "Regarde l'iPhone", size: 22)
            Text("Authentification Face ID…")
                .font(MxFont.body(14)).foregroundStyle(Mx.mute)
            Button {
                phase = .success
            } label: {
                Text("Simuler la validation")
                    .font(MxFont.body(12, weight: .semibold))
                    .foregroundStyle(Mx.ink)
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Mx.line, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            .padding(.top, 14)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }

    // MARK: - Phase 3

    private var successPhase: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle().fill(Mx.okBg)
                MxIcon(name: .check, size: 48, color: Mx.okFg)
            }
            .frame(width: 96, height: 96)
            MaxxHead(text: "Payé !", size: 26)
            Text("Va chercher ton ")
                .font(MxFont.body(14))
                .foregroundStyle(Mx.ink2)
              + Text(product.name).font(MxFont.body(14, weight: .bold)).foregroundColor(Mx.ink)
              + Text(" sur le ").font(MxFont.body(14)).foregroundColor(Mx.ink2)
              + Text("slot \(product.slot).").font(MxFont.body(14, weight: .bold)).foregroundColor(Mx.ink)

            recoveryTicket
                .padding(.top, 8)

            MaxxButton("Récupéré, merci !", variant: .primary, size: .lg, full: true, action: {
                state.completePurchase(product: product)
            }) {
                MxIcon(name: .check, size: 20, color: .white)
            }
            .padding(.top, 4)

            Text("+ \(Int(product.price * 10)) pts ajoutés à ton compte")
                .font(MxFont.body(11))
                .foregroundStyle(Mx.mute)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding(.top, 12)
    }

    private var recoveryTicket: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("CODE DE RÉCUPÉRATION")
                .font(MxFont.head(11))
                .tracking(1.4)
                .foregroundStyle(Mx.yellow)
            HStack(spacing: 4) {
                ForEach(Array("\(product.slot)-4F").map { String($0) }, id: \.self) { c in
                    Text(c)
                        .font(MxFont.display(36))
                        .italic()
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.25), radius: 0, x: 0, y: 3)
                }
            }
            Text("Distribué automatiquement dans 3 secondes — sinon, tape ce code sur l'écran de la machine.")
                .font(MxFont.body(12))
                .foregroundStyle(.white.opacity(0.85))
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(LinearGradient(colors: [Mx.orangeHot, Mx.red],
                                   startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Mx.red.opacity(0.3), radius: 22, x: 0, y: 12)
    }
}
