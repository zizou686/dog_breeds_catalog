# 🚀 Guía de Despliegue en Render

## Paso 1: Preparar el repositorio GitHub

```bash
git init
git add .
git commit -m "Initial commit: Flutter app + Spring Boot backend"
git branch -M main
git remote add origin https://github.com/tu-usuario/dog_breeds_catalog.git
git push -u origin main
```

## Paso 2: Desplegar en Render

### Opción A: Backend API (Spring Boot) - Recomendado

1. Ve a [render.com](https://render.com) y conecta tu repo
2. Crea un nuevo **Web Service**:
   - **Name**: dog-breeds-api
   - **Repository**: tu repositorio
   - **Branch**: main
   - **Runtime**: Docker
   - **Build Command**: (dejar en blanco, usa Dockerfile)
   - **Start Command**: (dejar en blanco)
   - **Region**: Oregon (o tu preferencia)

3. En **Environment Variables**, agrega:
   ```
   DATABASE_URL=jdbc:postgresql://your-host:25458/defaultdb?sslmode=require
   DB_USER=your_db_user
   DB_PASSWORD=your_db_password
   PORT=8080
   ```

4. Haz click en **Deploy**

### Opción B: Flutter Web - Alternativa

Si prefieres servir la app web estática:

```bash
flutter build web
# Los archivos estarán en build/web/
# Luego sube a Render como Static Site
```

## Paso 3: Actualizar la app Flutter para usar el backend

En **lib/services/dog_service.dart**, cambia:

```dart
const String apiBase = "https://tu-api-render.onrender.com/api";
```

En **lib/services/auth_service.dart**, cambia:

```dart
const String apiBase = "https://tu-api-render.onrender.com/api";
```

## Paso 4: Reconstruir la app Flutter

```bash
flutter clean
flutter pub get
flutter build web  # O flutter run -d web
```

## Endpoints disponibles

### Autenticación
- `POST /api/auth/register` - Registrar usuario
- `POST /api/auth/login` - Iniciar sesión

### Perros
- `GET /api/dog-breeds` - Obtener todos
- `GET /api/dog-breeds/{id}` - Obtener uno
- `POST /api/dog-breeds` - Crear
- `PUT /api/dog-breeds/{id}` - Actualizar
- `DELETE /api/dog-breeds/{id}` - Eliminar

## Swagger UI

Una vez desplegado, accede a:
```
https://tu-api-render.onrender.com/swagger-ui.html
```

## ⚠️ IMPORTANTE

✅ NUNCA incluyas credentials en el código  
✅ Siempre usa variables de entorno en Render  
✅ Cambia la contraseña de BD después de desplegar  
✅ Usa HTTPS en producción (Render lo hace automáticamente)
