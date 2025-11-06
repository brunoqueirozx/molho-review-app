import SwiftUI
import Combine

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @FocusState private var isSearchFocused: Bool
    @State private var showMerchantSheet: Bool = false
    @State private var selectedMerchant: Merchant?

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.spacing16) {
                    // Campo de busca
                    HStack(spacing: Theme.spacing16) {
                        HStack(spacing: Theme.spacing12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.black)
                                .font(.system(size: 20))
                            
                            TextField("", text: $viewModel.query, prompt: Text("Buscar").foregroundStyle(.secondary))
                                .font(.system(size: 20))
                                .focused($isSearchFocused)
                                .onSubmit {
                                    viewModel.search()
                                }
                                .onChange(of: viewModel.query) { _, newValue in
                                    // Busca quando o usuário digita
                                    viewModel.search()
                                }
                            
                            if !viewModel.query.isEmpty {
                                Button(action: {
                                    viewModel.query = ""
                                    viewModel.search()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                        .font(.system(size: 20))
                                }
                            }
                        }
                        .padding(Theme.spacing12)
                        .background(Theme.backgroundGray)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.corner100))
                        
                        Button(action: {
                            // Ação de filtro
                            print("Filter tapped")
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(.black)
                                .font(.system(size: 20))
                                .frame(width: 48, height: 48)
                                .background(Theme.backgroundGray)
                                .clipShape(RoundedRectangle(cornerRadius: Theme.corner100))
                        }
                    }
                    .padding(.horizontal, Theme.spacing16)
                    .padding(.top, Theme.spacing24)
                    
                    // Filtros horizontais
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.spacing8) {
                            ForEach(SearchScope.allCases, id: \.self) { filter in
                                FilterChip(
                                    filter: filter,
                                    isSelected: viewModel.selectedFilter == filter
                                ) {
                                    viewModel.selectedFilter = filter
                                    viewModel.search()
                                }
                            }
                            
                            // Botão "Nova lista"
                            Button(action: {
                                print("Nova lista")
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "plus")
                                    Text("Nova lista")
                                }
                                .font(.system(size: 16))
                                .foregroundStyle(Theme.textSecondary)
                                .padding(.horizontal, Theme.spacing16)
                                .padding(.vertical, Theme.spacing12)
                                .background(Theme.darkGray)
                                .clipShape(RoundedRectangle(cornerRadius: Theme.corner100))
                            }
                        }
                        .padding(.horizontal, Theme.spacing16)
                    }
                    
                    // Lista de resultados
                    VStack(spacing: Theme.spacing32) {
                        ForEach(viewModel.displayedResults) { merchant in
                            MerchantListItem(merchant: merchant)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedMerchant = merchant
                                    showMerchantSheet = true
                                }
                        }
                        
                        // Botão "Ver mais" quando houver mais de 10 resultados
                        if viewModel.hasMoreResults {
                            Button(action: {
                                viewModel.loadMore()
                            }) {
                                HStack {
                                    Text("Ver mais")
                                        .font(.system(size: 16, weight: .semibold))
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 14))
                                }
                                .foregroundStyle(Theme.primaryGreen)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Theme.spacing16)
                            }
                        }
                    }
                    .padding(.horizontal, Theme.spacing16)
                    .padding(.top, Theme.spacing16)
                }
            }
        }
        .background(.white)
        .onAppear {
            // Garante que os merchants sejam carregados ao abrir a página
            if viewModel.displayedResults.isEmpty {
                viewModel.loadAllMerchants()
            }
        }
        .sheet(isPresented: $showMerchantSheet) {
            Group {
                if let merchant = selectedMerchant {
                    MerchantSheetView(merchant: merchant)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    // Fallback caso selectedMerchant seja nil
                    Text("Erro: Merchant não selecionado")
                        .padding()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showMerchantSheet)
    }
}

struct FilterChip: View {
    let filter: SearchScope
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if filter.icon.hasPrefix("🥃") || filter.icon.hasPrefix("🍺") || filter.icon.hasPrefix("🥢") {
                    Text(filter.icon)
                } else {
                    Image(systemName: filter.icon)
                        .font(.system(size: 16))
                }
                Text(filter.rawValue)
                    .font(.system(size: 16))
            }
            .foregroundStyle(isSelected ? .white : Theme.textSecondary)
            .padding(.horizontal, Theme.spacing16)
            .padding(.vertical, Theme.spacing12)
            .background(isSelected ? Theme.primaryGreen : Theme.backgroundGray)
            .clipShape(RoundedRectangle(cornerRadius: Theme.corner100))
        }
    }
}
