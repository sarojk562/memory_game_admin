import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EntropyGraph extends StatelessWidget {
  final List<double> entropies;
  final double currentEntropy;

  EntropyGraph({
    Key? key,
    List<double>? entropies,
    this.currentEntropy = 2.5,
  })  : entropies = entropies ??
      List.generate(
        15,
            (_) => double.parse((Random().nextDouble() * 4).toStringAsFixed(2)),
      ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Entropy Values of Players',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),

        Expanded(
          child: ScatterChart(
            ScatterChartData(
              minX: 0,
              maxX: entropies.length.toDouble() + 1,
              minY: 0,
              maxY: 4,

              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),

              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameWidget: const Text('Entropy Values'),
                  axisNameSize: 24,
                  sideTitles: SideTitles(showTitles: true, interval: 1),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Text('Participants'),
                  axisNameSize: 24,
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),

              scatterSpots: [
                // Blue circles for everyone else
                for (var i = 0; i < entropies.length; i++)
                  ScatterSpot(
                    i.toDouble(),
                    entropies[i],
                    dotPainter: FlDotCirclePainter(
                      radius: 6,
                      color: Colors.blue,
                      strokeWidth: 0,
                    ),
                  ),

                // Red square for the “current” participant
                ScatterSpot(
                  entropies.length.toDouble(),
                  currentEntropy,
                  dotPainter: FlDotSquarePainter(
                    size: 20,
                    color: Colors.red,
                    strokeWidth: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



class GameOverScreen extends StatefulWidget {
  final int duration;
  const GameOverScreen({super.key, required this.duration});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  late final List<double> _entropies;
  static const double _currentEntropy = 2.5;

  @override
  void initState() {
    super.initState();
    _entropies = List.generate(
      15,
          (_) => double.parse((Random().nextDouble() * 4).toStringAsFixed(2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    final durationText = widget.duration >= 60
        ? "${widget.duration ~/ 60}min ${widget.duration % 60}sec"
        : "${widget.duration}s";

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Congratulations! 🎉",
                      style: theme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(durationText, style: theme.displayMedium),
                  const SizedBox(height: 12),
                  Text(
                    "You've successfully completed the memory game. "
                        "Your sharp memory and quick thinking have helped you "
                        "emerge victorious. Keep up the good work and keep "
                        "challenging yourself.",
                    style: theme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // entropy‐vs‐participants graph
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: EntropyGraph(
                          entropies: _entropies,
                          currentEntropy: _currentEntropy,
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // the provided image
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSW2fBVs1O4NjEWuwvRdM83pFhes-Xm6bcxhw&s',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

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
