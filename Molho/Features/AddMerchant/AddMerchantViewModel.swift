import Foundation
import SwiftUI
import CoreLocation
import PhotosUI
import Combine

enum MerchantType: String, CaseIterable, Identifiable {
    case bar = "Bar"
    case restaurant = "Restaurante"
    case cafe = "Café"
    case bakery = "Padaria"
    case pizzeria = "Pizzaria"
    case fastFood = "Fast Food"
    case foodTruck = "Food Truck"
    case pub = "Pub"
    case bistro = "Bistrô"
    case winery = "Vinícola"
    
    var id: String { rawValue }
}

enum MerchantStyle: String, CaseIterable, Identifiable {
    case calm = "Calmo"
    case romantic = "Romântico"
    case elegant = "Elegante"
    case casual = "Casual"
    case modern = "Moderno"
    case rustic = "Rústico"
    case tropical = "Tropical"
    case industrial = "Industrial"
    case cozy = "Aconchegante"
    case sophisticated = "Sofisticado"
    
    var id: String { rawValue }
}

enum Weekday: String, CaseIterable, Identifiable {
    case monday = "Segunda"
    case tuesday = "Terça"
    case wednesday = "Quarta"
    case thursday = "Quinta"
    case friday = "Sexta"
    case saturday = "Sábado"
    case sunday = "Domingo"
    
    var id: String { rawValue }
}

struct DaySchedule: Identifiable {
    let id = UUID()
    let weekday: Weekday
    var isClosed: Bool = false
    var openTime: Date = Calendar.current.date(from: DateComponents(hour: 11, minute: 0))!
    var closeTime: Date = Calendar.current.date(from: DateComponents(hour: 22, minute: 0))!
}

@MainActor
final class AddMerchantViewModel: ObservableObject {
    // Campos básicos
    @Published var name: String = ""
    @Published var selectedType: MerchantType = .restaurant
    @Published var selectedStyle: MerchantStyle = .casual
    @Published var description: String = ""
    @Published var address: String = ""
    @Published var rating: Double = 3.0
    
    // Coordenadas (calculadas a partir do endereço)
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var isGeocodingAddress: Bool = false
    @Published var geocodingError: String?
    
    // Localização atual
    @Published var isGettingLocation: Bool = false
    @Published var locationError: String?
    
    // Horários de funcionamento
    @Published var schedules: [DaySchedule] = Weekday.allCases.map { DaySchedule(weekday: $0) }
    
    // Imagens
    @Published var headerImage: UIImage?
    @Published var galleryImages: [UIImage] = []
    @Published var showingHeaderImagePicker = false
    @Published var showingGalleryImagePicker = false
    @Published var selectedHeaderItem: PhotosPickerItem?
    @Published var selectedGalleryItems: [PhotosPickerItem] = []
    
    // Estado do formulário
    @Published var isSaving: Bool = false
    @Published var saveError: String?
    @Published var saveSuccess: Bool = false
    
    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    
    // MARK: - Validação
    
    var isFormValid: Bool {
        !name.isEmpty &&
        !address.isEmpty &&
        latitude != 0.0 &&
        longitude != 0.0 &&
        headerImage != nil
    }
    
    var validationMessage: String? {
        if name.isEmpty {
            return "O nome do estabelecimento é obrigatório"
        }
        if address.isEmpty {
            return "O endereço é obrigatório"
        }
        if latitude == 0.0 || longitude == 0.0 {
            return "Busque o endereço para obter as coordenadas"
        }
        if headerImage == nil {
            return "Adicione uma imagem de capa"
        }
        return nil
    }
    
    // MARK: - Geocoding
    
    func geocodeAddress() async {
        guard !address.isEmpty else {
            geocodingError = "Digite um endereço primeiro"
            return
        }
        
        isGeocodingAddress = true
        geocodingError = nil
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(address)
            
            if let location = placemarks.first?.location {
                latitude = location.coordinate.latitude
                longitude = location.coordinate.longitude
                geocodingError = nil
            } else {
                geocodingError = "Endereço não encontrado"
            }
        } catch {
            geocodingError = "Erro ao buscar endereço: \(error.localizedDescription)"
        }
        
