import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../providers/analyzer_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/score_ring.dart';
import '../models/page_speed_result.dart';

class ResultsDashboard extends StatefulWidget {
  const ResultsDashboard({super.key});

  @override
  State<ResultsDashboard> createState() => _ResultsDashboardState();
}

class _ResultsDashboardState extends State<ResultsDashboard> {
  String _activeTab = 'Performance';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnalyzerProvider>(context);
    final result = provider.currentResult;

    if (result == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          result.url,
          style: const TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded, color: AppColors.primary),
            onPressed: () => _copyResults(result),
            tooltip: 'Copy Results',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Score Section
            const Center(
              child: Text(
                'Overall Performance',
                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14, letterSpacing: 1),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Hero(
                tag: 'score_ring',
                child: ScoreRing(
                  score: result.performanceScore,
                  size: 180,
                  strokeWidth: 15,
                  showGlow: true,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Secondary Scores Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SmallScoreTile(label: 'SEO', score: result.seoScore),
                _SmallScoreTile(label: 'Accessibility', score: result.accessibilityScore),
                _SmallScoreTile(label: 'Best Practices', score: result.bestPracticesScore),
              ],
            ),
            const SizedBox(height: 40),

            // Core Web Vitals
            Text('Core Web Vitals', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                children: [
                  _MetricRow(label: 'First Contentful Paint', value: result.vitals.fcp),
                  const Divider(color: Colors.white10),
                  _MetricRow(label: 'Largest Contentful Paint', value: result.vitals.lcp),
                  const Divider(color: Colors.white10),
                  _MetricRow(label: 'Cumulative Layout Shift', value: result.vitals.cls),
                  const Divider(color: Colors.white10),
                  _MetricRow(label: 'Total Blocking Time', value: result.vitals.tbt),
                  const Divider(color: Colors.white10),
                  _MetricRow(label: 'Speed Index', value: result.vitals.speedIndex),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Audits Section
            Text('Opportunities & Audits', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            
            // Audit Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _AuditTabButton(
                    label: 'All',
                    isActive: _activeTab == 'All',
                    count: result.audits.length,
                    onTap: () => setState(() => _activeTab = 'All'),
                  ),
                  _AuditTabButton(
                    label: 'Failed',
                    isActive: _activeTab == 'Failed',
                    count: result.audits.where((a) => a.type == 'failed').length,
                    onTap: () => setState(() => _activeTab = 'Failed'),
                  ),
                  _AuditTabButton(
                    label: 'Passed',
                    isActive: _activeTab == 'Passed',
                    count: result.audits.where((a) => a.type == 'passed').length,
                    onTap: () => setState(() => _activeTab = 'Passed'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Audit List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _getFilteredAudits(result).length,
              itemBuilder: (context, index) {
                final audit = _getFilteredAudits(result)[index];
                return _AuditCard(audit: audit);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _copyResults(PageSpeedResult result) {
    final String text = '''
Website Speed Analysis
URL: ${result.url}
Strategy: ${result.strategy.toUpperCase()}
Date: ${result.timestamp}

SCORES:
Performance: ${(result.performanceScore * 100).toInt()}
SEO: ${(result.seoScore * 100).toInt()}
Accessibility: ${(result.accessibilityScore * 100).toInt()}
Best Practices: ${(result.bestPracticesScore * 100).toInt()}

CORE WEB VITALS:
FCP: ${result.vitals.fcp}
LCP: ${result.vitals.lcp}
CLS: ${result.vitals.cls}
TBT: ${result.vitals.tbt}
Speed Index: ${result.vitals.speedIndex}

Generated by Website Speed Analyzer
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Results copied to clipboard'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List<AuditItem> _getFilteredAudits(PageSpeedResult result) {
    if (_activeTab == 'Failed') return result.audits.where((a) => a.type == 'failed').toList();
    if (_activeTab == 'Passed') return result.audits.where((a) => a.type == 'passed').toList();
    return result.audits;
  }
}

class _SmallScoreTile extends StatelessWidget {
  final String label;
  final double score;

  const _SmallScoreTile({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScoreRing(score: score, size: 70, strokeWidth: 6),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _AuditTabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final int count;
  final VoidCallback onTap;

  const _AuditTabButton({
    required this.label,
    required this.isActive,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.white10,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuditCard extends StatefulWidget {
  final AuditItem audit;

  const _AuditCard({required this.audit});

  @override
  State<_AuditCard> createState() => _AuditCardState();
}

class _AuditCardState extends State<_AuditCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    Color statusColor = AppColors.green;
    if (widget.audit.type == 'failed') statusColor = AppColors.red;
    if (widget.audit.type == 'opportunity') statusColor = AppColors.yellow;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            leading: Icon(
              widget.audit.type == 'passed' ? Icons.check_circle_outline : Icons.error_outline,
              color: statusColor,
            ),
            title: Text(
              widget.audit.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.audit.displayValue.isNotEmpty)
                  Text(
                    widget.audit.displayValue,
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.audit.description,
                style: TextStyle(color: AppColors.onSurfaceVariant.withOpacity(0.7), fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
