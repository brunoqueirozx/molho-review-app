import SwiftUI
import MapKit

struct MapContainerView: View {
    @Binding var region: MKCoordinateRegion
    var merchants: [Merchant]
    var onMerchantSelected: (Merchant) -> Void

    var body: some View {
        if #available(iOS 17.0, *) {
            ModernMapView(
                region: $region,
                merchants: merchants,
                onMerchantSelected: onMerchantSelected
            )
            .ignoresSafeArea(edges: .bottom)
        } else {
            Map(
                coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: false,
                annotationItems: merchants.filter { $0.hasValidCoordinates }
            ) { merchant in
                MapAnnotation(coordinate: merchant.coordinate, anchorPoint: CGPoint(x: 0.5, y: 1)) {
                    Button {
                        onMerchantSelected(merchant)
                    } label: {
                        MerchantPinView(merchant: merchant)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Selecionar \(merchant.name)")
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

@available(iOS 17.0, *)
private struct ModernMapView: View {
    @Binding var region: MKCoordinateRegion
    var merchants: [Merchant]
    var onMerchantSelected: (Merchant) -> Void

    var body: some View {
        Map(
            position: Binding(
                get: { MapCameraPosition.region(region) },
                set: { newValue in
                    if let newRegion = newValue.region {
                        region = newRegion
                    }
                }
            ),
            interactionModes: .all
        ) {
            ForEach(merchants.filter { $0.hasValidCoordinates }) { merchant in
                Annotation("", coordinate: merchant.coordinate, anchor: .bottom) {
                    Button {
                        onMerchantSelected(merchant)
                    } label: {
                        MerchantPinView(merchant: merchant)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Selecionar \(merchant.name)")
                }
            }
        }
    }
}
