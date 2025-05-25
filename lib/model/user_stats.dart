class UserStats {
  final List<double> entropyStats;
  final double currentEntropy;
  final String heatMapImageUrl;

  UserStats({
    required this.entropyStats,
    required this.currentEntropy,
    required this.heatMapImageUrl,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    final d = json['data'] as Map<String, dynamic>;
    return UserStats(
      entropyStats: (d['entropy_stats'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      currentEntropy: (d['current_entropy'] as num).toDouble(),
      heatMapImageUrl: d['heat_map_image'] as String,
    );
  }
}