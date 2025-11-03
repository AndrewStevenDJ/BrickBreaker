# Audio Assets

Esta carpeta contiene los archivos de audio del juego Brick Breaker.

## Archivos Requeridos

Coloca tus archivos de audio en esta carpeta con los siguientes nombres:

### 1. Música de Fondo
- **Nombre del archivo**: `background_music.mp3`
- **Descripción**: Música que se reproduce durante el juego
- **Cuándo se reproduce**: Inicia cuando el jugador comienza a jugar (presiona Space/Enter o toca la pantalla)
- **Características**: Se reproduce en loop continuo mientras el jugador está jugando

### 2. Sonido de Game Over
- **Nombre del archivo**: `game_over.mp3`
- **Descripción**: Efecto de sonido cuando el jugador pierde
- **Cuándo se reproduce**: Se reproduce cuando la pelota cae al fondo y el juego termina
- **Características**: Se reproduce una sola vez

## Formatos Soportados

El paquete `audioplayers` soporta los siguientes formatos:
- MP3 (recomendado para música)
- WAV (recomendado para efectos de sonido cortos)
- OGG
- AAC
- M4A

## Instrucciones

1. Copia tu archivo de música de fondo y renómbralo a `background_music.mp3`
2. Copia tu archivo de sonido de game over y renómbralo a `game_over.mp3`
3. Coloca ambos archivos en esta carpeta: `assets/audio/`
4. Ejecuta `flutter pub get` si es necesario
5. ¡Listo! La música se reproducirá automáticamente cuando juegues

## Estructura

```
assets/
  audio/
    background_music.mp3  <- Tu música de fondo aquí
    game_over.mp3         <- Tu sonido de game over aquí
```

## Controles de Audio (Implementados)

El sistema de audio incluye:
- ✅ Reproducción automática de música al iniciar el juego
- ✅ Detención de música cuando el juego termina (win o game over)
- ✅ Reproducción de sonido especial al perder
- ✅ La música se reproduce en loop continuo
- ✅ Control de volumen independiente para música y efectos

## Notas Técnicas

- Volumen de música: 50% (0.5)
- Volumen de efectos: 70% (0.7)
- La música se detiene automáticamente en PlayState.gameOver y PlayState.won
- El AudioService se limpia correctamente cuando se cierra el juego
