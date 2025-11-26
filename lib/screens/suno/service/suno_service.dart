import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:VoiceGive/constants/api_url.dart';
import '../models/suno_item_model.dart';
import '../models/suno_validation_model.dart';

class SunoService {

  Future<SunoQueueResponse> getSunoQueue({
    required String language,
    int batchSize = 5,
  }) async {
    final url = ApiUrl.sunoQueueUrl;
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final body = {
      'language': language,
      'batch_size': batchSize,
    };

    // Print curl command
    print('\n=== SUNO API DEBUG ===');
    print('curl -X POST \\');
    print('  \'$url\' \\');
    headers.forEach((key, value) {
      print('  -H \'$key: $value\' \\');
    });
    print('  -d \'${jsonEncode(body)}\'');
    print('=====================\n');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');
      print('=====================\n');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SunoQueueResponse.fromJson(jsonData);
      } else {
        print('ERROR: HTTP ${response.statusCode}');
        print('Error Body: ${response.body}');
        throw Exception(
            'Failed to load suno queue: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('EXCEPTION: $e');
      print('=====================\n');
      throw Exception('Error fetching suno queue: $e');
    }
  }

  Future<bool> submitTranscript({
    required String itemId,
    required String language,
    required String transcript,
    Map<String, dynamic>? metadata,
  }) async {
    final url = ApiUrl.sunoSubmitUrl;
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final body = {
      'item_id': itemId,
      'language': language,
      'transcript': transcript,
      'metadata': metadata ?? {},
    };

    print('\n=== SUNO SUBMIT API DEBUG ===');
    print('curl -X POST \\');
    print('  \'$url\' \\');
    headers.forEach((key, value) {
      print('  -H \'$key: $value\' \\');
    });
    print('  -d \'${jsonEncode(body)}\'');
    print('=============================\n');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      print('Submit Response Status Code: ${response.statusCode}');
      print('Submit Response Headers: ${response.headers}');
      print('Submit Response Body: ${response.body}');
      print('=============================\n');

      return response.statusCode == 200;
    } catch (e) {
      print('SUBMIT EXCEPTION: $e');
      print('=============================\n');
      return false;
    }
  }

  Future<bool> submitValidationDecision({
    required String itemId,
    required String decision,
  }) async {
    final url = ApiUrl.sunoValidationCorrectUrl;
    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final body = {
      'item_id': itemId,
      'decision': decision,
    };

    print('\n=== SUNO VALIDATION DECISION API DEBUG ===');
    print('curl -X POST \\');
    print('  \'$url\' \\');
    headers.forEach((key, value) {
      print('  -H \'$key: $value\' \\');
    });
    print('  -d \'${jsonEncode(body)}\'');
    print('==========================================\n');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      print('Validation Decision Response Status Code: ${response.statusCode}');
      print('Validation Decision Response Headers: ${response.headers}');
      print('Validation Decision Response Body: ${response.body}');
      print('==========================================\n');

      return response.statusCode == 200;
    } catch (e) {
      print('VALIDATION DECISION EXCEPTION: $e');
      print('==========================================\n');
      return false;
    }
  }

  Future<SunoValidationResponse> getValidationQueue({
    int batchSize = 5,
  }) async {
    final url = '${ApiUrl.sunoValidationUrl}?batch_size=$batchSize';
    final headers = {
      'accept': 'application/json',
    };

    print('\n=== SUNO VALIDATION API DEBUG ===');
    print('curl -X GET \\');
    print('  \'$url\' \\');
    headers.forEach((key, value) {
      print('  -H \'$key: $value\'');
    });
    print('==================================\n');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('Validation Response Status Code: ${response.statusCode}');
      print('Validation Response Headers: ${response.headers}');
      print('Validation Response Body: ${response.body}');
      print('==================================\n');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SunoValidationResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load validation queue: ${response.statusCode}');
      }
    } catch (e) {
      print('VALIDATION EXCEPTION: $e');
      throw Exception('Error fetching validation queue: $e');
    }
  }

  String getFullAudioUrl(String audioUrl) {
    print('Original audio URL from API: $audioUrl');
    
    if (audioUrl.startsWith('http')) {
      return audioUrl;
    }
    
    // For relative URLs starting with /, prepend base URL
    if (audioUrl.startsWith('/')) {
      final fullUrl = '${ApiUrl.baseUrl}$audioUrl';
      print('Constructed full URL: $fullUrl');
      return fullUrl;
    }
    
    // Fallback for other cases
    final fullUrl = '${ApiUrl.baseUrl}/$audioUrl';
    print('Constructed fallback URL: $fullUrl');
    return fullUrl;
  }
}
