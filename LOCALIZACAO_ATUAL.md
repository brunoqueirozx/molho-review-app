# 📍 Localização Atual - Funcionalidade Implementada

## ✅ O que foi implementado

Agora o usuário pode **obter sua localização atual** e preencher automaticamente o campo de endereço!

### Recursos:
- ✅ Ícone de pin (mappin) no campo de endereço
- ✅ Requisição de permissão de localização
- ✅ Obtenção de coordenadas GPS
- ✅ Reverse geocoding (coordenadas → endereço)
- ✅ Preenchimento automático do endereço
- ✅ Feedback visual com loading
- ✅ Tratamento de erros

## 🎨 Interface

### Campo de Endereço com Ícone

```
┌─────────────────────────────────────────────┐
│ Endereço completo             📍            │
└─────────────────────────────────────────────┘
                                  ↑
                            Ícone clicável
```

**Quando o usuário clica no pin:**
1. Sistema pede permissão de localização (primeira vez)
2. Obtém coordenadas GPS precisas
3. Converte coordenadas em endereço
4. Preenche automaticamente todos os campos

## 🔧 Implementação Técnica

### 1. AddMerchantViewModel.swift

#### Novas Propriedades:
```swift
@Published var isGettingLocation: Bool = false
@Published var locationError: String?
private let locationManager = CLLocationManager()
```

#### Novo Método: `getCurrentLocation()`

**Fluxo:**
```
1. Verificar permissões
   ├─ Se não tem → Solicitar
   └─ Se negada → Mostrar erro
   
2. Obter localização GPS
   └─ CLLocationManager.startUpdatingLocation()
   
3. Salvar coordenadas
   ├─ latitude
   └─ longitude
   
4. Reverse Geocoding
   └─ Converter coordenadas em endereço
   
5. Preencher campo de endereço
   └─ Formato: "Rua, Nº, Bairro, Cidade, Estado, CEP"
```

#### Construção do Endereço:

O endereço é construído com os componentes disponíveis:
- **thoroughfare**: Nome da rua (ex: "Av Paulista")
- **subThoroughfare**: Número (ex: "1578")
- **subLocality**: Bairro (ex: "Bela Vista")
- **locality**: Cidade (ex: "São Paulo")
- **administrativeArea**: Estado (ex: "SP")
- **postalCode**: CEP (ex: "01310-100")

**Exemplo de resultado:**
```
Av Paulista, 1578, Bela Vista, São Paulo, SP, 01310-100
```

### 2. AddMerchantView.swift

#### Interface Atualizada:

```swift
HStack {
    TextField("Endereço completo", text: $viewModel.address)
        .font(.body)
    
    Button(action: {
        Task {
            await viewModel.getCurrentLocation()
        }
    }) {
        if viewModel.isGettingLocation {
            ProgressView()  // Loading durante busca
        } else {
            Image(systemName: "mappin.and.ellipse")
                .foregroundColor(.blue)
                .font(.system(size: 20))
        }
    }
}
```

### 3. Info.plist

