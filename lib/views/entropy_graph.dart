import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EntropyGraph extends StatelessWidget {
  final List<double> entropies;
  final double currentEntropy;

  const EntropyGraph({
    Key? key,
    required this.entropies,
    required this.currentEntropy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Entropy Values of Players',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
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
                  sideTitles: SideTitles(showTitles: true, interval: 1),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Text('Participants'),
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              scatterSpots: [
                // blue dots
                for (var i = 0; i < entropies.length; i++)
                  ScatterSpot(
                    i.toDouble(),
                    entropies[i],
                    dotPainter: FlDotCirclePainter(radius: 6, color: Colors.blue),
                  ),
                // red square for the “current” participant
                ScatterSpot(
                  entropies.length.toDouble(),
                  currentEntropy,
                  dotPainter: FlDotSquarePainter(size: 16, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}