import 'package:flutter/material.dart';
import 'package:flutter_memory_game/views/eye_tracking_screen.dart';
import 'package:flutter_memory_game/views/game_screen.dart';

class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({Key? key}) : super(key: key);

  @override
  _ModeSelectionScreenState createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  int _selectedLevel = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Mode')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EyeTrackingScreen()),
                );
              },
              child: const Text('Train Eye Tracking'),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<int>(
              value: _selectedLevel,
              decoration: const InputDecoration(
                labelText: 'Select Level',
                border: OutlineInputBorder(),
              ),
              items: [1, 2, 3]
                  .map((lvl) => DropdownMenuItem(
                value: lvl,
                child: Text('Level $lvl'),
              ))
                  .toList(),
              onChanged: (lvl) {
                if (lvl != null) setState(() => _selectedLevel = lvl);
              },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyFlipCardGame(level: _selectedLevel),
                  ),
                );
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
