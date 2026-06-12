import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../providers/analyzer_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<AnalyzerProvider>(
        builder: (context, provider, child) {
          if (provider.history.isEmpty) {
            return const Center(
              child: Text('No history available', style: TextStyle(color: AppColors.onSurfaceVariant)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: provider.history.length,
            itemBuilder: (context, index) {
              final item = provider.history[index];
              return Dismissible(
                key: Key(item.timestamp.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => provider.deleteHistoryItem(index),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: AppColors.errorContainer,
                  child: const Icon(Icons.delete, color: AppColors.error),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: item.faviconUrl != null
                            ? Image.network(item.faviconUrl!)
                            : const Icon(Icons.public, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.url,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${item.timestamp.day}/${item.timestamp.month}/${item.timestamp.year} ${item.timestamp.hour}:${item.timestamp.minute}',
                              style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      _ScoreBadge(score: item.performanceScore),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final double score;

  const _ScoreBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    Color color = AppColors.green;
    if (score < 0.9) color = AppColors.yellow;
    if (score < 0.5) color = AppColors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '${(score * 100).toInt()}',
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
