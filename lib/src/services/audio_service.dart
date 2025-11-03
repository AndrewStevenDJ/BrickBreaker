import 'package:audioplayers/audioplayers.dart';

/// Service to manage game audio including background music and sound effects
class AudioService {
  // Audio players
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  
  // Audio file paths
  static const String _backgroundMusic = 'audio/background_music.mp3';
  static const String _gameOverSound = 'audio/game_over.mp3';
  
  // State
  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;
  bool _isMusicPlaying = false;
  
  AudioService() {
    _initAudio();
  }
  
  void _initAudio() {
    // Configure music player to loop
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
    _musicPlayer.setVolume(0.5);
    
    // Configure SFX player
    _sfxPlayer.setVolume(0.7);
  }
  
  /// Start playing background music
  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled || _isMusicPlaying) return;
    
    try {
      await _musicPlayer.play(AssetSource(_backgroundMusic));
      _isMusicPlaying = true;
    } catch (e) {
      print('Error playing background music: $e');
    }
  }
  
  /// Stop background music
  Future<void> stopBackgroundMusic() async {
    await _musicPlayer.stop();
    _isMusicPlaying = false;
  }
  
  /// Pause background music
  Future<void> pauseBackgroundMusic() async {
    await _musicPlayer.pause();
    _isMusicPlaying = false;
  }
  
  /// Resume background music
  Future<void> resumeBackgroundMusic() async {
    if (!_isMusicEnabled) return;
    
    await _musicPlayer.resume();
    _isMusicPlaying = true;
  }
  
  /// Play game over sound effect
  Future<void> playGameOverSound() async {
    if (!_isSfxEnabled) return;
    
    try {
      await _sfxPlayer.play(AssetSource(_gameOverSound));
    } catch (e) {
      print('Error playing game over sound: $e');
    }
  }
  
  /// Enable or disable background music
  void toggleMusic(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled && _isMusicPlaying) {
      stopBackgroundMusic();
    }
  }
  
  /// Enable or disable sound effects
  void toggleSfx(bool enabled) {
    _isSfxEnabled = enabled;
  }
  
  /// Set music volume (0.0 to 1.0)
  Future<void> setMusicVolume(double volume) async {
    await _musicPlayer.setVolume(volume.clamp(0.0, 1.0));
  }
  
  /// Set SFX volume (0.0 to 1.0)
  Future<void> setSfxVolume(double volume) async {
    await _sfxPlayer.setVolume(volume.clamp(0.0, 1.0));
  }
  
  /// Dispose audio players
  void dispose() {
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
  }
}
