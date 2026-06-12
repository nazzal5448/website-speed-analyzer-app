import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'providers/analyzer_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnalyzerProvider()),
      ],
      child: const SpeedAnalyzerApp(),
    ),
  );
}

class SpeedAnalyzerApp extends StatelessWidget {
  const SpeedAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Website Speed Analyzer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
