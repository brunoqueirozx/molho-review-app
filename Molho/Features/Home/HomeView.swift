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
            if let merchant = viewModel.merchants.first {
                MerchantSheetView(merchant: merchant)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}


