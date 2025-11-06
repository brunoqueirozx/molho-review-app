# Configuração do Firebase para o App Molho

Este documento descreve como configurar o Firebase Firestore para o back-end do app Molho.

## 1. Estrutura da Coleção `merchants`

### Documento Merchant

Cada documento na coleção `merchants` deve ter a seguinte estrutura:

```json
{
  "id": "string (gerado automaticamente pelo Firestore)",
  "name": "string (obrigatório)",
  "headerImageUrl": "string (URL da imagem principal)",
  "carouselImages": ["string"] (array de até 10 URLs),
  "galleryImages": ["string"] (array sem limite de URLs),
  "categories": ["string"] (array de tags de categoria),
  "style": "string (ex: 'Casual', 'Elegante')",
  "criticRating": 3.5 (double, 1.0 a 5.0, incrementos de 0.5),
  "publicRating": 4.2 (double, 1.0 a 5.0, incrementos de 0.5),
  "likesCount": 380 (int),
  "bookmarksCount": 350 (int),
  "viewsCount": 520 (int),
  "description": "string (até 1000 caracteres)",
  "addressText": "string (endereço completo)",
  "latitude": -23.56 (double),
  "longitude": -46.68 (double),
  "openingHours": {
    "monday": {
      "open": "18:00",
      "close": "23:00",
      "isClosed": false
    },
    "tuesday": {
      "open": "18:00",
      "close": "23:00",
      "isClosed": false
    },
    "wednesday": {
      "open": "18:00",
      "close": "23:00",
      "isClosed": false
    },
    "thursday": {
      "open": "18:00",
      "close": "23:00",
      "isClosed": false
    },
    "friday": {
      "open": "18:00",
      "close": "01:00",
      "isClosed": false
    },
    "saturday": {
      "open": "18:00",
      "close": "01:00",
      "isClosed": false
    },
    "sunday": {
      "open": "18:00",
      "close": "23:00",
      "isClosed": false
    }
  },
  "isOpen": true (boolean, calculado baseado no horário atual),
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## 2. Tags de Categoria Disponíveis

### 🥘 Restaurantes
- Brasileira
- Italiana
- Japonesa
- Churrascaria
- Steakhouse
- Frutos do mar
- Vegana
- Vegetariana
- Caseira / Comfort food
- Gourmet
- Buffet
- Fast-casual
- Rodízio
- Temática (ex: mexicana, árabe, indiana)
- Parrilla
- Family friendly
- Fine dining
- Cozinha de fusão
- Sobremesas / Doceria
- Café / Brunch

### 🍺 Bares
- Bar de drinks / coquetéis
- Pub / Cervejaria
- Lounge
- Wine bar / bar de vinhos
- Bar temático
- Sports bar
- Bar ao ar livre / rooftop
- Bar de cerveja artesanal
- Bar de tapas / petiscos
- Bar com música ao vivo
- Karaokê
- Bar de whisky / destilados
- Bar de praia / beach bar
- Bar noturno / clube
- Boteco brasileiro
- Happy hour
- Bar snack & drinks

### 🎉 Eventos & Festas
- Festival de música
- Festa temática
- Show / concerto
- Stand-up / comédia
- Balada / clube noturno
- Evento corporativo
- Feira / exposição
- Workshop / masterclass
- Retiro / retiro de fim de semana
- Festival gastronômico
- Mercado / feira de rua
- Evento esportivo
- Evento de caridade / beneficente
- Lançamento / inauguração
- After party
- Festa de aniversário
- Festa cultural / comunitária

## 3. Regras de Segurança do Firestore

Adicione estas regras no Firebase Console (Firestore > Rules):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Coleção de merchants - leitura pública, escrita apenas para usuários autenticados
    match /merchants/{merchantId} {
      allow read: if true; // Qualquer um pode ler
      allow create: if request.auth != null; // Apenas usuários autenticados podem criar
      allow update: if request.auth != null; // Apenas usuários autenticados podem atualizar
      allow delete: if request.auth != null; // Apenas usuários autenticados podem deletar
    }
  }
}
```

## 4. Índices Necessários

Crie os seguintes índices compostos no Firestore:

1. **Busca por nome:**
   - Collection: `merchants`
   - Fields: `name` (Ascending)

2. **Busca geográfica (quando implementar GeoFirestore):**
   - Collection: `merchants`
   - Fields: `latitude` (Ascending), `longitude` (Ascending)

## 5. Como Usar no Código

### Opção 1: Repositório Síncrono (atual)
```swift
let repository: MerchantRepository = FirebaseMerchantRepository()
let merchants = repository.searchMerchants(query: "Bar")
```

### Opção 2: Repositório Assíncrono (iOS 15+)
```swift
let repository = FirebaseMerchantRepositoryAsync()
let merchants = try await repository.searchMerchantsAsync(query: "Bar")
```

## 6. Validações Importantes

- **carouselImages**: Máximo de 10 imagens
- **description**: Máximo de 1000 caracteres
- **criticRating** e **publicRating**: Valores entre 1.0 e 5.0, incrementos de 0.5
- **openingHours**: Formato de hora deve ser "HH:mm" (ex: "18:00", "01:00")

## 7. Exemplo de Documento Completo

```json
{
  "name": "Guarita Bar",
  "headerImageUrl": "https://example.com/images/header.jpg",
  "carouselImages": [
    "https://example.com/images/carousel1.jpg",
    "https://example.com/images/carousel2.jpg"
  ],
  "galleryImages": [
    "https://example.com/images/gallery1.jpg",
    "https://example.com/images/gallery2.jpg",
    "https://example.com/images/gallery3.jpg"
  ],
  "categories": ["Bar de drinks / coquetéis", "Happy hour"],
  "style": "Casual",
  "criticRating": 3.5,
  "publicRating": 4.2,
  "likesCount": 380,
  "bookmarksCount": 350,
  "viewsCount": 520,
  "description": "Bar aconchegante com drinks clássicos e autorais, petiscos e luz baixa. Perfeito para encontros e happy hour.",
  "addressText": "R. Simão Álvares, 952 - Pinheiros, São Paulo - SP, 05417-020",
  "latitude": -23.56,
  "longitude": -46.68,
  "openingHours": {
    "monday": {"open": "18:00", "close": "23:00", "isClosed": false},
    "tuesday": {"open": "18:00", "close": "23:00", "isClosed": false},
    "wednesday": {"open": "18:00", "close": "23:00", "isClosed": false},
    "thursday": {"open": "18:00", "close": "23:00", "isClosed": false},
    "friday": {"open": "18:00", "close": "01:00", "isClosed": false},
    "saturday": {"open": "18:00", "close": "01:00", "isClosed": false},
    "sunday": {"open": "18:00", "close": "23:00", "isClosed": false}
  },
  "isOpen": true,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

## 8. Próximos Passos

1. Adicionar o Firebase SDK via SPM (se ainda não foi feito)
2. Configurar o `GoogleService-Info.plist` no projeto
3. Criar a coleção `merchants` no Firestore
4. Adicionar alguns documentos de exemplo
5. Testar as queries no app

