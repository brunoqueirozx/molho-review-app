import SwiftUI
import MapKit

struct HomeView: View {
    @State private var selectedTab: RootTab = .home
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -23.56, longitude: -46.68),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    )
    @State private var showMerchantSheet: Bool = false

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            if selectedTab == .home {
                MapContainerView(region: $region)
            } else if selectedTab == .search {
                SearchView()
            } else {
                VStack { Spacer() }
                    .background(Color(.systemGroupedBackground))
            }
        }
        .safeAreaInset(edge: .top) {
            if selectedTab == .home {
                TopBar(
                    onCartTapped: { print("Cart tapped") },
                    onPlusTapped: { print("Plus tapped") }
                )
            }
        }
        .safeAreaInset(edge: .bottom) {
            BottomBar(selected: selectedTab) { tab in
                selectedTab = tab
            }
        }
        .sheet(isPresented: $showMerchantSheet) {
            MerchantSheetView(
                merchant: viewModel.merchants.first ?? Merchant(
                    id: "debug",
                    name: "Guarita Bar",
                    category: "Bar de drink",
                    style: "Casual",
                    rating: 3.6,
                    reviewsCount: 3.2,
                    viewsCount: 380,
                    bookmarksCount: 350,
                    description: "Bar aconchegante com drinks clássicos e autorais, petiscos e luz baixa. Perfeito para encontros e happy hour.",
                    latitude: -23.56,
                    longitude: -46.68,
                    address: "R. Simão Álvares, 952 - Pinheiros, São Paulo - SP, 05417-020",
                    openingHours: "Fecha 23:00",
                    isOpen: true,
                    imageUrl: nil,
                    galleryImages: nil
                )
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}


