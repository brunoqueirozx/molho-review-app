import SwiftUI
import MapKit

struct HomeView: View {
    @State private var selectedTab: RootTab = .home
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -23.56, longitude: -46.68),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    )
    @State private var selectedMerchant: Merchant?

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            if selectedTab == .home {
                MapContainerView(
                    region: $region,
                    merchants: viewModel.merchants
                ) { merchant in
                    selectedMerchant = merchant
                    if merchant.hasValidCoordinates {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            region.center = merchant.coordinate
                        }
                    }
                }
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
        .sheet(item: $selectedMerchant) { merchant in
            MerchantSheetView(merchant: merchant)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: viewModel.merchants, initial: false) { oldValue, newValue in
            guard let firstMerchant = newValue.first(where: { $0.hasValidCoordinates }) else { return }
            withAnimation(.easeInOut(duration: 0.3)) {
                region.center = firstMerchant.coordinate
            }
        }
    }
}

