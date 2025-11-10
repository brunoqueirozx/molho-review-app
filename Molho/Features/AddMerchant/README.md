# Formulário de Adicionar Estabelecimento

## 📋 Visão Geral

Tela de formulário completa para criar novos estabelecimentos no app Molho. Acessível através do botão **+** na barra superior da HomeView.

## 🎯 Funcionalidades

### Campos do Formulário

1. **Informações Básicas**
   - Nome do estabelecimento (obrigatório)
   - Tipo: Bar, Restaurante, Café, Padaria, Pizzaria, Fast Food, Food Truck, Pub, Bistrô, Vinícola
   - Estilo: Calmo, Romântico, Elegante, Casual, Moderno, Rústico, Tropical, Industrial, Aconchegante, Sofisticado

2. **Descrição**
   - Editor de texto com limite de 1000 caracteres
   - Contador de caracteres em tempo real

3. **Avaliação**
   - Sistema de estrelas (1 a 5)
   - Interface interativa com feedback visual

4. **Localização**
   - Campo de endereço completo (obrigatório)
   - Botão "Buscar Coordenadas" com geocoding automático via Apple MapKit
   - Exibição de latitude e longitude após busca
   - Indicador visual de sucesso

5. **Horário de Funcionamento**
   - Configuração individual para cada dia da semana
   - Toggle para marcar dias fechados
   - Pickers de hora de abertura e fechamento
   - Interface iOS nativa

6. **Imagem de Capa**
   - PhotosPicker para selecionar imagem (obrigatório)
   - Preview da imagem selecionada
   - Dimensões: altura de 200px

7. **Galeria de Imagens**
   - Seleção múltipla de até 10 fotos
   - Preview em scroll horizontal
   - Botão para remover todas as fotos
   - Thumbnails de 100x100px

## 🎨 Design

- **Estilo**: iOS nativo com Form e Sections
- **Margens**: 16px (gerenciado automaticamente pelo Form)
- **Fontes**: System fonts do iOS (.body, .caption, .subheadline)
- **Espaçamento**: Padrão iOS com spacing de 8-16px

## 🔧 Componentes

### AddMerchantView.swift
View principal do formulário com todos os campos organizados em sections.

### AddMerchantViewModel.swift
ViewModel que gerencia:
- Estado do formulário
- Validações
- Geocoding de endereços
- Carregamento de imagens
- Lógica de salvamento

### StarRatingPicker
Componente customizado para seleção de avaliação com estrelas.

## ✅ Validações

- Nome não pode estar vazio
- Endereço é obrigatório
- Coordenadas devem ser obtidas através do geocoding
- Imagem de capa é obrigatória
- Descrição limitada a 1000 caracteres

## 🚀 Como Usar

1. Na HomeView, clique no botão **+** no canto superior direito
2. Preencha os campos obrigatórios (marcados em vermelho se inválidos)
3. Para o endereço, digite e clique em "Buscar Coordenadas"
4. Adicione imagens através dos PhotosPickers
5. Configure os horários de funcionamento
6. Clique em "Criar Estabelecimento"

## 📝 TODO

- [ ] Implementar upload de imagens para Firebase Storage
- [ ] Criar documento no Firestore com os dados
- [ ] Adicionar loading states durante upload
- [ ] Implementar tratamento de erros
- [ ] Adicionar validação de imagens (tamanho, formato)
- [ ] Implementar edição de estabelecimentos existentes
- [ ] Adicionar preview antes de salvar

## 🔗 Integração

O formulário está integrado com:
- **HomeView**: Botão + abre o sheet
- **Merchant Model**: Estrutura de dados compatível
- **OpeningHours**: Sistema de horários do Firebase
- **Apple MapKit**: Geocoding de endereços
- **PhotosUI**: Seleção de imagens

## 📱 Compatibilidade

- iOS 16.0+
- SwiftUI
- PhotosUI framework
- CoreLocation framework

