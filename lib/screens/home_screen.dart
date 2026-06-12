import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../providers/analyzer_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/custom_text_field.dart';
import 'results_dashboard.dart';
import 'compare_screen.dart';
import 'history_screen.dart';
import 'about_screen.dart';
import '../models/history_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  String _strategy = 'mobile';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _analyze() async {
    String url = _urlController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL')),
      );
      return;
    }

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    if (!Uri.parse(url).isAbsolute) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid URL')),
      );
      return;
    }

    final provider = Provider.of<AnalyzerProvider>(context, listen: false);
    await provider.analyzeUrl(url, _strategy);
    
    if (provider.error != null) {
      _showErrorDialog(provider.error!);
    } else if (provider.currentResult != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ResultsDashboard()),
      );
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Analysis Failed', style: TextStyle(color: AppColors.error)),
        content: Text(error, style: const TextStyle(color: AppColors.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.speed_rounded, color: AppColors.primary, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'SPEED ANALYZER',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
                    icon: const Icon(Icons.info_outline, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.primary.withOpacity(0.1),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.onSurfaceVariant,
                  tabs: const [
                    Tab(text: 'Speed Test'),
                    Tab(text: 'Compare'),
                    Tab(text: 'History'),
                  ],
                  onTap: (index) {
                    if (index == 1) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CompareScreen()));
                      _tabController.index = 0;
                    } else if (index == 2) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
                      _tabController.index = 0;
                    }
                  },
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Analyze Website Speed',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get real-time performance insights and Core Web Vitals.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Input Section
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: _urlController,
                            hintText: 'https://example.com',
                            prefixIcon: Icons.language,
                          ),
                          const SizedBox(height: 24),
                          
                          // Strategy Toggle
                          Row(
                            children: [
                              _StrategyButton(
                                label: 'Mobile',
                                icon: Icons.phone_android,
                                isActive: _strategy == 'mobile',
                                onTap: () => setState(() => _strategy = 'mobile'),
                              ),
                              const SizedBox(width: 12),
                              _StrategyButton(
                                label: 'Desktop',
                                icon: Icons.desktop_windows,
                                isActive: _strategy == 'desktop',
                                onTap: () => setState(() => _strategy = 'desktop'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Analyze Button
                          Consumer<AnalyzerProvider>(
                            builder: (context, provider, child) {
                              return SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: provider.isLoading ? null : _analyze,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ).copyWith(
                                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                                      if (states.contains(WidgetState.disabled)) {
                                        return AppColors.surfaceContainerHigh;
                                      }
                                      return null; // Gradient will show
                                    }),
                                  ),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: provider.isLoading ? null : const LinearGradient(
                                        colors: [AppColors.neonBlue, AppColors.neonCyan],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        if (!provider.isLoading)
                                          BoxShadow(
                                            color: AppColors.neonCyan.withOpacity(0.3),
                                            blurRadius: 15,
                                            spreadRadius: 0,
                                          ),
                                      ],
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: provider.isLoading
                                          ? const SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors.primary,
                                              ),
                                            )
                                          : const Text(
                                              'ANALYZE NOW',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    
                    // Recent Scans Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Scans',
                          style: theme.textTheme.headlineSmall?.copyWith(fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                          child: const Text('View All', style: TextStyle(color: AppColors.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Consumer<AnalyzerProvider>(
                      builder: (context, provider, child) {
                        if (provider.history.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                children: [
                                  Icon(Icons.history_toggle_off, size: 48, color: AppColors.onSurfaceVariant.withOpacity(0.3)),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No recent scans yet',
                                    style: TextStyle(color: AppColors.onSurfaceVariant.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.history.length > 3 ? 3 : provider.history.length,
                          itemBuilder: (context, index) {
                            final item = provider.history[index];
                            return _HistoryTile(item: item);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrategyButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _StrategyButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? AppColors.primary : Colors.white.withOpacity(0.08),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isActive ? AppColors.primary : AppColors.onSurfaceVariant),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final HistoryItem item;

  const _HistoryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  '${item.timestamp.day}/${item.timestamp.month}/${item.timestamp.year}',
                  style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getScoreColor(item.performanceScore).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getScoreColor(item.performanceScore).withOpacity(0.3)),
            ),
            child: Text(
              '${(item.performanceScore * 100).toInt()}',
              style: TextStyle(
                color: _getScoreColor(item.performanceScore),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 0.9) return AppColors.green;
    if (score >= 0.5) return AppColors.yellow;
    return AppColors.red;
  }
}
