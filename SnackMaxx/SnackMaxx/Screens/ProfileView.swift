import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var state: AppState

    private let favIds = ["p01", "p09", "p07"]
    private let savedIds = ["m01", "m03"]

    private var favs: [Product] { favIds.compactMap { id in state.products.first(where: { $0.id == id }) } }
    private var saved: [Machine] { savedIds.compactMap { id in MockData.machines.first(where: { $0.id == id }) } }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Image("LogoSnackMaxx")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)
                        .padding(.bottom, 10)
                    HStack {
                        MaxxHead(text: "Profil", size: 30)
                        Spacer()
                        ZStack {
                            Circle().fill(Mx.card)
                            MxIcon(name: .settings, size: 18, color: Mx.ink)
                        }
                        .frame(width: 40, height: 40)
                        .overlay(Circle().stroke(Mx.line, lineWidth: 1))
                    }
                }
                .padding(.horizontal, 18).padding(.top, 52).padding(.bottom, 12)

                identityCard
                    .padding(.horizontal, 18)

                HStack(spacing: 8) {
                    statCard(title: "SNACKS", value: "\(state.purchases.count)", sub: "ce mois")
                    statCard(title: "DÉPENSÉ", value: formatEur(state.user.monthSpend), sub: "ce mois")
                    statCard(title: "ÉCONOMISÉ", value: formatEur(state.user.monthSaved), sub: "via le club")
                }
                .padding(.horizontal, 18).padding(.top, 12)

                SectionHeader(title: "Mes activités")
                activitiesList
                    .padding(.horizontal, 18)

                SectionHeader(title: "Snacks favoris", actionLabel: "Tout voir", onAction: {})
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(favs) { p in
                            Button { state.selectedProduct = p } label: {
                                VStack(alignment: .leading, spacing: 0) {
                                    ZStack(alignment: .topTrailing) {
                                        LinearGradient(colors: [
                                            p.color.shade(25), p.color.shade(-20)
                                        ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .frame(height: 110)
                                        SnackPackage(product: p, size: CGSize(width: 84, height: 100))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        MxIcon(name: .heartFill, size: 16, color: .white)
                                            .padding(8)
                                    }
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(p.name)
                                            .font(MxFont.body(12, weight: .bold))
                                            .foregroundStyle(Mx.ink)
                                            .lineLimit(1)
                                        Text(formatEur(p.price))
                                            .font(MxFont.body(11))
                                            .foregroundStyle(Mx.mute)
                                    }
                                    .padding(10)
                                }
                                .frame(width: 144)
                                .background(Mx.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Mx.line, lineWidth: 1)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                            .buttonStyle(.plain)
                            .mxPress()
                        }
                    }
                    .padding(.horizontal, 18)
                }

                SectionHeader(title: "Mes distributeurs", actionLabel: "Gérer", onAction: {})
                VStack(spacing: 10) {
                    ForEach(saved) { m in
                        MachineRow(machine: m, isActive: state.machine.id == m.id) {
                            state.machine = m
                            state.switchTo(.home)
                        }
                    }
                }
                .padding(.horizontal, 18)

                SectionHeader(title: "Préférences")
                preferencesList
                    .padding(.horizontal, 18)
                    .padding(.bottom, 20)
            }
        }
    }

    private var identityCard: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Mx.orangeHot, Mx.red],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                    Text(state.user.initials)
                        .font(MxFont.display(24))
                        .italic()
                        .foregroundStyle(.white)
                }
                .frame(width: 60, height: 60)
                .shadow(color: Mx.red.opacity(0.3), radius: 14, x: 0, y: 6)
                VStack(alignment: .leading, spacing: 2) {
                    Text(state.user.name)
                        .font(MxFont.body(17, weight: .bold))
                        .foregroundStyle(Mx.ink)
                    Text("\(state.user.email) · \(state.user.city)")
                        .font(MxFont.body(12))
                        .foregroundStyle(Mx.mute)
                }
                Spacer()
                HStack(spacing: 5) {
                    MxIcon(name: .trophy, size: 11, color: state.user.tier.color)
                    Text(state.user.tier.label.uppercased())
                        .font(MxFont.body(11, weight: .bold))
                        .tracking(0.6)
                        .foregroundStyle(state.user.tier.color)
                }
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(state.user.tier.bg)
                .clipShape(Capsule())
            }
            .padding(18)

            Button { state.overlay = .loyalty } label: {
                HStack(spacing: 12) {
                    VStack(spacing: 2) {
                        MxIcon(name: .fire, size: 14, color: .white)
                        Text("\(state.user.streak)j")
                            .font(MxFont.body(12, weight: .heavy))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 44, height: 44)
                    .background(Mx.streakBadgeGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Mx.red.opacity(0.25), radius: 10, x: 0, y: 4)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tu enchaînes depuis \(state.user.streak) jours")
                            .font(MxFont.body(14, weight: .bold))
                            .foregroundStyle(Mx.ink)
                        Text("Plus que \(state.user.nextPerkPts) pts avant un snack offert")
                            .font(MxFont.body(12))
                            .foregroundStyle(Mx.ink2)
                    }
                    Spacer()
                    MxIcon(name: .chevron, size: 18, color: Mx.mute)
                }
                .padding(.horizontal, 18).padding(.vertical, 14)
                .background(LinearGradient(colors: [Mx.paper, Mx.paper2],
                                           startPoint: .top, endPoint: .bottom))
            }
            .buttonStyle(.plain)
            .mxPress()
            .overlay(Rectangle().fill(Mx.line2).frame(height: 1), alignment: .top)
        }
        .background(Mx.card)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Mx.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 18, x: 0, y: 6)
    }

    private func statCard(title: String, value: String, sub: String) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(MxFont.head(10))
                .tracking(1.4)
                .foregroundStyle(Mx.mute)
            Text(value)
                .font(MxFont.body(16, weight: .bold))
                .foregroundStyle(Mx.ink)
            Text(sub)
                .font(MxFont.body(10))
                .foregroundStyle(Mx.mute)
        }
        .padding(.vertical, 10).padding(.horizontal, 8)
        .frame(maxWidth: .infinity)
        .background(Mx.card)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Mx.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var activitiesList: some View {
        VStack(spacing: 0) {
            row(icon: .history, label: "Historique d'achats", sub: "\(state.purchases.count) achats", first: true) {
                state.overlay = .history
            }
            row(icon: .vote, label: "Mes votes",
                sub: "\(state.votes.filter { $0.voted }.count) actifs") { state.overlay = .vote }
            row(icon: .ticket, label: "Mes signalements",
                sub: "\(state.pastTickets.filter { $0.color == .warn }.count) en cours") { state.overlay = .ticket }
            row(icon: .trophy, label: "Mon club Maxx",
                sub: "\(state.user.tier.label) · \(state.user.streak)j de streak") { state.overlay = .loyalty }
        }
        .background(Mx.card)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Mx.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var preferencesList: some View {
        VStack(spacing: 0) {
            row(icon: .bell, label: "Notifications", sub: "Restock, nouveautés, streak", first: true) {
                state.overlay = .notifs
            }
            row(icon: .leaf, label: "Préférences alimentaires", sub: "Sans gluten, végan…") { }
            row(icon: .credit, label: "Moyens de paiement", sub: "Apple Pay · Visa •• 4242") { }
            row(icon: .lang, label: "Langue", sub: "Français") { }
            row(icon: .info, label: "À propos", sub: "Version 1.0.0") { }
        }
        .background(Mx.card)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Mx.line, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func row(icon: MxIconName, label: String, sub: String,
                     first: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Mx.orange.opacity(0.10))
                    MxIcon(name: icon, size: 18, color: Mx.orange)
                }
                .frame(width: 36, height: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(MxFont.body(14, weight: .semibold))
                        .foregroundStyle(Mx.ink)
                    Text(sub)
                        .font(MxFont.body(12))
                        .foregroundStyle(Mx.mute)
                }
                Spacer()
                MxIcon(name: .chevron, size: 16, color: Mx.mute)
            }
            .padding(.horizontal, 14).padding(.vertical, 12)
            .background(Color.clear)
            .overlay(alignment: .top) {
                if !first { Rectangle().fill(Mx.line2).frame(height: 1) }
            }
        }
        .buttonStyle(.plain)
        .mxPress()
    }
}
