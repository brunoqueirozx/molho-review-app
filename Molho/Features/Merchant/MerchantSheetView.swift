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
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Imagem de header com gradiente (fundo fixo)
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        // Imagem de fundo
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 420)
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
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        dismiss()
                                    }
                                }) {
                                    Image(systemName: "arrow.left")
                                        .font(.system(size: 20))
                                        .foregroundStyle(.black)
                                        .frame(width: 40, height: 40)
                                        .background(.white)
                                        .clipShape(Circle())
                                }
                                
                                Spacer()
                                
                                // Botões de ação
                                HStack(spacing: Theme.spacing16) {
                                    Button(action: { print("Eye tapped") }) {
                                        Image(systemName: "eye")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.black)
                                            .frame(width: 40, height: 40)
                                            .background(.white)
                                            .clipShape(Circle())
                                    }
                                    
                                    Button(action: { print("Bookmark tapped") }) {
                                        Image(systemName: "bookmark")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.black)
                                            .frame(width: 40, height: 40)
                                            .background(.white)
                                            .clipShape(Circle())
                                    }
                                    
                                    Button(action: { print("Share tapped") }) {
                                        Image(systemName: "paperplane")
                                            .font(.system(size: 20))
                                            .foregroundStyle(.black)
                                            .frame(width: 40, height: 40)
                                            .background(.white)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .padding(.horizontal, Theme.spacing16)
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                            
                            Spacer()
                        }
                        .background(.ultraThinMaterial.opacity(0.1))
                    }
                    .frame(height: 420)
                    
                    Spacer()
                }
                
                // Conteúdo scrollável (sobreposto)
                ScrollView {
                    VStack(spacing: 0) {
                        // Espaçador para a imagem
                        Spacer()
                            .frame(height: 180)
                        
                        // Conteúdo branco com bordas arredondadas no topo
                        VStack(alignment: .leading, spacing: Theme.spacing24) {
                            // Título e informações
                            VStack(alignment: .leading, spacing: 18) {
                                Text(viewModel.merchant.name)
                                    .font(.system(size: 28, weight: .regular))
                                    .foregroundStyle(Color(hex: "#1f1f1f"))
                                    .tracking(0.38)
                                    .lineSpacing(6)
                                
                                // Categorias
                                HStack(spacing: Theme.spacing8) {
                                    if let category = viewModel.merchant.category {
                                        Text(category)
                                            .font(.system(size: 17))
                                            .foregroundStyle(Theme.textNeutral)
                                            .tracking(-0.43)
                                        
                                        Circle()
                                            .fill(Theme.textNeutral)
                                            .frame(width: 3, height: 3)
                                    }
                                    
                                    if let style = viewModel.merchant.style {
                                        Text(style)
                                            .font(.system(size: 17))
                                            .foregroundStyle(Theme.textNeutral)
                                            .tracking(-0.43)
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
                                        .font(.system(size: 17))
                                        .foregroundStyle(Theme.textNeutral)
                                        .tracking(-0.43)
                                        .lineSpacing(5)
                                }
                            }
                            .padding(.top, Theme.spacing32)
                            
                            // Chips de navegação
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
                                    }
                                }
                            }
                            .padding(.vertical, Theme.spacing16)
                            
                            // Divider
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                            
                            // Grade de fotos
                            HStack(spacing: Theme.spacing8) {
                                // Foto grande à esquerda (220x220)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 220, height: 220)
                                
                                // Grid de 5 fotos (3 colunas x 2 linhas)
                                VStack(spacing: Theme.spacing8) {
                                    HStack(spacing: Theme.spacing8) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 107, height: 106)
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 107, height: 106)
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 107, height: 106)
                                    }
                                    HStack(spacing: Theme.spacing8) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 107, height: 106)
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 107, height: 106)
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 107, height: 106)
                                    }
                                }
                            }
                            .padding(.top, Theme.spacing16)
                            .padding(.bottom, Theme.spacing32)
                        }
                        .padding(.horizontal, Theme.spacing16)
                        .background(.white)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 32,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 32
                            )
                        )
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
