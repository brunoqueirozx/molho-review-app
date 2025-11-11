import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            // Background preto
            Color.black
                .ignoresSafeArea()
            
            // Logo do Molho
            Image("molho-logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
    }
}

#Preview {
    SplashView()
}

