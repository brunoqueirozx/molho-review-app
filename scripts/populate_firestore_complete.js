// Script completo para popular o Firestore com todos os merchants
// Execute com: node populate_firestore_complete.js
// 
// PRÉ-REQUISITOS:
// 1. npm install firebase-admin
// 2. Baixe a serviceAccountKey.json do Firebase Console
//    (Project Settings > Service Accounts > Generate New Private Key)
// 3. Coloque o arquivo em scripts/serviceAccountKey.json

const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

// Caminho para o serviceAccountKey.json
const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');

if (!fs.existsSync(serviceAccountPath)) {
  console.error('❌ Erro: Arquivo serviceAccountKey.json não encontrado!');
  console.error('   Por favor, baixe o arquivo do Firebase Console e coloque em:');
  console.error(`   ${serviceAccountPath}`);
  process.exit(1);
}

const serviceAccount = require(serviceAccountPath);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Função auxiliar para criar horários de funcionamento
function createOpeningHours(closeTime) {
  const hours = {
    monday: { open: "18:00", close: closeTime, isClosed: false },
    tuesday: { open: "18:00", close: closeTime, isClosed: false },
    wednesday: { open: "18:00", close: closeTime, isClosed: false },
    thursday: { open: "18:00", close: closeTime, isClosed: false },
    friday: { open: "18:00", close: closeTime === "23:00" ? "01:00" : closeTime, isClosed: false },
    saturday: { open: "18:00", close: closeTime === "23:00" ? "01:00" : closeTime, isClosed: false },
    sunday: { open: "18:00", close: closeTime, isClosed: false }
  };
  return hours;
}

