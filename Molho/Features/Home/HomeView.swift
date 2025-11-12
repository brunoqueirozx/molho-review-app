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
    @State private var hasInitializedLocation = false

    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack {
            if selectedTab == .home {
                MapContainerView(
                    region: $region,
                    merchants: viewModel.merchants,
                    userLocation: locationManager.userLocation
                ) { merchant in
                    selectedMerchant = merchant
                    if merchant.hasValidCoordinates {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            region.center = merchant.coordinate
                        }
                    }
                }
                .ignoresSafeArea()
                
                // Botão flutuante para centralizar na localização do usuário
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            centerOnUserLocation()
                        } label: {
                            Image(systemName: "location.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.black)
                                .frame(width: 48, height: 48)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
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
        .onChange(of: locationManager.userLocation, initial: true) { oldValue, newValue in
            // Quando obter a localização pela primeira vez, centralizar o mapa
            if !hasInitializedLocation, let location = newValue {
                hasInitializedLocation = true
                withAnimation(.easeInOut(duration: 0.5)) {
                    region.center = location.coordinate
                }
            }
        }
        .onChange(of: locationManager.authorizationStatus, initial: true) { oldValue, newValue in
            // Solicitar localização quando o status mudar para não determinado
            if newValue == .notDetermined {
                locationManager.requestPermission()
            }
        }
        .onAppear {
            // Solicitar permissão ao aparecer
            if locationManager.authorizationStatus == .notDetermined {
                locationManager.requestPermission()
            } else if locationManager.authorizationStatus == .authorizedWhenInUse || 
                      locationManager.authorizationStatus == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: - Helper Methods
    
    private func centerOnUserLocation() {
        guard let location = locationManager.userLocation else {
            // Se não tiver localização, solicitar permissão
            if locationManager.authorizationStatus == .notDetermined {
                locationManager.requestPermission()
            }
            return
        }
        
        withAnimation(.easeInOut(duration: 0.5)) {
            region.center = location.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        }
        
        // Após 1 segundo, voltar ao zoom normal
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation(.easeInOut(duration: 0.5)) {
                region.span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            }
        }
    }
}

