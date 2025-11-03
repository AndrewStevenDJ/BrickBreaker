# Configuración de Supabase para Brick Breaker

Este documento explica cómo configurar Supabase para guardar y mostrar las puntuaciones del juego.

## Paso 1: Crear un proyecto en Supabase

1. Ve a [https://supabase.com](https://supabase.com) y crea una cuenta gratuita
2. Crea un nuevo proyecto
3. Anota la URL del proyecto y la clave anónima (anon key)

## Paso 2: Crear la tabla de puntuaciones

1. En el panel de Supabase, ve a la sección **SQL Editor**
2. Ejecuta el siguiente script SQL:

```sql
-- Create the scores table
CREATE TABLE scores (
  id BIGSERIAL PRIMARY KEY,
  player_name TEXT NOT NULL,
  score INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

-- Create an index on score for faster queries
CREATE INDEX idx_scores_score ON scores(score DESC);

-- Enable Row Level Security
ALTER TABLE scores ENABLE ROW LEVEL SECURITY;

-- Create a policy that allows anyone to read scores
CREATE POLICY "Allow public read access" ON scores
  FOR SELECT
  TO public
  USING (true);

-- Create a policy that allows anyone to insert scores
CREATE POLICY "Allow public insert access" ON scores
  FOR INSERT
  TO public
  WITH CHECK (true);
```

## Paso 3: Configurar las credenciales en la app

1. Abre el archivo `lib/src/supabase_config.dart`
2. Reemplaza `YOUR_SUPABASE_URL` con la URL de tu proyecto de Supabase
3. Reemplaza `YOUR_SUPABASE_ANON_KEY` con tu clave anónima

Ejemplo:
```dart
const String supabaseUrl = 'https://abcdefghijk.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODk1NzY0MDAsImV4cCI6MjAwNTI1MjQwMH0.xxxxx';
```

## Paso 4: Ejecutar la app

```powershell
flutter clean
flutter pub get
flutter run
```

## Funcionalidades implementadas

### Guardar Puntuación
- Cuando pierdes el juego, aparece automáticamente un diálogo pidiendo tu nombre
- Puedes ingresar hasta 20 caracteres
- La puntuación se guarda en Supabase con tu nombre y la fecha/hora

### Ver Top 5
- Botón flotante "Top 5" en la esquina inferior derecha
- Muestra las 5 mejores puntuaciones de todos los tiempos
- Iconos especiales para los 3 primeros lugares:
  - 🏆 Oro para el 1er lugar
  - 🥈 Plata para el 2do lugar
  - 🥉 Bronce para el 3er lugar
- Pull to refresh para actualizar la lista

## Estructura de la base de datos

### Tabla `scores`
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | BIGSERIAL | ID único (autoincremental) |
| player_name | TEXT | Nombre del jugador |
| score | INTEGER | Puntuación obtenida |
| created_at | TIMESTAMP | Fecha y hora de creación |

## Seguridad

El proyecto usa Row Level Security (RLS) con las siguientes políticas:
- **Lectura pública**: Cualquiera puede ver todas las puntuaciones
- **Escritura pública**: Cualquiera puede insertar nuevas puntuaciones
- **Sin actualización/eliminación**: Los registros no se pueden modificar o eliminar desde la app

## Solución de problemas

### Error: "Failed to save score"
- Verifica que las credenciales en `supabase_config.dart` sean correctas
- Verifica que la tabla `scores` existe en tu proyecto de Supabase
- Verifica que las políticas RLS estén configuradas correctamente

### Error: "Failed to fetch top scores"
- Verifica tu conexión a Internet
- Verifica que la URL de Supabase sea correcta
- Verifica los permisos de Android/iOS para acceso a Internet

### La app no compila
- Ejecuta `flutter clean` y luego `flutter pub get`
- Verifica que tienes las dependencias correctas en `pubspec.yaml`

## Recursos adicionales

- [Documentación de Supabase](https://supabase.com/docs)
- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart/introduction)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
