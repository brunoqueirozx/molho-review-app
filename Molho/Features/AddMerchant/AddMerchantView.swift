import SwiftUI
import PhotosUI

struct AddMerchantView: View {
    @StateObject private var viewModel = AddMerchantViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isKeyboardFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                // Título customizado
                Text("Crie um novo estabelecimento")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 24)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                
                Form {
                    // MARK: - Informações Básicas
                    Section {
                    TextField("Nome do estabelecimento", text: $viewModel.name)
                        .font(.body)
                        .focused($isKeyboardFocused)
                    
                    Picker("Tipo", selection: $viewModel.selectedType) {
                        ForEach(MerchantType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    Picker("Estilo", selection: $viewModel.selectedStyle) {
                        ForEach(MerchantStyle.allCases) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                } header: {
                    Text("Informações Básicas")
                }
                
                // MARK: - Descrição
                Section {
                    TextEditor(text: $viewModel.description)
                        .frame(minHeight: 100)
                        .font(.body)
                        .focused($isKeyboardFocused)
                } header: {
                    Text("Descrição")
                } footer: {
                    Text("\(viewModel.description.count)/1000 caracteres")
                        .font(.caption)
                }
                
                // MARK: - Avaliação
                Section {
                    HStack {
                        Text("Nota")
                        Spacer()
                        StarRatingPicker(rating: $viewModel.rating)
                    }
                } header: {
                    Text("Avaliação")
                }
                
                // MARK: - Endereço
                Section {
                    HStack {
                        TextField("Endereço completo", text: $viewModel.address)
                            .font(.body)
                            .focused($isKeyboardFocused)
                        
                        Button(action: {
                            Task {
                                await viewModel.getCurrentLocation()
                            }
                        }) {
                            if viewModel.isGettingLocation {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 20))
                            }
                        }
                        .buttonStyle(.plain)
                        .disabled(viewModel.isGettingLocation)
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.geocodeAddress()
                        }
                    }) {
                        HStack {
                            if viewModel.isGeocodingAddress {
                                ProgressView()
                                    .padding(.trailing, 8)
                            }
                            Text("Buscar Coordenadas")
                            Spacer()
                            if viewModel.latitude != 0.0 && viewModel.longitude != 0.0 {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .disabled(viewModel.address.isEmpty || viewModel.isGeocodingAddress)
                    
                    if let error = viewModel.geocodingError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    if let error = viewModel.locationError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    if viewModel.latitude != 0.0 && viewModel.longitude != 0.0 {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Latitude: \(viewModel.latitude, specifier: "%.6f")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Longitude: \(viewModel.longitude, specifier: "%.6f")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Localização")
                }
                
                // MARK: - Horário de Funcionamento
                Section {
                    ForEach($viewModel.schedules) { $schedule in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(schedule.weekday.rawValue)
                                    .font(.body)
                                    .fontWeight(.medium)
                                Spacer()
                                Toggle("Fechado", isOn: $schedule.isClosed)
                                    .labelsHidden()
                            }
                            
                            if !schedule.isClosed {
                                HStack(spacing: 16) {
                                    DatePicker("Abre", selection: $schedule.openTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                    Text("às")
                                        .foregroundColor(.secondary)
                                    DatePicker("Fecha", selection: $schedule.closeTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                }
                                .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("Horário de Funcionamento")
                }
                
                // MARK: - Imagem de Capa
                Section {
                    if let image = viewModel.headerImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(8)
                    }
                    
                    PhotosPicker(
                        selection: $viewModel.selectedHeaderItem,
                        matching: .images
                    ) {
                        Label(
                            viewModel.headerImage == nil ? "Adicionar Imagem de Capa" : "Trocar Imagem de Capa",
                            systemImage: "photo"
                        )
                    }
                    .onChange(of: viewModel.selectedHeaderItem) { _ in
                        Task {
                            await viewModel.loadHeaderImage()
                        }
                    }
                } header: {
                    Text("Imagem de Capa")
                } footer: {
                    Text("Esta será a imagem principal do estabelecimento")
                        .font(.caption)
                }
                
                // MARK: - Galeria de Imagens
                Section {
                    if !viewModel.galleryImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(Array(viewModel.galleryImages.enumerated()), id: \.offset) { index, image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    PhotosPicker(
                        selection: $viewModel.selectedGalleryItems,
                        maxSelectionCount: 10,
                        matching: .images
                    ) {
                        Label(
                            viewModel.galleryImages.isEmpty ? "Adicionar Fotos à Galeria" : "Adicionar Mais Fotos",
                            systemImage: "photo.on.rectangle.angled"
                        )
                    }
                    .onChange(of: viewModel.selectedGalleryItems) { _ in
                        Task {
                            await viewModel.loadGalleryImages()
                        }
                    }
                    
                    if !viewModel.galleryImages.isEmpty {
                        Button(role: .destructive) {
                            viewModel.galleryImages.removeAll()
                            viewModel.selectedGalleryItems.removeAll()
                        } label: {
                            Label("Remover Todas as Fotos", systemImage: "trash")
                        }
                    }
                } header: {
                    Text("Galeria de Imagens")
                } footer: {
                    Text("Adicione até 10 fotos do estabelecimento")
                        .font(.caption)
                }
                
                // MARK: - Botão de Salvar
                Section {
                    Button(action: {
                        Task {
                            let success = await viewModel.saveMerchant()
                            if success {
                                dismiss()
                            }
                        }
                    }) {
                        HStack {
                            Spacer()
                            if viewModel.isSaving {
                                ProgressView()
                                    .padding(.trailing, 8)
                            }
                            Text(viewModel.isSaving ? "Salvando..." : "Criar Estabelecimento")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isSaving)
                    
                    if let error = viewModel.saveError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    if let validation = viewModel.validationMessage {
                        Text(validation)
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                // Toolbar do teclado - botão Concluir
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Concluir") {
                        isKeyboardFocused = false
                    }
                }
            }
        }
    }
}

// MARK: - Star Rating Picker

struct StarRatingPicker: View {
    @Binding var rating: Double
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...5, id: \.self) { index in
                Button(action: {
                    rating = Double(index)
                }) {
                    Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                        .foregroundColor(index <= Int(rating) ? .yellow : .gray)
                        .font(.title3)
                }
                .buttonStyle(.plain)
            }
            
            Text(String(format: "%.1f", rating))
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.leading, 4)
        }
    }
}

// MARK: - Preview

struct AddMerchantView_Previews: PreviewProvider {
    static var previews: some View {
        AddMerchantView()
    }
}

