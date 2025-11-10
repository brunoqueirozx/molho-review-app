# Configuração do Firebase Storage para Imagens

## 🔧 Problema Identificado

As URLs das imagens no Firestore estão no formato `gs://` que não pode ser acessado diretamente pelo `AsyncImage` do SwiftUI.

### ❌ Formato Incorreto
```
gs://molho-review-app.firebasestorage.app/guarita-bebida.png
```

### ✅ Formato Correto (Convertido Automaticamente)
```
https://firebasestorage.googleapis.com/v0/b/molho-review-app.firebasestorage.app/o/guarita-bebida.png?alt=media
```

## 🚀 Solução Implementada

O app agora **converte automaticamente** as URLs `gs://` para URLs HTTP acessíveis.

## 🔒 Configurar Permissões do Firebase Storage

Para que as imagens sejam acessíveis publicamente, você precisa configurar as regras de segurança:

### 1. Acesse o Firebase Console
- Vá para: https://console.firebase.google.com/
- Selecione o projeto: `molho-review-app`
- Navegue para **Storage** no menu lateral

### 2. Configure as Regras de Segurança
Clique em **Rules** e use esta configuração:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Permitir leitura pública de todas as imagens
    match /{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null; // apenas usuários autenticados podem fazer upload
    }
  }
}
```

### 3. Publique as Regras
Clique em **Publish** para salvar.

## 📝 Como Adicionar Imagens no Firestore

### Opção 1: Usar URLs gs:// (Recomendado)
O app converte automaticamente:

```json
{
  "name": "Restaurante Exemplo",
  "headerImageUrl": "gs://molho-review-app.firebasestorage.app/restaurante-header.jpg",
  "galleryImages": [
    "gs://molho-review-app.firebasestorage.app/foto1.jpg",
    "gs://molho-review-app.firebasestorage.app/foto2.jpg",
    "gs://molho-review-app.firebasestorage.app/foto3.jpg"
  ]
}
```

### Opção 2: Usar URLs HTTP Diretamente
Você também pode usar URLs HTTP diretas:

```json
{
  "name": "Restaurante Exemplo",
  "headerImageUrl": "https://firebasestorage.googleapis.com/v0/b/molho-review-app.firebasestorage.app/o/restaurante-header.jpg?alt=media",
  "galleryImages": [
    "https://firebasestorage.googleapis.com/v0/b/molho-review-app.firebasestorage.app/o/foto1.jpg?alt=media",
    "https://firebasestorage.googleapis.com/v0/b/molho-review-app.firebasestorage.app/o/foto2.jpg?alt=media"
  ]
}
```

## 🎨 Estrutura da Galeria

A galeria suporta:
- **1 imagem grande** (220x220px) - primeira do array
- **6 imagens pequenas** (107x106px cada) - próximas 6 do array
- **Total visível**: 7 imagens
- **Array suporta**: ilimitadas imagens

## 🔍 Como Fazer Upload de Imagens

### Via Firebase Console
1. Vá para **Storage** > **Files**
2. Clique em **Upload file**
3. Selecione a imagem
4. Após o upload, copie o caminho (ex: `guarita-bebida.png`)
5. Use no Firestore como: `gs://molho-review-app.firebasestorage.app/guarita-bebida.png`

### Via Código (Futuro)
```swift
// TODO: Implementar upload de imagens via código
```

## ✅ Verificação

Execute o app e observe os logs no console do Xcode:

```
🔄 Converteu: gs://molho-review-app.firebasestorage.app/guarita-bebida.png
   ➡️ Para: https://firebasestorage.googleapis.com/v0/b/molho-review-app.firebasestorage.app/o/guarita-bebida.png?alt=media

🖼️ galleryImages encontrado: 3 imagens
   ✅ URLs convertidas para HTTP:
   [0]: https://...
   [1]: https://...
   [2]: https://...
```

## 🐛 Troubleshooting

### As imagens não aparecem?
1. **Verifique as regras de segurança** do Storage (deve permitir leitura pública)
2. **Verifique o console do Xcode** para erros de carregamento
3. **Teste a URL manualmente** no navegador
4. **Certifique-se que o arquivo existe** no Storage

### Erro 403 (Forbidden)?
- As regras de segurança não estão permitindo leitura pública
- Configure conforme instruções acima

### Imagens aparecem mas depois desaparecem?
- Pode ser problema de cache
- Reinicie o app

