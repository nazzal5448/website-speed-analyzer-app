import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class StorageService {
  static const String _historyKey = 'scan_history';

  Future<void> saveScan(HistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    // Add to beginning of list
    history.insert(0, json.encode(item.toJson()));
    
    // Keep only last 50 scans
    if (history.length > 50) {
      history.removeLast();
    }
    
    await prefs.setStringList(_historyKey, history);
  }

  Future<List<HistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    return history.map((item) => HistoryItem.fromJson(json.decode(item))).toList();
  }

  Future<void> deleteHistoryItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_historyKey) ?? [];
    
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await prefs.setStringList(_historyKey, history);
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
