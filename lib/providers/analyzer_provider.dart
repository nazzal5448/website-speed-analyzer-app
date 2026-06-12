import 'package:flutter/material.dart';
import '../models/page_speed_result.dart';
import '../models/history_item.dart';
import '../models/comparison_result.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AnalyzerProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  PageSpeedResult? _currentResult;
  PageSpeedResult? get currentResult => _currentResult;

  ComparisonResult? _comparisonResult;
  ComparisonResult? get comparisonResult => _comparisonResult;

  List<HistoryItem> _history = [];
  List<HistoryItem> get history => _history;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  AnalyzerProvider() {
    loadHistory();
  }

  Future<void> loadHistory() async {
    _history = await _storageService.getHistory();
    notifyListeners();
  }

  Future<void> analyzeUrl(String url, String strategy) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentResult = await _apiService.getPageSpeedMetrics(url, strategy: strategy);
      
      // Save to history
      final historyItem = HistoryItem(
        url: url,
        timestamp: DateTime.now(),
        performanceScore: _currentResult!.performanceScore,
        seoScore: _currentResult!.seoScore,
        accessibilityScore: _currentResult!.accessibilityScore,
        bestPracticesScore: _currentResult!.bestPracticesScore,
        faviconUrl: 'https://www.google.com/s2/favicons?domain=$url&sz=128',
      );
      await _storageService.saveScan(historyItem);
      await loadHistory();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> compareUrls(String url1, String url2, String strategy) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res1 = await _apiService.getPageSpeedMetrics(url1, strategy: strategy);
      final res2 = await _apiService.getPageSpeedMetrics(url2, strategy: strategy);
      _comparisonResult = ComparisonResult(first: res1, second: res2);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteHistoryItem(int index) async {
    await _storageService.deleteHistoryItem(index);
    await loadHistory();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
