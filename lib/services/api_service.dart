import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/page_speed_result.dart';

class ApiService {
  static const String _baseUrl = 'https://www.googleapis.com/pagespeedonline/v5/runPagespeed';

  Future<PageSpeedResult> getPageSpeedMetrics(String url, {required String strategy}) async {
    final apiKey = dotenv.env['PSI_API_KEY'];
    if (apiKey == null) {
      throw Exception('PSI_API_KEY not found in .env file');
    }

    final String apiUrl = '$_baseUrl?url=$url&strategy=$strategy&key=$apiKey&category=performance&category=seo&category=accessibility&category=best-practices';
    
    final response = await http.get(
      Uri.parse(apiUrl),
    ).timeout(const Duration(seconds: 120));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PageSpeedResult.fromJson(data, url, strategy);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error']['message'] ?? 'Failed to load page speed metrics');
    }
  }
}
