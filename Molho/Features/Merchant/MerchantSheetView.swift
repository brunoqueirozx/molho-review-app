import SwiftUI

enum MerchantTab: String, CaseIterable {
    case about = "Sobre"
    case menu = "Cardápio"
    case direction = "Direção"
    case whatsapp = "WhatsApp"
    case delivery = "Delivery"
    
    var icon: String {
        switch self {
        case .about: return "info.circle"
        case .menu: return "book"
        case .direction: return "map"
        case .whatsapp: return "message"
        case .delivery: return "paperplane"
        }
    }
}

struct MerchantSheetView: View {
    let merchant: Merchant
    @StateObject private var viewModel: MerchantViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: MerchantTab = .about
    
    init(merchant: Merchant) {
        self.merchant = merchant
        _viewModel = StateObject(wrappedValue: MerchantViewModel(merchant: merchant))
        print("🏪 MerchantSheetView inicializado para: \(merchant.name)")
        print("   - headerImageUrl: \(merchant.headerImageUrl ?? "nil")")
        print("   - carouselImages: \(merchant.carouselImages?.count ?? 0) imagens")
        print("   - galleryImages: \(merchant.galleryImages?.count ?? 0) imagens")
        if let gallery = merchant.galleryImages {
            gallery.enumerated().forEach { index, url in
                print("      [\(index)]: \(url)")
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Imagem de header com gradiente (fundo fixo)
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        // Imagem de fundo
                        Group {
                            if let headerImageUrl = merchant.headerImageUrl, let url = URL(string: headerImageUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 320)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 320)
                                            .clipped()
                                    case .failure:
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 320)
                                    @unknown default:
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 320)
                                    }
                                }
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 320)
                            }
                        }
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0.5),
                                    .init(color: .black, location: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        
                        // Header com botões (sobreposto com backdrop blur)
                        VStack {
                            HStack {
                                // Botão voltar
                                Button(action: {
                                    print("🔙 Botão voltar clicado - fechando sheet")
                                    dismiss()
                                }) {
                                    Image(systemName: "arrow.left")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.black)
                                        .frame(width: 40, height: 40)
                                        .background(.white)
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                                
                                Spacer()
                                
                                // Botões de ação
                                HStack(spacing: 8) {
                                    Button(action: { print("⭐ Star tapped") }) {
                                        Image(systemName: "star")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.black)
                                            .frame(width: 40, height: 40)
                                            .background(.white)
                                            .clipShape(Circle())
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Button(action: { print("❤️ Heart tapped") }) {
                                        Image(systemName: "heart")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.black)
                                            .frame(width: 40, height: 40)
                                            .background(.white)
                                            .clipShape(Circle())
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Button(action: { print("🔖 Bookmark tapped") }) {
                                        Image(systemName: "bookmark")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.black)
                                            .frame(width: 40, height: 40)
                                            .background(.white)
                                            .clipShape(Circle())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, Theme.spacing16)
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                            
                            Spacer()
                        }
                        .background(.ultraThinMaterial.opacity(0.1))
                        .allowsHitTesting(true)
                        .zIndex(10)
                    }
                    .frame(height: 320)
                    .zIndex(10)
                    
                    Spacer()
                }
                
                // Conteúdo scrollável (sobreposto)
                ScrollView {
                    VStack(spacing: 0) {
                        // Espaçador para a imagem
                        Spacer()
                            .frame(height: 180)
                        
                        // Conteúdo branco com bordas arredondadas no topo
                        VStack(alignment: .leading, spacing: 24) {
                            // Título e informações
                            VStack(alignment: .leading, spacing: 18) {
                                Text(viewModel.merchant.name)
                                    .font(.system(size: 28, weight: .regular))
                                    .foregroundStyle(Color(hex: "#1f1f1f"))
                                    .tracking(0.38)
                                    .lineSpacing(6)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                                
                                // Categorias
                                HStack(spacing: Theme.spacing8) {
                                    if let category = viewModel.merchant.category {
                                        Text(category)
                                            .font(.system(size: 17))
                                            .foregroundStyle(Theme.textNeutral)
                                            .tracking(-0.43)
                                            .lineLimit(1)
                                        
                                        Circle()
                                            .fill(Theme.textNeutral)
                                            .frame(width: 3, height: 3)
                                    }
                                    
                                    if let style = viewModel.merchant.style {
                                        Text(style)
                                            .font(.system(size: 17))
                                            .foregroundStyle(Theme.textNeutral)
                                            .tracking(-0.43)
                                            .lineLimit(1)
                                    }
                                }
                                
                                // Métricas (ícones pretos conforme Figma)
                                HStack(spacing: Theme.spacing16) {
                                    MetricItem(icon: "star.fill", value: String(format: "%.1f", viewModel.merchant.rating ?? 0.0))
                                    MetricItem(icon: "bubble.left", value: String(format: "%.1f", viewModel.merchant.reviewsCount ?? 0.0))
                                    MetricItem(icon: "eye", value: "\(viewModel.merchant.viewsCount ?? 0)")
                                    MetricItem(icon: "bookmark", value: "\(viewModel.merchant.bookmarksCount ?? 0)")
                                }
                                
                                // Descrição
                                if let description = viewModel.merchant.description {
                                    Text(description)
                                        .font(Font.custom("SF Pro", size: 17))
                                        .foregroundColor(Color(red: 0.32, green: 0.32, blue: 0.32))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            
                            // Chips de navegação (scroll horizontal)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: Theme.spacing8) {
                                    ForEach(MerchantTab.allCases, id: \.self) { tab in
                                        MerchantTabChip(
                                            tab: tab,
                                            isSelected: selectedTab == tab
                                        ) {
                                            selectedTab = tab
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, Theme.spacing16)
                            
                            // Divider
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                            
                            // Seção Localização
                            VStack(alignment: .leading, spacing: Theme.spacing8) {
                                Text("Localização")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(Color.black.opacity(0.8))
                                    .tracking(-0.45)
                                
                                if let address = viewModel.merchant.address {
                                    Text(address)
                                        .font(.system(size: 17))
                                        .foregroundStyle(Color(hex: "#989898"))
                                        .tracking(-0.43)
                                        .lineSpacing(5)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .padding(.vertical, Theme.spacing16)
                            
                            // Divider
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                            
                            // Seção Horário
                            VStack(alignment: .leading, spacing: Theme.spacing8) {
                                Text("Horário de funcionamento")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(Color.black.opacity(0.8))
                                    .tracking(-0.45)
                                
                                HStack(spacing: 10) {
                                    Text(viewModel.merchant.isOpen == true ? "Aberto" : "Fechado")
                                        .font(.system(size: 17))
                                        .foregroundStyle(Color(hex: "#989898"))
                                        .tracking(-0.43)
                                    
                                    Circle()
                                        .fill(Color(hex: "#989898"))
                                        .frame(width: 6, height: 6)
                                    
                                    if let hours = viewModel.merchant.openingHours {
                                        Text(String(describing: hours))
                                            .font(.system(size: 17))
                                            .foregroundStyle(Color(hex: "#989898"))
                                            .tracking(-0.43)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                            }
                            .padding(.vertical, Theme.spacing16)
                            
                            // Divider
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                            
                            // Grade de fotos
                            if let galleryImages = viewModel.merchant.galleryImages, !galleryImages.isEmpty {
                                let _ = print("🎨 MerchantSheetView: Renderizando galeria com \(galleryImages.count) imagens")
                                VStack(alignment: .leading, spacing: Theme.spacing16) {
                                    // Título da galeria
                                    Text("Galeria")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(Color.black.opacity(0.8))
                                        .tracking(-0.45)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: Theme.spacing8) {
                                        
                                        // Foto grande à esquerda (220x220)
                                        if let firstImageUrl = galleryImages.first, let url = URL(string: firstImageUrl) {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(Color.gray.opacity(0.2))
                                                            .frame(width: 220, height: 220)
                                                        ProgressView()
                                                            .progressViewStyle(CircularProgressViewStyle(tint: Theme.primaryGreen))
                                                    }
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 220, height: 220)
                                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                                case .failure(let error):
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(Color.red.opacity(0.1))
                                                            .frame(width: 220, height: 220)
                                                        VStack(spacing: 8) {
                                                            Image(systemName: "exclamationmark.triangle")
                                                                .font(.system(size: 24))
                                                                .foregroundColor(.red.opacity(0.6))
                                                            Text("Erro ao carregar")
                                                                .font(.system(size: 12))
                                                                .foregroundColor(.red.opacity(0.6))
                                                        }
                                                    }
                                                    .onAppear {
                                                        print("❌ Erro ao carregar imagem: \(firstImageUrl)")
                                                        print("   Erro: \(error)")
                                                    }
                                                @unknown default:
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color.gray.opacity(0.3))
                                                        .frame(width: 220, height: 220)
                                                }
                                            }
                                        } else {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 220, height: 220)
                                        }
                                        
                                        // Grid de 6 fotos (3 colunas x 2 linhas)
                                        VStack(spacing: Theme.spacing8) {
                                            // Primeira linha
                                            HStack(spacing: Theme.spacing8) {
                                                ForEach(Array(galleryImages.dropFirst().prefix(3).enumerated()), id: \.offset) { index, imageUrl in
                                                    if let url = URL(string: imageUrl) {
                                                        AsyncImage(url: url) { phase in
                                                            switch phase {
                                                            case .empty:
                                                                ZStack {
                                                                    RoundedRectangle(cornerRadius: 8)
                                                                        .fill(Color.gray.opacity(0.2))
                                                                        .frame(width: 107, height: 106)
                                                                    ProgressView()
                                                                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.primaryGreen))
                                                                        .scaleEffect(0.7)
                                                                }
                                                            case .success(let image):
                                                                image
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fill)
                                                                    .frame(width: 107, height: 106)
                                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                                            case .failure:
                                                                ZStack {
                                                                    RoundedRectangle(cornerRadius: 8)
                                                                        .fill(Color.red.opacity(0.1))
                                                                        .frame(width: 107, height: 106)
                                                                    Image(systemName: "exclamationmark.triangle")
                                                                        .font(.system(size: 16))
                                                                        .foregroundColor(.red.opacity(0.6))
                                                                }
                                                            @unknown default:
                                                                RoundedRectangle(cornerRadius: 8)
                                                                    .fill(Color.gray.opacity(0.3))
                                                                    .frame(width: 107, height: 106)
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                // Preencher espaços vazios se houver menos de 3 imagens
                                                ForEach(0..<max(0, 3 - min(3, galleryImages.count - 1)), id: \.self) { _ in
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color.gray.opacity(0.3))
                                                        .frame(width: 107, height: 106)
                                                }
                                            }
                                            
                                            // Segunda linha
                                            HStack(spacing: Theme.spacing8) {
                                                ForEach(Array(galleryImages.dropFirst(4).prefix(3).enumerated()), id: \.offset) { index, imageUrl in
                                                    if let url = URL(string: imageUrl) {
                                                        AsyncImage(url: url) { phase in
                                                            switch phase {
                                                            case .empty:
                                                                ZStack {
                                                                    RoundedRectangle(cornerRadius: 8)
                                                                        .fill(Color.gray.opacity(0.2))
                                                                        .frame(width: 107, height: 106)
                                                                    ProgressView()
                                                                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.primaryGreen))
                                                                        .scaleEffect(0.7)
                                                                }
                                                            case .success(let image):
                                                                image
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fill)
                                                                    .frame(width: 107, height: 106)
                                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                                            case .failure:
                                                                ZStack {
                                                                    RoundedRectangle(cornerRadius: 8)
                                                                        .fill(Color.red.opacity(0.1))
                                                                        .frame(width: 107, height: 106)
                                                                    Image(systemName: "exclamationmark.triangle")
                                                                        .font(.system(size: 16))
                                                                        .foregroundColor(.red.opacity(0.6))
                                                                }
                                                            @unknown default:
                                                                RoundedRectangle(cornerRadius: 8)
                                                                    .fill(Color.gray.opacity(0.3))
                                                                    .frame(width: 107, height: 106)
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                // Preencher espaços vazios se houver menos de 6 imagens no total
                                                ForEach(0..<max(0, 3 - min(3, max(0, galleryImages.count - 4))), id: \.self) { _ in
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color.gray.opacity(0.3))
                                                        .frame(width: 107, height: 106)
                                                }
                                            }
                                        }
                                        }
                                    }
                                }
                                .padding(.top, Theme.spacing16)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 32)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(.white)
                        .cornerRadius(32)
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct MetricItem: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundStyle(Color(hex: "#1f1f1f")) // Preto conforme Figma
            Text(value)
                .font(.system(size: 15))
                .foregroundStyle(Theme.textNeutral)
        }
    }
}

struct MerchantTabChip: View {
    let tab: MerchantTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if tab == .whatsapp {
                    Image(systemName: "message")
                        .font(.system(size: 16))
                } else {
                    Image(systemName: tab.icon)
                        .font(.system(size: 16))
                }
                Text(tab.rawValue)
                    .font(.system(size: 16))
            }
            .foregroundStyle(isSelected ? Color.white.opacity(0.92) : Color(hex: "#3d3d3d").opacity(0.92))
            .padding(.horizontal, Theme.spacing16)
            .padding(.vertical, Theme.spacing12)
            .background(isSelected ? Theme.primaryGreen : Color(hex: "#e1e1e1"))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.corner100)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: isSelected ? 2 : 0)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.corner100))
        }
    }
}
