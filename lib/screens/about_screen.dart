import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import '../widgets/glass_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About the App'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Center(
              child: Icon(Icons.speed_rounded, size: 80, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'Website Speed Analyzer',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 40),
            
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Our Mission',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Our mission is to empower developers and business owners with deep technical insights. We believe that a faster web is a better web for everyone.',
                    style: TextStyle(color: AppColors.onSurfaceVariant.withOpacity(0.9), height: 1.6),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            const Text(
              'Connect with us',
              style: TextStyle(color: AppColors.onSurfaceVariant, letterSpacing: 1),
            ),
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialButton(icon: Icons.language, onTap: () => _launchUrl('https://cyfrow.org')),
                const SizedBox(width: 20),
                _SocialButton(icon: Icons.code, onTap: () => _launchUrl('https://github.com/cyfrow')),
                const SizedBox(width: 20),
                _SocialButton(icon: Icons.alternate_email, onTap: () => _launchUrl('mailto:hello@cyfrow.org')),
              ],
            ),
            
            const SizedBox(height: 64),
            
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => _launchUrl('https://cyfrow.org'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.neonBlue, AppColors.neonCyan]),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'VISIT WEBSITE',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            const Opacity(
              opacity: 0.3,
              child: const Text('© 2026 Website Speed Analyzer. All rights reserved.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 24),
      ),
    );
  }
}
