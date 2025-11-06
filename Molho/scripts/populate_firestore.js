// Script para popular o Firestore com dados de exemplo
// Execute com: node populate_firestore.js
// Certifique-se de ter o Firebase Admin SDK configurado

const admin = require('firebase-admin');
const serviceAccount = require('./path/to/your-serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const sampleMerchants = [
  {
    name: "Guarita Bar",
    headerImageUrl: "https://example.com/images/guarita-header.jpg",
    carouselImages: [
      "https://example.com/images/guarita-carousel1.jpg",
      "https://example.com/images/guarita-carousel2.jpg",
      "https://example.com/images/guarita-carousel3.jpg"
    ],
    galleryImages: [
      "https://example.com/images/guarita-gallery1.jpg",
      "https://example.com/images/guarita-gallery2.jpg",
      "https://example.com/images/guarita-gallery3.jpg",
      "https://example.com/images/guarita-gallery4.jpg",
      "https://example.com/images/guarita-gallery5.jpg",
      "https://example.com/images/guarita-gallery6.jpg"
    ],
    categories: ["Bar de drinks / coquetéis", "Happy hour"],
    style: "Casual",
    criticRating: 3.5,
    publicRating: 4.2,
    likesCount: 380,
    bookmarksCount: 350,
    viewsCount: 520,
    description: "Bar aconchegante com drinks clássicos e autorais, petiscos e luz baixa. Perfeito para encontros e happy hour.",
    addressText: "R. Simão Álvares, 952 - Pinheiros, São Paulo - SP, 05417-020",
    latitude: -23.56,
    longitude: -46.68,
    openingHours: {
      monday: { open: "18:00", close: "23:00", isClosed: false },
      tuesday: { open: "18:00", close: "23:00", isClosed: false },
      wednesday: { open: "18:00", close: "23:00", isClosed: false },
      thursday: { open: "18:00", close: "23:00", isClosed: false },
      friday: { open: "18:00", close: "01:00", isClosed: false },
      saturday: { open: "18:00", close: "01:00", isClosed: false },
      sunday: { open: "18:00", close: "23:00", isClosed: false }
    },
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    name: "Pizzaria Paulista",
    headerImageUrl: "https://example.com/images/pizzaria-header.jpg",
    carouselImages: [
      "https://example.com/images/pizzaria-carousel1.jpg",
      "https://example.com/images/pizzaria-carousel2.jpg"
    ],
    galleryImages: [
      "https://example.com/images/pizzaria-gallery1.jpg",
      "https://example.com/images/pizzaria-gallery2.jpg"
    ],
    categories: ["Italiana", "Family friendly"],
    style: "Casual",
    criticRating: 4.0,
    publicRating: 4.5,
    likesCount: 250,
    bookmarksCount: 180,
    viewsCount: 320,
    description: "Pizzaria tradicional com forno a lenha e ambiente descontraído.",
    addressText: "Av. Paulista, 1000",
    latitude: -23.561,
    longitude: -46.681,
    openingHours: {
      monday: { open: "18:00", close: "00:00", isClosed: false },
      tuesday: { open: "18:00", close: "00:00", isClosed: false },
      wednesday: { open: "18:00", close: "00:00", isClosed: false },
      thursday: { open: "18:00", close: "00:00", isClosed: false },
      friday: { open: "18:00", close: "00:00", isClosed: false },
      saturday: { open: "18:00", close: "00:00", isClosed: false },
      sunday: { open: "18:00", close: "00:00", isClosed: false }
    },
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  }
];

async function populateFirestore() {
  const batch = db.batch();
  
  sampleMerchants.forEach((merchant, index) => {
    const docRef = db.collection('merchants').doc();
    batch.set(docRef, merchant);
    console.log(`Adicionando merchant ${index + 1}: ${merchant.name}`);
  });
  
  await batch.commit();
  console.log('✅ Todos os merchants foram adicionados ao Firestore!');
}

populateFirestore()
  .then(() => {
    console.log('Script concluído com sucesso!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('Erro ao popular Firestore:', error);
    process.exit(1);
  });

