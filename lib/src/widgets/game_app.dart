import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../brick_breaker.dart';
import '../config.dart';
import 'game_over_overlay.dart';
import 'leaderboard_screen.dart';
import 'overlay_screen.dart';
import 'score_card.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final BrickBreaker game;

  @override
  void initState() {
    super.initState();
    game = BrickBreaker();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color(0xff184e77),
          displayColor: const Color(0xff184e77),
        ),
      ),
      home: _GameScreen(game: game),
    );
  }
}

class _GameScreen extends StatelessWidget {
  const _GameScreen({required this.game});

  final BrickBreaker game;

  void _showLeaderboard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LeaderboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffa9d6e5), Color(0xfff2e8cf)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: ScoreCard(score: game.score)),
                      ElevatedButton.icon(
                        onPressed: () => _showLeaderboard(context),
                        icon: const Icon(Icons.emoji_events, size: 20),
                        label: const Text('Top 5'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff184e77),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: FittedBox(
                      child: SizedBox(
                        width: gameWidth,
                        height: gameHeight,
                        child: GameWidget(
                          game: game,
                          overlayBuilderMap: {
                            PlayState.welcome.name: (context, game) =>
                                const OverlayScreen(
                                  title: 'TAP TO PLAY',
                                  subtitle: 'Use arrow keys or swipe',
                                ),
                            PlayState.gameOver.name: (context, game) =>
                                GameOverOverlay(
                                    score: (game as BrickBreaker).score.value),
                            PlayState.won.name: (context, game) =>
                                const OverlayScreen(
                                  title: 'Y O U   W O N ! ! !',
                                  subtitle: 'Tap to Play Again',
                                ),
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

