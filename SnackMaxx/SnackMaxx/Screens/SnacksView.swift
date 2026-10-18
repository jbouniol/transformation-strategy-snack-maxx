import SwiftUI

struct SnacksView: View {
    @EnvironmentObject var state: AppState
    @State private var category: SnackCategory = .all
    @State private var query: String = ""

    private var items: [Product] {
        state.products.filter { p in
            (category == .all || p.category == category) &&
            (query.isEmpty || (p.name + " " + p.flavor).localizedCaseInsensitiveContains(query))
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    // Logo
                    Image("LogoSnackMaxx")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 28)
                        .padding(.bottom, 6)

                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(state.machine.shortName.uppercased())
                                .font(MxFont.head(10))
                                .tracking(1.6)
                                .foregroundStyle(Mx.orange)
                            MaxxHead(text: "Snacks dispo", size: 30)
                        }
                        Spacer()
                        MxPill("\(items.count) réfs")
                    }
                    HStack(spacing: 10) {
                        MxIcon(name: .search, size: 18, color: Mx.mute)
                        TextField("Rechercher un snack…", text: $query)
                            .font(MxFont.body(14))
                            .foregroundStyle(Mx.ink)
                        MxIcon(name: .sliders, size: 16, color: Mx.ink2)
                    }
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(Mx.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Mx.line, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.horizontal, 18)
                .padding(.top, 60)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(SnackCategory.allCases) { c in
                            Chip(label: c.label, isActive: c == category) { category = c }
                        }
                    }
                    .padding(.horizontal, 18)
                }
                .padding(.top, 12)

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12),
                                    GridItem(.flexible(), spacing: 12)],
                          spacing: 12) {
                    ForEach(items) { p in
                        ProductCard(product: p) {
                            state.selectedProduct = p
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .padding(.bottom, 20)

                if items.isEmpty {
                    VStack(spacing: 4) {
                        Text("Pas de résultat")
                            .font(MxFont.body(16, weight: .bold))
                            .foregroundStyle(Mx.ink)
                        Text("Essaie un autre mot ou une autre catégorie.")
                            .font(MxFont.body(12))
                            .foregroundStyle(Mx.mute)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                }
            }
        }
    }
}