const sampleMerchants = [
  {
    name: "Guarita Bar",
    headerImageUrl: null,
    carouselImages: [],
    galleryImages: [],
    categories: ["Bar de drinks / coquetéis", "Happy hour"],
    style: "Casual",
    criticRating: 3.5,
    publicRating: 3.6,
    likesCount: 380,
    bookmarksCount: 350,
    viewsCount: 380,
    description: "Bar aconchegante com drinks clássicos e autorais, petiscos e luz baixa. Perfeito para encontros e happy hour.",
    addressText: "R. Simão Álvares, 952 - Pinheiros, São Paulo - SP, 05417-020",
    latitude: -23.56,
    longitude: -46.68,
    openingHours: createOpeningHours("23:00"),
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    name: "Pizzaria Paulista",
    headerImageUrl: null,
    carouselImages: [],
    galleryImages: [],
    categories: ["Italiana", "Family friendly"],
    style: "Casual",
    criticRating: 4.0,
    publicRating: 4.2,
    likesCount: 250,
    bookmarksCount: 180,
    viewsCount: 250,
    description: "Pizzaria tradicional com forno a lenha e ambiente descontraído.",
    addressText: "Av. Paulista, 1000",
    latitude: -23.561,
    longitude: -46.681,
    openingHours: createOpeningHours("00:00"),
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    name: "Sushi House",
    headerImageUrl: null,
    carouselImages: [],
    galleryImages: [],
    categories: ["Japonesa"],
    style: "Elegante",
    criticRating: 4.5,
    publicRating: 4.8,
    likesCount: 520,
    bookmarksCount: 420,
    viewsCount: 520,
    description: "Sushi fresco e autêntico em ambiente moderno.",
    addressText: "Rua dos Três Irmãos, 200",
    latitude: -23.562,
    longitude: -46.682,
    openingHours: {
      monday: { open: "18:00", close: "22:30", isClosed: false },
      tuesday: { open: "18:00", close: "22:30", isClosed: false },
      wednesday: { open: "18:00", close: "22:30", isClosed: false },
      thursday: { open: "18:00", close: "22:30", isClosed: false },
      friday: { open: "18:00", close: "23:00", isClosed: false },
      saturday: { open: "18:00", close: "23:00", isClosed: false },
      sunday: { open: "18:00", close: "22:30", isClosed: false }
    },
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    name: "Boteco do João",
    headerImageUrl: null,
    carouselImages: [],
    galleryImages: [],
    categories: ["Boteco brasileiro"],
    style: "Casual",
    criticRating: 3.5,
    publicRating: 4.0,
    likesCount: 320,
    bookmarksCount: 280,
    viewsCount: 320,
    description: "Boteco tradicional com petiscos e cerveja gelada.",
    addressText: "Av. Brigadeiro, 500",
    latitude: -23.563,
    longitude: -46.683,
    openingHours: {
      monday: { open: "18:00", close: "01:00", isClosed: false },
      tuesday: { open: "18:00", close: "01:00", isClosed: false },
      wednesday: { open: "18:00", close: "01:00", isClosed: false },
      thursday: { open: "18:00", close: "01:00", isClosed: false },
      friday: { open: "18:00", close: "02:00", isClosed: false },
      saturday: { open: "18:00", close: "02:00", isClosed: false },
      sunday: { open: "18:00", close: "01:00", isClosed: false }
    },
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    name: "Izakaya Tokyo",
    headerImageUrl: null,
    carouselImages: [],
    galleryImages: [],
    categories: ["Japonesa", "Bar de drinks / coquetéis"],
    style: "Casual",
    criticRating: 4.0,
    publicRating: 4.5,
    likesCount: 410,
    bookmarksCount: 360,
    viewsCount: 410,
    description: "Autêntico izakaya japonês com ambiente acolhedor.",
    addressText: "Rua Harmonia, 300",
    latitude: -23.564,
    longitude: -46.684,
    openingHours: {
      monday: { open: "18:00", close: "23:30", isClosed: false },
      tuesday: { open: "18:00", close: "23:30", isClosed: false },
      wednesday: { open: "18:00", close: "23:30", isClosed: false },
      thursday: { open: "18:00", close: "23:30", isClosed: false },
      friday: { open: "18:00", close: "00:00", isClosed: false },
      saturday: { open: "18:00", close: "00:00", isClosed: false },
      sunday: { open: "18:00", close: "23:30", isClosed: false }
    },
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    name: "Cervejaria Artesanal",
    headerImageUrl: null,
    carouselImages: [],
    galleryImages: [],
    categories: ["Pub / Cervejaria", "Bar de cerveja artesanal"],
    style: "Casual",
    criticRating: 4.0,
    publicRating: 4.3,
    likesCount: 290,
    bookmarksCount: 240,
    viewsCount: 290,
    description: "Cervejas artesanais e petiscos selecionados.",
    addressText: "Rua Cardeal, 150",
    latitude: -23.565,
    longitude: -46.685,
    openingHours: createOpeningHours("00:00"),
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    name: "Bar do Zé",
    headerImageUrl: null,
    carouselImages: [],
    galleryImages: [],
    categories: ["Bar com música ao vivo"],
    style: "Casual",
    criticRating: 3.5,
    publicRating: 3.9,
    likesCount: 180,
    bookmarksCount: 150,
    viewsCount: 180,
    description: "Bar descontraído com música ao vivo.",
    addressText: "Rua das Flores, 80",
    latitude: -23.566,
    longitude: -46.686,
    openingHours: {
      monday: { open: "18:00", close: "02:00", isClosed: false },
      tuesday: { open: "18:00", close: "02:00", isClosed: false },
      wednesday: { open: "18:00", close: "02:00", isClosed: false },
      thursday: { open: "18:00", close: "02:00", isClosed: false },
      friday: { open: "18:00", close: "02:00", isClosed: false },
      saturday: { open: "18:00", close: "02:00", isClosed: false },
      sunday: { open: "18:00", close: "02:00", isClosed: false }
    },
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    name: "Restaurante Italiano",
    headerImageUrl: null,
    carouselImages: [],
    galleryImages: [],
    categories: ["Italiana", "Fine dining"],
    style: "Elegante",
    criticRating: 4.5,
    publicRating: 4.6,
    likesCount: 450,
    bookmarksCount: 380,
    viewsCount: 450,
    description: "Culinária italiana autêntica em ambiente sofisticado.",
    addressText: "Av. Faria Lima, 1200",
    latitude: -23.567,
    longitude: -46.687,
    openingHours: createOpeningHours("23:00"),
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    name: "Taco Loco",
    headerImageUrl: null,
    carouselImages: [],
    galleryImages: [],
    categories: ["Temática"],
    style: "Casual",
    criticRating: 4.0,
    publicRating: 4.1,
    likesCount: 220,
    bookmarksCount: 190,
    viewsCount: 220,
    description: "Tacos autênticos e margaritas geladas.",
    addressText: "Rua dos Pinheiros, 400",
    latitude: -23.568,
    longitude: -46.688,
    openingHours: {
      monday: { open: "18:00", close: "23:30", isClosed: false },
      tuesday: { open: "18:00", close: "23:30", isClosed: false },
      wednesday: { open: "18:00", close: "23:30", isClosed: false },
      thursday: { open: "18:00", close: "23:30", isClosed: false },
      friday: { open: "18:00", close: "00:00", isClosed: false },
      saturday: { open: "18:00", close: "00:00", isClosed: false },
      sunday: { open: "18:00", close: "23:30", isClosed: false }
    },
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    name: "Hamburgueria Premium",
    headerImageUrl: null,
    carouselImages: [],
    galleryImages: [],
    categories: ["Fast-casual"],
    style: "Casual",
    criticRating: 4.0,
    publicRating: 4.4,
    likesCount: 380,
    bookmarksCount: 320,
    viewsCount: 380,
    description: "Hambúrgueres artesanais com ingredientes selecionados.",
    addressText: "Rua Teodoro Sampaio, 600",
    latitude: -23.569,
    longitude: -46.689,
    openingHours: createOpeningHours("00:00"),
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    name: "Churrascaria Gaúcha",
    headerImageUrl: null,
    carouselImages: [],
    galleryImages: [],
    categories: ["Churrascaria", "Rodízio"],
    style: "Elegante",
    criticRating: 4.5,
    publicRating: 4.7,
    likesCount: 550,
    bookmarksCount: 480,
    viewsCount: 550,
    description: "Churrasco gaúcho autêntico com rodízio completo.",
    addressText: "Av. Rebouças, 800",
    latitude: -23.570,
    longitude: -46.690,
    openingHours: {
      monday: { open: "18:00", close: "23:30", isClosed: false },
      tuesday: { open: "18:00", close: "23:30", isClosed: false },
      wednesday: { open: "18:00", close: "23:30", isClosed: false },
      thursday: { open: "18:00", close: "23:30", isClosed: false },
      friday: { open: "18:00", close: "00:00", isClosed: false },
      saturday: { open: "18:00", close: "00:00", isClosed: false },
      sunday: { open: "18:00", close: "23:30", isClosed: false }
    },
    isOpen: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  },
  {
    name: "Padaria Artesanal",
    headerImageUrl: null,
    carouselImages: [],
    galleryImages: [],
    categories: ["Café / Brunch"],
    style: "Casual",
    criticRating: 3.5,
    publicRating: 4.0,
    likesCount: 200,
    bookmarksCount: 170,
    viewsCount: 200,
    description: "Pães e doces artesanais feitos diariamente.",
    addressText: "Rua dos Jardins, 250",
    latitude: -23.571,
    longitude: -46.691,
    openingHours: {
      monday: { open: "06:00", close: "20:00", isClosed: false },
      tuesday: { open: "06:00", close: "20:00", isClosed: false },
      wednesday: { open: "06:00", close: "20:00", isClosed: false },
      thursday: { open: "06:00", close: "20:00", isClosed: false },
      friday: { open: "06:00", close: "20:00", isClosed: false },
      saturday: { open: "06:00", close: "20:00", isClosed: false },
      sunday: { open: "06:00", close: "20:00", isClosed: false }
    },
    isOpen: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp()
  }
];

