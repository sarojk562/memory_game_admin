import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/user_stats.dart';
import 'entropy_graph.dart';

class GameOverScreen extends StatefulWidget {
  final int duration;
  final int userLevel;

  const GameOverScreen({
    Key? key,
    required this.duration,
    required this.userLevel,
  }) : super(key: key);

  @override
  _GameOverScreenState createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  UserStats? _stats;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    final uri = Uri.parse(
      'https://us-central1-cardmatch-e7f12.cloudfunctions.net'
          '/app/admin/getUserStats?user_level=${widget.userLevel}',
    );
    try {
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final jsonBody = json.decode(resp.body) as Map<String, dynamic>;
        setState(() {
          _stats = UserStats.fromJson(jsonBody);
          _loading = false;
        });
      } else {
        throw Exception('Server returned ${resp.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final minutes = widget.duration ~/ 60;
    final seconds = widget.duration % 60;
    final durationText = minutes > 0
        ? "$minutes min $seconds sec"
        : "${widget.duration}s";

    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _stats == null) {
      return Scaffold(
        body: Center(child: Text('Error loading stats:\n$_error')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Congratulations! 🎉", style: theme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(durationText, style: theme.displayMedium),
                  const SizedBox(height: 12),
                  Text(
                    "You've successfully completed the memory game. "
                        "Your sharp memory and quick thinking have helped you "
                        "emerge victorious. Keep up the good work!",
                    style: theme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // graph + heatmap
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: EntropyGraph(
                        entropies: _stats!.entropyStats,
                        currentEntropy: _stats!.currentEntropy,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Image.network(
                        _stats!.heatMapImageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // replay button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Replay Game"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
