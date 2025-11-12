import SwiftUI
import MapKit

struct HomeView: View {
    @State private var selectedTab: RootTab = .home
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -23.56, longitude: -46.68),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    )
    @State private var selectedMerchant: Merchant?
    @State private var showingAddMerchant = false

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
            } else if selectedTab == .profile {
                ProfileView()
            }
        }
        .safeAreaInset(edge: .top) {
            if selectedTab == .home {
                TopBar(
                    onCartTapped: { print("Cart tapped") },
                    onPlusTapped: { showingAddMerchant = true }
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
        .sheet(isPresented: $showingAddMerchant) {
            // Recarregar merchants quando o sheet for fechado
            viewModel.loadNearby()
        } content: {
            AddMerchantView()
        }
        .onChange(of: viewModel.merchants, initial: false) { oldValue, newValue in
            // Se há novos merchants, centralizar no mais recente
            if let newestMerchant = newValue.sorted(by: { 
                ($0.createdAt ?? Date.distantPast) > ($1.createdAt ?? Date.distantPast)
            }).first(where: { $0.hasValidCoordinates }) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    region.center = newestMerchant.coordinate
                    // Dar zoom um pouco mais próximo para destacar
                    region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                }
                
                // Após 2 segundos, voltar ao zoom normal
                Task {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    withAnimation(.easeInOut(duration: 0.5)) {
                        region.span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                    }
                }
            }
        }
    }
}

