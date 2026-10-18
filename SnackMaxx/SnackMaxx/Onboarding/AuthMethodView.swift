import SwiftUI

struct AuthMethodView: View {
    let onContinue: () -> Void
    @State private var authenticating = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("CRÉER MON COMPTE")
                    .font(MxFont.head(11))
                    .tracking(1.8)
                    .foregroundStyle(Mx.orange)
                MaxxHead(text: "On commence par toi.", size: 34)
                Text("Ton compte sert à débloquer le paiement express, le vote, le streak.")
                    .font(MxFont.body(14))
                    .foregroundStyle(Mx.ink2)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 80)

            Spacer()

            VStack(spacing: 12) {
                appleButton
                MaxxButton("Continuer avec Google", variant: .cream, size: .lg, full: true,
                           action: { startAuth() }) {
                    MxIcon(name: .google, size: 20)
                }
                MaxxButton("S'inscrire avec un email", variant: .ghost, size: .lg, full: true,
                           action: { startAuth() }) {
                    MxIcon(name: .info, size: 18, color: Mx.ink)
                }
            }
            .padding(.horizontal, 24)

            HStack(spacing: 6) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Mx.mute)
                Text("Inscription anonymisée pour la démo")
                    .font(MxFont.body(11))
                    .foregroundStyle(Mx.mute)
            }
            .padding(.top, 22)
            .padding(.bottom, 32)
        }
        .overlay(alignment: .center) {
            if authenticating {
                AuthOverlay()
            }
        }
    }

    private var appleButton: some View {
        Button {
            startAuth()
        } label: {
            HStack(spacing: 8) {
                MxIcon(name: .apple, size: 20, color: .white)
                Text("Continuer avec Apple")
                    .font(MxFont.body(15, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Mx.ink)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.22), radius: 18, x: 0, y: 8)
        }
        .buttonStyle(.plain)
        .mxPress()
    }

    private func startAuth() {
        authenticating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            authenticating = false
            onContinue()
        }
    }
}

private struct AuthOverlay: View {
    @State private var pulse = false
    var body: some View {
        ZStack {
            Mx.paper.opacity(0.92).ignoresSafeArea()
            VStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Mx.ink)
                    MxIcon(name: .face, size: 50, color: .white, weight: .light)
                }
                .frame(width: 96, height: 96)
                .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 6)
                .scaleEffect(pulse ? 1.05 : 0.95)
                .animation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: pulse)
                MaxxHead(text: "Regarde l'iPhone", size: 22)
                Text("Authentification Face ID…")
                    .font(MxFont.body(14))
                    .foregroundStyle(Mx.mute)
            }
            .onAppear { pulse = true }
        }
    }
}
