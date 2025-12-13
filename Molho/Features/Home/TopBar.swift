import SwiftUI

struct TopBar: View {
    var onCartTapped: () -> Void
    var onPlusTapped: () -> Void

    var body: some View {
        HStack {
            Image("molho-logo")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(height: 28)

            Spacer()

            HStack(spacing: Theme.spacing16) {
                Button(action: onCartTapped) {
                    Image(systemName: "cart")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
                .accessibilityLabel("Abrir carrinho")

                Button(action: onPlusTapped) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
                .accessibilityLabel("Adicionar item")
            }
        }
        .padding(.horizontal, Theme.spacing16)
        .padding(.top, Theme.spacing12)
        .padding(.bottom, Theme.spacing12)
        .background(.white)
    }
}


