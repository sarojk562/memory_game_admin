import 'package:flutter/material.dart';
import 'package:flutter_memory_game/views/eye_tracking_screen.dart';
import 'package:flutter_memory_game/views/game_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Mode')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),  // add some side padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,     // <–– stretch children
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyFlipCardGame()),
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
