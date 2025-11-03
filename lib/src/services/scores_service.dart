import 'package:supabase_flutter/supabase_flutter.dart';

class Score {
  final int id;
  final String playerName;
  final int score;
  final DateTime createdAt;

  Score({
    required this.id,
    required this.playerName,
    required this.score,
    required this.createdAt,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      id: json['id'] as int,
      playerName: json['player_name'] as String,
      score: json['score'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player_name': playerName,
      'score': score,
    };
  }
}

class ScoresService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tableName = 'scores';

  /// Save a new score to the database
  Future<void> saveScore({
    required String playerName,
    required int score,
  }) async {
    try {
      await _supabase.from(_tableName).insert({
        'player_name': playerName,
        'score': score,
      });
    } catch (e) {
      throw Exception('Failed to save score: $e');
    }
  }

  /// Get the top 5 scores from the database
  Future<List<Score>> getTopScores({int limit = 5}) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .order('score', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => Score.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch top scores: $e');
    }
  }

  /// Check if a score would be in the top 5
  Future<bool> isTopScore(int score) async {
    try {
      final topScores = await getTopScores();
      if (topScores.isEmpty || topScores.length < 5) {
        return true;
      }
      return score > topScores.last.score;
    } catch (e) {
      return false;
    }
  }
}
