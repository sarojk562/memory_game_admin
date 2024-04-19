import 'dart:developer';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends StatefulWidget {
  final int duration;
  const GameOverScreen({super.key, required this.duration});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  bool isConfettiPlaying = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Congratulations! 🎉",
                    style: theme.bodyLarge,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    text: "",
                    style: theme.bodyLarge,
                    children: [
                      if (widget.duration >= 60)
                        TextSpan(
                          text:
                              "${(widget.duration ~/ 60)}min ${(widget.duration % 60)}sec",
                          style: theme.displaySmall,
                        ),
                      if (widget.duration < 60)
                        TextSpan(
                          text: "${widget.duration} seconds",
                          style: theme.displaySmall,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "",
                    style: theme.bodyLarge,
                    children: [
                      TextSpan(
                        text:
                            "You've successfully completed the memory game. Your sharp memory and quick thinking have helped you emerge victorious. Keep up the good work and keep challenging yourself",
                        style: theme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Replay Game"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
