import Foundation
import Combine

final class MerchantViewModel: ObservableObject {
    @Published var merchant: Merchant

    init(merchant: Merchant) {
        self.merchant = merchant
    }

    // TODO: Métodos futuros para buscar detalhes no Firestore
}



