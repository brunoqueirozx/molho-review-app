import SwiftUI
import MapKit

struct MapContainerView: View {
    @Binding var region: MKCoordinateRegion

    var body: some View {
        Map(position: .constant(.region(region)))
            .ignoresSafeArea(edges: .bottom)
    }
}


