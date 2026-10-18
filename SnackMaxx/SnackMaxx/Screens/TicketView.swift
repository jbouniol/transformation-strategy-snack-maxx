import SwiftUI

struct TicketView: View {
    @EnvironmentObject var state: AppState

    enum Step { case type, detail, success }
    @State private var step: Step = .type
    @State private var selectedType: TicketType? = nil
    @State private var notes: String = ""
    @State private var refund: Bool = true

    var body: some View {
        OverlayChrome(title: "Signaler un problème", onClose: { state.overlay = nil }) {
            switch step {
            case .type: typeStep
            case .detail: detailStep
            case .success: successStep
            }
        }
    }

    private var typeStep: some View {
        VStack(spacing: 0) {
            // machine context
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Mx.orange.opacity(0.10))
                    MxIcon(name: .pin, size: 18, color: Mx.orange)
                }
                .frame(width: 36, height: 36)
                VStack(alignment: .leading, spacing: 2) {
                    Text(state.machine.name)
                        .font(MxFont.body(13, weight: .bold))
                        .foregroundStyle(Mx.ink)
                    Text("Détecté automatiquement")
                        .font(MxFont.body(11))
                        .foregroundStyle(Mx.mute)
                }
                Spacer()
                Button {} label: {
                    Text("Changer")
                        .font(MxFont.body(12, weight: .bold))
                        .foregroundStyle(Mx.orange)
                }
                .buttonStyle(.plain)
            }
            .padding(14)
            .mxCard()
            .padding(.horizontal, 18)

            SectionHeader(title: "Quel est le problème ?")
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10),
                                GridItem(.flexible(), spacing: 10)],
                      spacing: 10) {
                ForEach(MockData.ticketTypes) { t in
                    Button {
                        selectedType = t
                        step = .detail
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Mx.red.opacity(0.10))
                                MxIcon(name: iconFor(t.icon), size: 18, color: Mx.red)
                            }
                            .frame(width: 36, height: 36)
                            Text(t.label)
                                .font(MxFont.body(12, weight: .semibold))
                                .foregroundStyle(Mx.ink)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(14)
                        .background(Mx.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Mx.line, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .mxPress()
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 4)

            SectionHeader(title: "Mes signalements")
            VStack(spacing: 8) {
                ForEach(MockData.pastTickets) { t in
                    HStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(t.color == .ok ? Mx.okFg.opacity(0.12) : Mx.warnFg.opacity(0.18))
                            MxIcon(name: t.color == .ok ? .check : .clock, size: 18,
                                   color: t.color == .ok ? Mx.okFg : Mx.warnFg)
                        }
                        .frame(width: 36, height: 36)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(t.type)
                                .font(MxFont.body(13, weight: .bold))
                                .foregroundStyle(Mx.ink)
                            Text("\(t.date) · \(t.machine)")
                                .font(MxFont.body(11))
                                .foregroundStyle(Mx.mute)
                        }
                        Spacer()
                        MxPill(t.status, kind: t.color == .ok ? .ok : .warn)
                    }
                    .padding(12)
                    .mxCard()
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 130)
        }
    }

    private var detailStep: some View {
        VStack(spacing: 0) {
            if let t = selectedType {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Mx.red.opacity(0.10))
                        MxIcon(name: iconFor(t.icon), size: 20, color: Mx.red)
                    }
                    .frame(width: 40, height: 40)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(t.label)
                            .font(MxFont.body(14, weight: .bold))
                            .foregroundStyle(Mx.ink)
                        Text(state.machine.name)
                            .font(MxFont.body(11))
                            .foregroundStyle(Mx.mute)
                    }
                    Spacer()
                }
                .padding(14)
                .mxCard()
                .padding(.horizontal, 18)
            }

            SectionHeader(title: "Détails (optionnel)")
            VStack(spacing: 10) {
                TextField("", text: $notes, prompt: Text("Décris ce qui s'est passé en quelques mots…")
                            .foregroundColor(Mx.mute), axis: .vertical)
                    .lineLimit(4...8)
                    .font(MxFont.body(14))
                    .padding(14)
                    .background(Mx.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Mx.line, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                Button {} label: {
                    HStack(spacing: 6) {
                        MxIcon(name: .camera, size: 16, color: Mx.ink2)
                        Text("Ajouter une photo")
                            .font(MxFont.body(13, weight: .semibold))
                            .foregroundStyle(Mx.ink2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(style: .init(lineWidth: 1, dash: [4, 4]))
                            .foregroundStyle(Mx.line)
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)

            SectionHeader(title: "Demander un remboursement")
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Remboursement automatique")
                        .font(MxFont.body(13, weight: .bold))
                        .foregroundStyle(Mx.ink)
                    Text("Sur ton moyen de paiement (Apple Pay)")
                        .font(MxFont.body(11))
                        .foregroundStyle(Mx.mute)
                }
                Spacer()
                Toggle("", isOn: $refund)
                    .toggleStyle(SwitchToggleStyle(tint: Mx.orange))
                    .labelsHidden()
            }
            .padding(.horizontal, 14).padding(.vertical, 12)
            .mxCard()
            .padding(.horizontal, 18)

            MaxxButton("Envoyer le signalement", variant: .primary, size: .lg, full: true,
                       action: {
                           let title = selectedType?.label ?? "Signalement"
                           let newTicket = PastTicket(id: UUID().uuidString, title: title, desc: notes.isEmpty ? "Pas de détails" : notes, date: Date(), status: "EN COURS", color: .warn)
                           state.pastTickets.insert(newTicket, at: 0)
                           step = .success
                       }) {
                MxIcon(name: .check, size: 20, color: .white)
            }
            .padding(.horizontal, 18)
            .padding(.top, 20)
            .padding(.bottom, 130)
        }
    }

    private var successStep: some View {
        VStack(spacing: 14) {
            Spacer(minLength: 30)
            ZStack {
                Circle().fill(Mx.okBg)
                MxIcon(name: .check, size: 48, color: Mx.okFg)
            }
            .frame(width: 96, height: 96)
            MaxxHead(text: "Signalement envoyé", size: 28)
            Text("On regarde ça tout de suite. Tu seras notifié dès que l'équipe répond.")
                .font(MxFont.body(14))
                .foregroundStyle(Mx.ink2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            if refund {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Mx.okFg.opacity(0.12))
                        MxIcon(name: .credit, size: 18, color: Mx.okFg)
                    }
                    .frame(width: 36, height: 36)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Remboursement demandé")
                            .font(MxFont.body(13, weight: .bold))
                            .foregroundStyle(Mx.ink)
                        Text("Sous 48h après vérification")
                            .font(MxFont.body(11))
                            .foregroundStyle(Mx.mute)
                    }
                    Spacer()
                }
                .padding(14)
                .mxCard()
                .padding(.horizontal, 18)
                .padding(.top, 6)
            }
            Spacer(minLength: 10)
            MaxxButton("Fermer", variant: .dark, size: .md, full: true, action: { state.overlay = nil })
                .padding(.horizontal, 18).padding(.bottom, 130)
        }
        .frame(maxWidth: .infinity)
    }

    private func iconFor(_ name: String) -> MxIconName {
        switch name {
        case "alert": return .alert
        case "package": return .package
        case "shuffle": return .shuffle
        case "clock": return .clock
        case "credit": return .credit
        case "info": return .info
        default: return .info
        }
    }
}
