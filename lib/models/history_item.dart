import 'dart:convert';

class HistoryItem {
  final String url;
  final DateTime timestamp;
  final double performanceScore;
  final double seoScore;
  final double accessibilityScore;
  final double bestPracticesScore;
  final String? faviconUrl;

  HistoryItem({
    required this.url,
    required this.timestamp,
    required this.performanceScore,
    required this.seoScore,
    required this.accessibilityScore,
    required this.bestPracticesScore,
    this.faviconUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'timestamp': timestamp.toIso8601String(),
      'performanceScore': performanceScore,
      'seoScore': seoScore,
      'accessibilityScore': accessibilityScore,
      'bestPracticesScore': bestPracticesScore,
      'faviconUrl': faviconUrl,
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      url: json['url'],
      timestamp: DateTime.parse(json['timestamp']),
      performanceScore: json['performanceScore'],
      seoScore: json['seoScore'],
      accessibilityScore: json['accessibilityScore'],
      bestPracticesScore: json['bestPracticesScore'],
      faviconUrl: json['faviconUrl'],
    );
  }
}
