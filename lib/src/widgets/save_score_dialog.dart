import 'package:flutter/material.dart';
import '../services/scores_service.dart';

class SaveScoreDialog extends StatefulWidget {
  const SaveScoreDialog({super.key, required this.score});

  final int score;

  @override
  State<SaveScoreDialog> createState() => _SaveScoreDialogState();
}

class _SaveScoreDialogState extends State<SaveScoreDialog> {
  final TextEditingController _nameController = TextEditingController();
  final ScoresService _scoresService = ScoresService();
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveScore() async {
    final name = _nameController.text.trim();
    
    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your name';
      });
      return;
    }

    if (name.length > 20) {
      setState(() {
        _errorMessage = 'Name is too long (max 20 characters)';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await _scoresService.saveScore(
        playerName: name,
        score: widget.score,
      );
      
      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Score saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Failed to save score. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Game Over!',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Score: ${widget.score}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xff1e6091),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            enabled: !_isSaving,
            decoration: InputDecoration(
              labelText: 'Enter your name',
              hintText: 'Player name',
              border: const OutlineInputBorder(),
              errorText: _errorMessage,
            ),
            maxLength: 20,
            textCapitalization: TextCapitalization.words,
            onSubmitted: (_) => _saveScore(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Skip'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveScore,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save Score'),
        ),
      ],
    );
  }
}