        isGeocodingAddress = false
    }
    
    // MARK: - Current Location
    
    func getCurrentLocation() async {
        isGettingLocation = true
        locationError = nil
        
        // Verificar permissões
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            // Pedir permissão
            locationManager.requestWhenInUseAuthorization()
            // Aguardar um pouco para o usuário responder
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
        
        // Verificar se temos permissão
        let currentStatus = locationManager.authorizationStatus
        
        guard currentStatus == .authorizedWhenInUse || currentStatus == .authorizedAlways else {
            locationError = "Permissão de localização negada. Habilite nas Configurações."
            isGettingLocation = false
            return
        }
        
        // Configurar o location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        do {
            // Obter localização atual
            locationManager.startUpdatingLocation()
            
            // Aguardar um pouco para obter a localização
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            guard let location = locationManager.location else {
                locationError = "Não foi possível obter sua localização"
                locationManager.stopUpdatingLocation()
                isGettingLocation = false
                return
            }
            
            locationManager.stopUpdatingLocation()
            
            // Salvar coordenadas
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            print("📍 Localização obtida: \(latitude), \(longitude)")
            
            // Fazer reverse geocoding para obter o endereço
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            if let placemark = placemarks.first {
                // Construir endereço formatado
                var addressComponents: [String] = []
                
                if let street = placemark.thoroughfare {
                    addressComponents.append(street)
                }
                if let number = placemark.subThoroughfare {
                    addressComponents.append(number)
                }
                if let neighborhood = placemark.subLocality {
                    addressComponents.append(neighborhood)
                }
                if let city = placemark.locality {
                    addressComponents.append(city)
                }
                if let state = placemark.administrativeArea {
                    addressComponents.append(state)
                }
                if let postalCode = placemark.postalCode {
                    addressComponents.append(postalCode)
                }
                
                address = addressComponents.joined(separator: ", ")
                print("✅ Endereço obtido: \(address)")
                
                locationError = nil
            } else {
                locationError = "Endereço não encontrado para esta localização"
            }
            
        } catch {
            print("❌ Erro ao obter localização: \(error)")
            locationError = "Erro ao obter localização: \(error.localizedDescription)"
        }
        
        isGettingLocation = false
    }
    
    // MARK: - Image Loading
    
    func loadHeaderImage() async {
        guard let item = selectedHeaderItem else { return }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                headerImage = image
            }
        } catch {
            print("Erro ao carregar imagem: \(error)")
        }
    }
    
    func loadGalleryImages() async {
        galleryImages.removeAll()
        
        for item in selectedGalleryItems {
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    galleryImages.append(image)
                }
            } catch {
                print("Erro ao carregar imagem da galeria: \(error)")
            }
        }
    }
    
    // MARK: - Save
    
    func saveMerchant() async -> Bool {
        guard isFormValid else {
            saveError = validationMessage
            return false
        }
        
        isSaving = true
        saveError = nil
        
        do {
            // 1. Gerar ID único para o merchant
            let merchantId = UUID().uuidString
            
            print("🔄 Iniciando upload de imagens...")
            
            #if canImport(FirebaseStorage)
            let storageService = FirebaseStorageService()
            
            // 2. Upload da imagem de capa
            guard let headerImg = headerImage else {
                saveError = "Imagem de capa é obrigatória"
                isSaving = false
                return false
            }
            
            let headerImageUrl = try await storageService.uploadImage(
                headerImg,
                merchantId: merchantId,
                imageType: .header
            )
            print("✅ Header image uploaded: \(headerImageUrl)")
            
            // 3. Upload das imagens da galeria (se existirem)
            var galleryUrls: [String]?
            if !galleryImages.isEmpty {
                galleryUrls = try await storageService.uploadImages(
                    galleryImages,
                    merchantId: merchantId,
                    imageType: .gallery
                )
                print("✅ Gallery images uploaded: \(galleryUrls?.count ?? 0) images")
            }
            
            // 4. Criar objeto Merchant
            let merchant = Merchant(
                id: merchantId,
                name: name,
                headerImageUrl: headerImageUrl,
                carouselImages: nil, // Por enquanto não temos carrossel separado
                galleryImages: galleryUrls,
                categories: [selectedType.rawValue],
                style: selectedStyle.rawValue,
                criticRating: nil, // Crítico não avaliou ainda
                publicRating: rating,
                likesCount: 0,
                bookmarksCount: 0,
                viewsCount: 0,
                description: description.isEmpty ? nil : description,
                addressText: address,
                latitude: latitude,
                longitude: longitude,
                openingHours: buildOpeningHours(),
                isOpen: nil, // Será calculado posteriormente
                createdAt: Date(),
                updatedAt: Date()
            )
            
            print("🔄 Salvando no Firestore...")
            
            // 5. Salvar no Firestore
            #if canImport(FirebaseFirestore)
            let repository = FirebaseMerchantRepository()
            try await repository.createMerchant(merchant)
            print("✅ Merchant salvo com sucesso!")
            #endif
            #endif
            
            isSaving = false
            saveSuccess = true
            
            return true
            
        } catch {
            print("❌ Erro ao salvar merchant: \(error)")
            saveError = "Erro ao salvar: \(error.localizedDescription)"
            isSaving = false
            return false
        }
    }
    
    // MARK: - Helpers
    
    func buildOpeningHours() -> OpeningHours {
        func timeString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
        
        func dayHours(for weekday: Weekday) -> DayHours? {
            guard let schedule = schedules.first(where: { $0.weekday == weekday }) else {
                return nil
            }
            return DayHours(
                open: timeString(from: schedule.openTime),
                close: timeString(from: schedule.closeTime),
                isClosed: schedule.isClosed
            )
        }
        
        return OpeningHours(
            monday: dayHours(for: .monday),
            tuesday: dayHours(for: .tuesday),
            wednesday: dayHours(for: .wednesday),
            thursday: dayHours(for: .thursday),
            friday: dayHours(for: .friday),
            saturday: dayHours(for: .saturday),
            sunday: dayHours(for: .sunday)
        )
    }
}

