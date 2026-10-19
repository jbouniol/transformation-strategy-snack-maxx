import SwiftUI

struct ScanView: View {
    @EnvironmentObject var state: AppState
    @State private var scan = false
    @State private var done = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.96).ignoresSafeArea()
                .background(.ultraThinMaterial.opacity(0.4))
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SCANNER UN DISTRIBUTEUR")
                            .font(MxFont.head(11))
                            .tracking(1.8)
                            .foregroundStyle(.white.opacity(0.6))
                        Text("Vise le QR du distributeur")
                            .font(MxFont.body(20, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    Button {
                        state.scanOpen = false
                    } label: {
                        ZStack {
                            Circle().fill(.white.opacity(0.06))
                            MxIcon(name: .close, size: 20, color: .white)
                        }
                        .frame(width: 40, height: 40)
                        .overlay(Circle().stroke(.white.opacity(0.15), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 18).padding(.top, 60)
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.white.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(.white.opacity(0.08), lineWidth: 1)
                        )
                    // corners
                    GeometryReader { geo in
                        let s = geo.size
                        ForEach(Corner.allCases, id: \.self) { c in
                            CornerBracket()
                                .stroke(Mx.orangeHot, style: .init(lineWidth: 3, lineCap: .round))
                                .frame(width: 32, height: 32)
                                .rotationEffect(c.rotation)
                                .position(c.position(in: s))
                        }
                    }
                    // scan line
                    GeometryReader { geo in
                        Rectangle()
                            .fill(LinearGradient(colors: [.clear, Mx.orangeHot, .clear],
                                                 startPoint: .leading, endPoint: .trailing))
                            .frame(height: 2)
                            .shadow(color: Mx.orangeHot.opacity(0.8), radius: 8, y: 0)
                            .padding(.horizontal, 24)
                            .offset(y: scan ? geo.size.height - 30 : 30)
                            .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: scan)
                    }
                }
                .frame(width: 280, height: 280)
                .onAppear {
                    scan = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                        completeScan()
                    }
                }

                Text("Approche-toi de la vitre du distributeur. On t'amène direct sur le bon catalogue.")
                    .font(MxFont.body(13))
                    .foregroundStyle(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32).padding(.top, 24)

                HStack(spacing: 8) {
                    MxPill("Torche", kind: .ghost, icon: "flame")
                        .foregroundStyle(.white)
                    MxPill("Saisir le code", kind: .ghost, icon: "number")
                        .foregroundStyle(.white)
                }
                .padding(.top, 18)
                .opacity(0.85)

                Spacer()
                MaxxButton("Simuler la validation", variant: .primary, size: .lg, full: true,
                           action: { completeScan() }) {
                    MxIcon(name: .check, size: 18, color: .white)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 60)
            }
        }
        .overlay(alignment: .center) {
            if done {
                successOverlay
                    .transition(.opacity)
            }
        }
    }

    private func completeScan() {
        guard !done else { return }
        withAnimation(.easeInOut(duration: 0.2)) { done = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            if !state.machine.open {
                if let nextOpen = MockData.machines.first(where: { $0.open }) {
                    state.machine = nextOpen
                }
            }
            state.switchTo(.snacks)
            state.scanOpen = false
        }
    }

    @ViewBuilder private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.85)
            VStack(spacing: 14) {
                ZStack {
                    Circle().fill(Mx.okBg)
                    MxIcon(name: .check, size: 50, color: Mx.okFg)
                }
                .frame(width: 96, height: 96)
                MaxxHead(text: "Distributeur reconnu", size: 22, color: .white)
                Text(state.machine.name)
                    .font(MxFont.body(14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
        .ignoresSafeArea()
    }
}

private enum Corner: CaseIterable {
    case tl, tr, bl, br
    var rotation: Angle {
        switch self {
        case .tl: return .degrees(0)
        case .tr: return .degrees(90)
        case .br: return .degrees(180)
        case .bl: return .degrees(270)
        }
    }
    func position(in s: CGSize) -> CGPoint {
        let inset: CGFloat = 28
        switch self {
        case .tl: return CGPoint(x: inset, y: inset)
        case .tr: return CGPoint(x: s.width - inset, y: inset)
        case .br: return CGPoint(x: s.width - inset, y: s.height - inset)
        case .bl: return CGPoint(x: inset, y: s.height - inset)
        }
    }
}

private struct CornerBracket: Shape {
    func path(in r: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: r.minX, y: r.midY))
        p.addLine(to: CGPoint(x: r.minX, y: r.minY + 6))
        p.addQuadCurve(to: CGPoint(x: r.minX + 6, y: r.minY),
                       control: CGPoint(x: r.minX, y: r.minY))
        p.addLine(to: CGPoint(x: r.midX, y: r.minY))
        return p
    }
}
