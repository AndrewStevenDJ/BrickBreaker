import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/scores_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final ScoresService _scoresService = ScoresService();
  List<Score>? _topScores;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTopScores();
  }

  Future<void> _loadTopScores() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final scores = await _scoresService.getTopScores();
      setState(() {
        _topScores = scores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load leaderboard';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: const Color(0xff184e77),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffa9d6e5), Color(0xfff2e8cf)],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadTopScores,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _topScores == null || _topScores!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.emoji_events_outlined,
                              size: 64,
                              color: Color(0xff184e77),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No scores yet!',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Be the first to play!',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTopScores,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _topScores!.length,
                          itemBuilder: (context, index) {
                            final score = _topScores![index];
                            final position = index + 1;
                            
                            return _LeaderboardTile(
                              position: position,
                              score: score,
                            ).animate().fadeIn(
                              duration: 300.ms,
                              delay: (index * 100).ms,
                            ).slideX(
                              begin: -0.2,
                              end: 0,
                              duration: 300.ms,
                              delay: (index * 100).ms,
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  const _LeaderboardTile({
    required this.position,
    required this.score,
  });

  final int position;
  final Score score;

  Color _getPositionColor() {
    switch (position) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.orange.shade300;
      default:
        return const Color(0xff184e77);
    }
  }

  IconData _getPositionIcon() {
    switch (position) {
      case 1:
        return Icons.emoji_events;
      case 2:
      case 3:
        return Icons.workspace_premium;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: position <= 3 ? 8 : 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getPositionColor(),
          child: position <= 3
              ? Icon(_getPositionIcon(), color: Colors.white)
              : Text(
                  '$position',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        title: Text(
          score.playerName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: position <= 3 ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xff184e77),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${score.score}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
