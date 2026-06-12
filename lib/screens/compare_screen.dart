import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../providers/analyzer_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/score_ring.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final TextEditingController _url1Controller = TextEditingController();
  final TextEditingController _url2Controller = TextEditingController();
  String _strategy = 'mobile';

  void _compare() async {
    String url1 = _url1Controller.text.trim();
    String url2 = _url2Controller.text.trim();

    if (url1.isEmpty || url2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both URLs')),
      );
      return;
    }

    if (!url1.startsWith('http://') && !url1.startsWith('https://')) {
      url1 = 'https://$url1';
    }
    if (!url2.startsWith('http://') && !url2.startsWith('https://')) {
      url2 = 'https://$url2';
    }

    final provider = Provider.of<AnalyzerProvider>(context, listen: false);
    await provider.compareUrls(url1, url2, _strategy);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnalyzerProvider>(context);
    final comparison = provider.comparisonResult;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Websites'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GlassCard(
              child: Column(
                children: [
                  CustomTextField(
                    controller: _url1Controller,
                    hintText: 'Website 1 URL',
                    prefixIcon: Icons.looks_one,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _url2Controller,
                    hintText: 'Website 2 URL',
                    prefixIcon: Icons.looks_two,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _StrategyOption(
                        label: 'Mobile',
                        isActive: _strategy == 'mobile',
                        onTap: () => setState(() => _strategy = 'mobile'),
                      ),
                      const SizedBox(width: 12),
                      _StrategyOption(
                        label: 'Desktop',
                        isActive: _strategy == 'desktop',
                        onTap: () => setState(() => _strategy = 'desktop'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _compare,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: provider.isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text('COMPARE NOW', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            
            if (comparison != null && !provider.isLoading) ...[
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _ComparisonColumn(result: comparison.first, isWinner: comparison.winner == comparison.first)),
                  const SizedBox(width: 12),
                  Expanded(child: _ComparisonColumn(result: comparison.second, isWinner: comparison.winner == comparison.second)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StrategyOption extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _StrategyOption({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isActive ? AppColors.primary : Colors.white10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(color: isActive ? AppColors.primary : AppColors.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

class _ComparisonColumn extends StatelessWidget {
  final dynamic result;
  final bool isWinner;

  const _ComparisonColumn({required this.result, required this.isWinner});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isWinner)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.green.withOpacity(0.5)),
            ),
            child: const Text('WINNER', style: TextStyle(color: AppColors.green, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                result.url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ScoreRing(score: result.performanceScore, size: 80, strokeWidth: 8),
              const SizedBox(height: 24),
              _SmallMetric(label: 'SEO', score: result.seoScore),
              const SizedBox(height: 12),
              _SmallMetric(label: 'Accessibility', score: result.accessibilityScore),
              const SizedBox(height: 12),
              _SmallMetric(label: 'Best Practices', score: result.bestPracticesScore),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallMetric extends StatelessWidget {
  final String label;
  final double score;

  const _SmallMetric({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
        Text(
          '${(score * 100).toInt()}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: score >= 0.9 ? AppColors.green : (score >= 0.5 ? AppColors.yellow : AppColors.red),
          ),
        ),
      ],
    );
  }
}
