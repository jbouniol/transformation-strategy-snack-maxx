import SwiftUI

struct VoteView: View {
    @EnvironmentObject var state: AppState
    @State private var tab: Tab = .active
    @State private var suggestOpen = false
    @State private var suggest = ""

    enum Tab { case active, fulfilled }

    private var sorted: [VoteRequest] {
        state.votes.sorted { $0.votes > $1.votes }
    }

    var body: some View {
        OverlayChrome(title: "Tu décides", onClose: { state.overlay = nil }) {
            VStack(spacing: 0) {
                hero
                    .padding(.horizontal, 18)

                HStack(spacing: 8) {
                    tabButton("Demandes (\(state.votes.count))", isActive: tab == .active) { tab = .active }
                    tabButton("Déjà ajoutés (\(MockData.votesFulfilled.count))",
                              isActive: tab == .fulfilled) { tab = .fulfilled }
                }
                .padding(.horizontal, 18).padding(.top, 14).padding(.bottom, 8)

                if tab == .active {
                    activeList
                } else {
                    fulfilledList
                }
            }
        }
    }

    private var hero: some View {
        ZStack {
            Mx.blueGradient
            Canvas { ctx, size in
                var p = Path()
                p.move(to: CGPoint(x: -40, y: size.height * 0.6))
                p.addQuadCurve(to: CGPoint(x: size.width + 40, y: size.height * 0.5),
                               control: CGPoint(x: size.width / 2, y: size.height * 0.15))
                ctx.stroke(p, with: .color(.white.opacity(0.4)), style: .init(lineWidth: 6, lineCap: .round))
            }
            .opacity(0.6)
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    MxIcon(name: .pin, size: 11, color: .white)
                    Text(state.machine.shortName.uppercased())
                        .font(MxFont.body(11, weight: .bold))
                        .tracking(0.8)
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 4).padding(.horizontal, 10)
                .background(.white.opacity(0.18))
                .clipShape(Capsule())
                MaxxHead(text: "Quel snack veux-tu voir ici ?", size: 24, color: .white)
                Text("Vote pour ce que tu veux dans ce distributeur. Le top 3 du mois rentre direct dans la sélection.")
                    .font(MxFont.body(13))
                    .foregroundStyle(.white.opacity(0.85))
                    .lineSpacing(2)
            }
            .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Mx.blueDeep.opacity(0.3), radius: 24, x: 0, y: 12)
    }

    private func tabButton(_ label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(MxFont.body(13, weight: .bold))
                .foregroundStyle(isActive ? .white : Mx.ink2)
                .padding(.horizontal, 12).padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(isActive ? Mx.ink : Mx.card)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .mxPress()
    }

    private var activeList: some View {
        VStack(spacing: 10) {
            ForEach(Array(sorted.enumerated()), id: \.element.id) { (i, v) in
                voteRow(v: v, rank: i + 1)
            }
            suggestCard
            Text("Tes votes sont anonymes. Vote x2 si tu es Gold.")
                .font(MxFont.body(11))
                .foregroundStyle(Mx.mute)
                .multilineTextAlignment(.center)
                .padding(.top, 4).padding(.bottom, 100)
        }
        .padding(.horizontal, 18)
    }

    private func voteRow(v: VoteRequest, rank: Int) -> some View {
        HStack(spacing: 12) {
            Text("\(rank)")
                .font(MxFont.body(12, weight: .heavy))
                .foregroundStyle(rank <= 3 ? .white : Mx.ink2)
                .frame(width: 28, height: 28)
                .background(rank <= 3 ? Mx.ink : Mx.paper2)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(v.name)
                    .font(MxFont.body(14, weight: .bold))
                    .foregroundStyle(Mx.ink)
                Text(v.brand)
                    .font(MxFont.body(11))
                    .foregroundStyle(Mx.mute)
                  + Text(" · ").font(MxFont.body(11)).foregroundColor(Mx.mute)
                  + Text("\(v.trend) cette semaine").font(MxFont.body(11, weight: .bold))
                    .foregroundColor(Mx.okFg)
            }
            Spacer()
            Button { state.toggleVote(id: v.id) } label: {
                HStack(spacing: 4) {
                    if v.voted {
                        MxIcon(name: .check, size: 13, color: .white)
                    } else {
                        MxIcon(name: .plus, size: 13, color: Mx.ink)
                    }
                    Text("\(v.votes)")
                        .font(MxFont.body(13, weight: .bold))
                        .foregroundStyle(v.voted ? .white : Mx.ink)
                }
                .padding(.horizontal, 14).padding(.vertical, 8)
                .frame(minWidth: 64)
                .background(v.voted ? Mx.orange : Mx.card)
                .overlay(
                    Capsule().stroke(v.voted ? Color.clear : Mx.line, lineWidth: 1)
                )
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .mxPress()
        }
        .padding(14)
        .background(Mx.card)
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(v.voted ? Mx.orange : Mx.line, lineWidth: v.voted ? 1.5 : 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 14, x: 0, y: 4)
    }

    private var suggestCard: some View {
        Group {
            if suggestOpen {
                VStack(alignment: .leading, spacing: 8) {
                    Text("NOUVEAU SNACK")
                        .font(MxFont.head(10))
                        .tracking(1.6)
                        .foregroundStyle(Mx.orange)
                    TextField("Ex: KitKat Cookies & Cream", text: $suggest)
                        .font(MxFont.body(14))
                        .padding(12)
                        .background(Mx.paper2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Mx.line, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    HStack(spacing: 8) {
                        Button {
                            suggestOpen = false; suggest = ""
                        } label: {
                            Text("Annuler")
                                .font(MxFont.body(13, weight: .semibold))
                                .foregroundStyle(Mx.ink)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Mx.line, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                        Button {
                            if !suggest.isEmpty {
                                let newVote = VoteRequest(id: UUID().uuidString, title: suggest, desc: "Suggéré par \(state.user.firstName)", votes: 1, voted: true, category: "Nouveau")
                                state.votes.append(newVote)
                            }
                            suggestOpen = false; suggest = ""
                        } label: {
                            Text("Soumettre")
                                .font(MxFont.body(13, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(Mx.orange)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .mxPress()
                    }
                }
                .padding(14)
                .background(Mx.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Mx.line, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            } else {
                Button { suggestOpen = true } label: {
                    HStack(spacing: 6) {
                        MxIcon(name: .plus, size: 14, color: Mx.ink2)
                        Text("Suggérer un nouveau snack")
                            .font(MxFont.body(13, weight: .semibold))
                            .foregroundStyle(Mx.ink2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(style: .init(lineWidth: 1.5, dash: [5, 4]))
                            .foregroundStyle(Mx.line)
                    )
                }
                .buttonStyle(.plain)
                .mxPress()
                .padding(14)
                .background(Mx.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Mx.line, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }

    private var fulfilledList: some View {
        VStack(spacing: 10) {
            ForEach(MockData.votesFulfilled) { f in
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Mx.okFg.opacity(0.12))
                        MxIcon(name: .check, size: 20, color: Mx.okFg)
                    }
                    .frame(width: 40, height: 40)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(f.name)
                            .font(MxFont.body(14, weight: .bold))
                            .foregroundStyle(Mx.ink)
                        Text("Ajouté \(f.date) · \(f.machine)")
                            .font(MxFont.body(12))
                            .foregroundStyle(Mx.mute)
                    }
                    Spacer()
                    MxPill("En rayon", kind: .ok)
                }
                .padding(14)
                .mxCard()
            }
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 130)
    }
}
