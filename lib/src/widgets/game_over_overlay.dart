import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'save_score_dialog.dart';

class GameOverOverlay extends StatefulWidget {
  const GameOverOverlay({super.key, required this.score});

  final int score;

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    // Show the save score dialog after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !_dialogShown && widget.score > 0) {
        _dialogShown = true;
        _showSaveScoreDialog();
      }
    });
  }

  Future<void> _showSaveScoreDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SaveScoreDialog(score: widget.score),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'G A M E   O V E R',
            style: Theme.of(context).textTheme.headlineLarge,
          ).animate().slideY(duration: 750.ms, begin: -3, end: 0),
          const SizedBox(height: 16),
          Text(
            'Tap to Play Again',
            style: Theme.of(context).textTheme.headlineSmall,
          )
              .animate(onPlay: (controller) => controller.repeat())
              .fadeIn(duration: 1.seconds)
              .then()
              .fadeOut(duration: 1.seconds),
        ],
      ),
    );
  }
}
