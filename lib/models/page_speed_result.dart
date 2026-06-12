class PageSpeedResult {
  final String url;
  final String strategy;
  final double performanceScore;
  final double seoScore;
  final double accessibilityScore;
  final double bestPracticesScore;
  final CoreWebVitals vitals;
  final List<AuditItem> audits;
  final DateTime timestamp;

  PageSpeedResult({
    required this.url,
    required this.strategy,
    required this.performanceScore,
    required this.seoScore,
    required this.accessibilityScore,
    required this.bestPracticesScore,
    required this.vitals,
    required this.audits,
    required this.timestamp,
  });

  factory PageSpeedResult.fromJson(Map<String, dynamic> json, String url, String strategy) {
    final lighthouse = json['lighthouseResult'] ?? {};
    final categories = lighthouse['categories'] ?? {};
    
    double getScore(String category) {
      if (categories[category] != null && categories[category]['score'] != null) {
        return (categories[category]['score'] as num).toDouble();
      }
      return 0.0;
    }

    return PageSpeedResult(
      url: url,
      strategy: strategy,
      performanceScore: getScore('performance'),
      seoScore: getScore('seo'),
      accessibilityScore: getScore('accessibility'),
      bestPracticesScore: getScore('best-practices'),
      vitals: CoreWebVitals.fromLighthouse(lighthouse),
      audits: lighthouse['audits'] != null 
          ? (lighthouse['audits'] as Map<String, dynamic>)
              .entries
              .map((e) => AuditItem.fromJson(e.key, e.value))
              .where((element) => element.score != null)
              .toList()
          : [],
      timestamp: DateTime.now(),
    );
  }
}

class CoreWebVitals {
  final String fcp;
  final String lcp;
  final String cls;
  final String tbt;
  final String speedIndex;

  CoreWebVitals({
    required this.fcp,
    required this.lcp,
    required this.cls,
    required this.tbt,
    required this.speedIndex,
  });

  factory CoreWebVitals.fromLighthouse(Map<String, dynamic> lighthouse) {
    final audits = lighthouse['audits'] ?? {};
    
    String getDisplayValue(String auditId) {
      if (audits[auditId] != null && audits[auditId]['displayValue'] != null) {
        return audits[auditId]['displayValue'];
      }
      return 'N/A';
    }

    return CoreWebVitals(
      fcp: getDisplayValue('first-contentful-paint'),
      lcp: getDisplayValue('largest-contentful-paint'),
      cls: getDisplayValue('cumulative-layout-shift'),
      tbt: getDisplayValue('total-blocking-time'),
      speedIndex: getDisplayValue('speed-index'),
    );
  }
}

class AuditItem {
  final String id;
  final String title;
  final String description;
  final double? score;
  final String displayValue;
  final String type; // 'passed', 'failed', 'opportunity', 'diagnostic'

  AuditItem({
    required this.id,
    required this.title,
    required this.description,
    this.score,
    required this.displayValue,
    required this.type,
  });

  factory AuditItem.fromJson(String id, Map<String, dynamic> json) {
    double? score = json['score'] != null ? (json['score'] as num).toDouble() : null;
    String type = 'diagnostic';
    if (score != null) {
      if (score >= 0.9) {
        type = 'passed';
      } else if (score < 0.9 && score >= 0.5) {
        type = 'opportunity';
      } else {
        type = 'failed';
      }
    }

    return AuditItem(
      id: id,
      title: json['title'] ?? id,
      description: json['description'] ?? '',
      score: score,
      displayValue: json['displayValue'] ?? '',
      type: type,
    );
  }
}
