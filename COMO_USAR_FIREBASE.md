# 🔥 Como Usar - Salvar Estabelecimentos no Firebase

## ⚡ Configuração Rápida (IMPORTANTE)

### 1. Configure as Regras do Firebase Storage

Para permitir uploads, você precisa atualizar as regras:

1. Acesse: https://console.firebase.google.com/
2. Selecione o projeto: **molho-review-app**
3. Vá em **Storage** → **Rules**
4. Cole as regras abaixo:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if true;
      allow write: if true;  // TEMPORÁRIO para desenvolvimento
    }
  }
}
```

5. Clique em **Publish**

⚠️ **IMPORTANTE**: Em produção, você deve restringir a escrita apenas para usuários autenticados.

### 2. Configure as Regras do Firestore (se necessário)

1. Acesse **Firestore Database** → **Rules**
2. Certifique-se que permite escrita:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /merchants/{document} {
      allow read: if true;
      allow write: if true;  // TEMPORÁRIO para desenvolvimento
    }
  }
}
```

3. Clique em **Publish**

## 🎯 Como Usar no App

### Passo 1: Abrir o Formulário
1. Abra o app no simulador/dispositivo
2. Na tela inicial, clique no botão **+** (canto superior direito)

### Passo 2: Preencher os Dados

#### Campos Obrigatórios:
- ✅ **Nome do estabelecimento**
- ✅ **Tipo** (escolha um dos 10 tipos)
- ✅ **Estilo** (escolha um dos 10 estilos)
- ✅ **Endereço completo**
  - Depois de digitar, clique em **"Buscar Coordenadas"**
  - Aguarde o ✓ verde aparecer
- ✅ **Imagem de capa** (clique em "Adicionar Imagem de Capa")

#### Campos Opcionais:
- 📝 **Descrição** (até 1000 caracteres)
- ⭐ **Nota** (1 a 5 estrelas)
- 🕐 **Horário de funcionamento** (configure cada dia)
- 🖼️ **Galeria de imagens** (até 10 fotos)

### Passo 3: Salvar

1. Quando todos os campos obrigatórios estiverem preenchidos, o botão **"Criar Estabelecimento"** ficará habilitado
2. Clique no botão
3. Aguarde o upload (você verá "Salvando...")
4. Pronto! ✅

## 📊 Verificar no Firebase

### Ver as Imagens no Storage:

1. Acesse: https://console.firebase.google.com/
2. Vá em **Storage** → **Files**
3. Navegue para: `merchants/[merchantId]/`
4. Você verá:
   - `header_[uuid].jpg` - Imagem de capa
   - `gallery_[uuid].jpg` - Imagens da galeria

### Ver os Dados no Firestore:

1. Vá em **Firestore Database**
2. Abra a coleção **merchants**
3. Você verá todos os estabelecimentos criados
4. Clique em um documento para ver todos os campos

## 🐛 Solução de Problemas

### "Erro ao salvar" aparece

**Causa 1: Regras do Firebase não permitem escrita**
- ✅ Solução: Configure as regras conforme mostrado acima

**Causa 2: Firebase não inicializado**
- ✅ Solução: Certifique-se que o `GoogleService-Info.plist` está configurado

**Causa 3: Internet desconectada**
- ✅ Solução: Verifique sua conexão

### Coordenadas não são encontradas

**Causa: Endereço incompleto ou inválido**
- ✅ Solução: Digite o endereço completo com rua, número e cidade
- Exemplo: "Av Paulista, 1578 - Bela Vista, São Paulo - SP"

### Botão "Criar Estabelecimento" está desabilitado

**Causa: Campos obrigatórios não preenchidos**
- ✅ Verifique se preencheu:
  - Nome
  - Endereço
  - Coordenadas (botão "Buscar Coordenadas")
  - Imagem de capa

## 📱 Teste Completo

### Criar um Estabelecimento de Teste:

```
Nome: Pizzaria Roma Teste
Tipo: Pizzaria
Estilo: Aconchegante
Descrição: Uma pizzaria deliciosa com forno a lenha
Endereço: Av Paulista, 1578 - São Paulo, SP
[Buscar Coordenadas] ← Aguarde o ✓
Nota: ⭐⭐⭐⭐⭐
Horários:
  Segunda: 18:00 às 23:00
  Terça: 18:00 às 23:00
  ... (configure os outros dias)
Imagem de Capa: [Selecione uma foto]
Galeria: [Adicione 2-3 fotos]

[Criar Estabelecimento] ← Click aqui
```

Aguarde alguns segundos e pronto! O estabelecimento estará salvo no Firebase.

## 🎉 Sucesso!

Se tudo funcionou, você verá:
- ✅ O formulário fecha automaticamente
- ✅ As imagens aparecem no Firebase Storage
- ✅ O documento aparece no Firestore
- ✅ O estabelecimento aparece na lista (quando implementar a atualização da lista)

## 📝 Logs no Xcode

Para acompanhar o processo, observe o console do Xcode:

```
🔄 Iniciando upload de imagens...
✅ Header image uploaded: gs://...
✅ Gallery images uploaded: 3 images
🔄 Salvando no Firestore...
✅ Merchant salvo com sucesso!
```

---

**Pronto para usar!** 🚀

Se tiver qualquer dúvida, verifique o arquivo `FIREBASE_INTEGRATION.md` para detalhes técnicos completos.

