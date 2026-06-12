import 'page_speed_result.dart';

class ComparisonResult {
  final PageSpeedResult first;
  final PageSpeedResult second;

  ComparisonResult({
    required this.first,
    required this.second,
  });

  PageSpeedResult get winner {
    double firstAvg = (first.performanceScore + first.seoScore + first.accessibilityScore + first.bestPracticesScore) / 4;
    double secondAvg = (second.performanceScore + second.seoScore + second.accessibilityScore + second.bestPracticesScore) / 4;
    return firstAvg >= secondAvg ? first : second;
  }
}