async function populateFirestore() {
  console.log('🚀 Iniciando população do Firestore...\n');
  
  try {
    // Testar conexão com Firestore primeiro
    console.log('🔍 Verificando conexão com Firestore...');
    
    // Verificar se já existem merchants
    const existingDocs = await db.collection('merchants').limit(1).get();
    if (!existingDocs.empty) {
      console.log('⚠️  Aviso: Já existem documentos na coleção "merchants".');
      console.log('   Deseja continuar mesmo assim? (Ctrl+C para cancelar)');
      await new Promise(resolve => setTimeout(resolve, 3000));
    }
    
    const batch = db.batch();
    let count = 0;
    
    sampleMerchants.forEach((merchant) => {
      const docRef = db.collection('merchants').doc();
      batch.set(docRef, merchant);
      count++;
      console.log(`✓ Preparando merchant ${count}: ${merchant.name}`);
    });
    
    console.log(`\n📤 Enviando ${count} merchants para o Firestore...`);
    await batch.commit();
    
    console.log(`\n✅ Sucesso! ${count} merchants foram adicionados ao Firestore!`);
    console.log('\n📋 Resumo:');
    sampleMerchants.forEach((merchant, index) => {
      console.log(`   ${index + 1}. ${merchant.name} - ${merchant.categories?.join(', ') || 'Sem categoria'}`);
    });
    
  } catch (error) {
    console.error('\n❌ Erro ao popular Firestore:', error);
    
    if (error.code === 5 || error.message.includes('NOT_FOUND')) {
      console.error('\n💡 SOLUÇÃO:');
      console.error('   O Firestore Database não foi criado no seu projeto Firebase.');
      console.error('   Siga os passos em: scripts/ATIVAR_FIRESTORE.md');
      console.error('   Ou acesse: https://console.firebase.google.com/project/molho-review-app/firestore');
      console.error('   Clique em "Criar banco de dados" e escolha "Modo de teste"');
    }
    
    throw error;
  }
}

populateFirestore()
  .then(() => {
    console.log('\n🎉 Script concluído com sucesso!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('\n💥 Erro fatal:', error.message);
    process.exit(1);
  });