Permissões adicionadas:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Precisamos da sua localização para preencher automaticamente o endereço do estabelecimento</string>
```

## 🎯 Como Usar

### Para o Usuário:

1. **Abrir o formulário** de criar estabelecimento
2. **No campo de endereço**, clicar no ícone de **📍 pin** (à direita)
3. **Primeira vez**: O iOS pedirá permissão
   - Permitir: "Permitir ao Usar o App"
4. **Aguardar** (2-3 segundos)
5. **Pronto!** ✅
   - Endereço preenchido automaticamente
   - Latitude e longitude salvas
   - Não precisa clicar em "Buscar Coordenadas"

### Estados Visuais:

#### 1. Normal (antes de clicar)
```
📍 Ícone azul
```

#### 2. Buscando localização
```
⏳ Loading spinner
```

#### 3. Sucesso
```
✅ Endereço preenchido
✅ Coordenadas salvas
```

#### 4. Erro
```
❌ Mensagem de erro em vermelho
```

## ⚠️ Mensagens de Erro

### Permissão Negada
```
"Permissão de localização negada. Habilite nas Configurações."
```

**Solução:**
1. Vá em Ajustes → Molho
2. Localização → "Ao Usar o App"

### Localização não disponível
```
"Não foi possível obter sua localização"
```

**Possíveis causas:**
- GPS desligado
- Dentro de prédio (sem sinal GPS)
- Modo avião ativado
- Simulador sem localização configurada

### Endereço não encontrado
```
"Endereço não encontrado para esta localização"
```

**Causa:**
- Coordenadas em área sem endereço cadastrado
- Problema no serviço de geocoding

## 🧪 Testar no Simulador

### 1. Configurar Localização no Simulador:

```
Features → Location → Custom Location
Latitude: -23.561684
Longitude: -46.656139
(Av Paulista, São Paulo)
```

### 2. Ou usar localização predefinida:

```
Features → Location → Apple
Features → Location → City Run
Features → Location → Freeway Drive
```

### 3. Executar o teste:

1. Abrir formulário
2. Clicar no pin
3. Permitir localização
4. Aguardar resultado

## 📊 Logs no Console

### Sucesso:
```
📍 Localização obtida: -23.561684, -46.656139
✅ Endereço obtido: Av Paulista, 1578, Bela Vista, São Paulo, SP
```

### Erro:
```
❌ Erro ao obter localização: [descrição]
```

## 🔐 Privacidade

### Permissões Solicitadas:
- **NSLocationWhenInUseUsageDescription**: Usado apenas enquanto o app está aberto
- **Não** coleta localização em background
- **Não** rastreia o usuário
- Usado **apenas** para preencher o formulário

### Quando é usado:
- ✅ Apenas quando o usuário clica no pin
- ✅ Apenas durante a criação de estabelecimento
- ❌ NÃO coleta automaticamente
- ❌ NÃO envia para servidor

## 🆚 Comparação: Pin vs Buscar Coordenadas

| Feature | 📍 Pin (Localização Atual) | 🔍 Buscar Coordenadas |
|---------|---------------------------|----------------------|
| **Entrada** | Localização GPS | Endereço digitado |
| **Saída** | Endereço + Coordenadas | Coordenadas |
| **Velocidade** | 2-3 segundos | 1-2 segundos |
| **Precisão** | GPS preciso | Depende do endereço |
| **Uso** | Estou no local | Endereço conhecido |
| **Permissão** | Requer permissão | Não requer |

## 💡 Casos de Uso

### Caso 1: Usuário está no estabelecimento
```
1. Abrir formulário
2. Clicar no pin 📍
3. Endereço preenchido automaticamente
4. Ajustar se necessário
5. Continuar preenchimento
```

### Caso 2: Usuário não está no local
```
1. Digitar endereço manualmente
2. Clicar em "Buscar Coordenadas"
3. Continuar preenchimento
```

### Caso 3: Usuário próximo ao local
```
1. Clicar no pin 📍
2. Endereço obtido (pode ser próximo)
3. Editar endereço manualmente
4. Clicar em "Buscar Coordenadas" (atualiza lat/long)
```

## 🚀 Melhorias Futuras

- [ ] Mostrar mapa com a localização
- [ ] Permitir ajustar posição no mapa
- [ ] Salvar múltiplas localizações recentes
- [ ] Sugestão de endereços próximos
- [ ] Detecção automática de estabelecimentos próximos
- [ ] Cache de endereços buscados

## ✅ Status

| Funcionalidade | Status |
|---------------|--------|
| Ícone no campo | ✅ Implementado |
| Requisitar permissão | ✅ Implementado |
| Obter coordenadas | ✅ Implementado |
| Reverse geocoding | ✅ Implementado |
| Preencher endereço | ✅ Implementado |
| Loading visual | ✅ Implementado |
| Tratamento de erros | ✅ Implementado |
| Info.plist configurado | ✅ Implementado |

**Sistema 100% funcional!** 🎉

---

**Ícone usado:** `mappin.and.ellipse` (SF Symbols)
**Framework:** CoreLocation
**iOS mínimo:** 14.0+

