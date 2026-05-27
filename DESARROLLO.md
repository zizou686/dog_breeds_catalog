# 🐕 Dog Breeds Catalog - Full Stack App

Aplicación Flutter con backend Spring Boot para gestionar un catálogo de razas de perros.

## 📋 Tecnologías

- **Frontend**: Flutter (Web/Mobile/Desktop)
- **Backend**: Java 17 + Spring Boot 3.3
- **Base de Datos**: PostgreSQL (Aiven Cloud)
- **Deployment**: Render.com

## 🚀 Deployment en Render

### Requisitos
- GitHub cuenta conectada con Render
- Credenciales de PostgreSQL (Aiven)

### Paso 1: Subir a GitHub

```bash
# En la raíz del proyecto
git init
git add .
git commit -m "Initial commit: Dog Breeds Catalog"
git branch -M main
git remote add origin https://github.com/tu-usuario/dog_breeds_catalog.git
git push -u origin main
```

### Paso 2: Desplegar Backend en Render

1. Ve a [render.com](https://render.com)
2. Conecta tu repositorio GitHub
3. Crea un nuevo **Web Service**:
   - **Name**: dog-breeds-api
   - **Runtime**: Docker
   - **Build Command**: (dejar en blanco)
   - **Start Command**: (dejar en blanco)

4. En **Environment Variables**, agrega:
```
DATABASE_URL=jdbc:postgresql://your-host:25458/defaultdb?sslmode=require
DB_USER=your_db_user
DB_PASSWORD=your_db_password
PORT=8080
```

5. Click en **Deploy**

### Paso 3: Actualizar Flutter para usar API

Actualiza estos archivos con tu URL de Render:

**lib/services/dog_service.dart**:
```dart
const String apiBase = "https://tu-api-en-render.onrender.com/api";
```

**lib/services/auth_service.dart**:
```dart
const String apiBase = "https://tu-api-en-render.onrender.com/api";
```

### Paso 4: Reconstruir y desplegar Flutter Web

```bash
flutter clean
flutter pub get
flutter build web
```

Luego sube `build/web/` a Render como Static Site.

## 📚 API Endpoints

### Autenticación
```
POST   /api/auth/register      # Registrar usuario
POST   /api/auth/login         # Iniciar sesión
```

### Perros
```
GET    /api/dog-breeds         # Obtener todos
GET    /api/dog-breeds/{id}    # Obtener uno
POST   /api/dog-breeds         # Crear
PUT    /api/dog-breeds/{id}    # Actualizar
DELETE /api/dog-breeds/{id}    # Eliminar
```

## 🔗 URLs en Producción

- **Backend API**: https://tu-api-en-render.onrender.com
- **Swagger UI**: https://tu-api-en-render.onrender.com/swagger-ui.html
- **Frontend**: https://tu-app-web.onrender.com

## 🛠️ Desarrollo Local

### Correr Backend
```bash
cd backend
mvn spring-boot:run
```

### Correr Frontend
```bash
flutter run -d web
# o
flutter run -d chrome
```

## 🗂️ Estructura de Carpetas

```
dog_breeds_catalog/
├── lib/                    # App Flutter
│   ├── main.dart
│   ├── models/
│   ├── services/
│   └── screens/
├── backend/               # API Spring Boot
│   ├── src/
│   ├── pom.xml
│   └── Dockerfile
├── web/                   # Web assets
├── android/               # Android app
├── ios/                   # iOS app
└── pubspec.yaml          # Dependencias Flutter
```

## ⚠️ Seguridad

✅ Nunca incluyas credenciales en código  
✅ Usa variables de entorno en Render  
✅ Cambia contraseña de DB después de desplegar  
✅ Revisa `.gitignore` antes de hacer push

## 📝 Notas

- La app Flutter llama a los endpoints del backend
- Las credenciales de BD están en Render env vars
- El Dockerfile compila automáticamente con Maven
- Base de datos se inicializa automáticamente

## 📞 Soporte

Para más info, consulta [DEPLOY_RENDER.md](./DEPLOY_RENDER.md)
