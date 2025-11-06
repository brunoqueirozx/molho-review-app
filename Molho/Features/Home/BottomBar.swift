import SwiftUI

enum RootTab: String {
    case home
    case search
    case profile
}

struct BottomBar: View {
    var selected: RootTab
    var onSelect: (RootTab) -> Void

    private func iconWeight(for tab: RootTab) -> Font.Weight {
        return selected == tab ? .semibold : .regular
    }

    var body: some View {
        HStack {
            Spacer()
            Button(action: { onSelect(.home) }) {
                Image(systemName: "map")
                    .font(.title2.weight(iconWeight(for: .home)))
                    .foregroundStyle(.black)
            }
            .accessibilityLabel("Aba Mapa")

            Spacer()
            Button(action: { onSelect(.search) }) {
                Image(systemName: "magnifyingglass")
                    .font(.title2.weight(iconWeight(for: .search)))
                    .foregroundStyle(.black)
            }
            .accessibilityLabel("Aba Busca")

            Spacer()
            Button(action: { onSelect(.profile) }) {
                Image(systemName: "person")
                    .font(.title2.weight(iconWeight(for: .profile)))
                    .foregroundStyle(.black)
            }
            .accessibilityLabel("Aba Perfil")
            Spacer()
        }
        .padding(.vertical, Theme.spacing12)
        .background(.white)
    }
}


