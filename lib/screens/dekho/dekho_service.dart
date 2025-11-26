import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:VoiceGive/constants/api_url.dart';
import 'dekho_item_model.dart';
import 'dekho_validation_model.dart';

class DekhoService {

  Future<DekhoQueueResponse> getDekhoQueue({
    required String language,
    required int batchSize,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.dekhoQueueUrl),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'language': language,
          'batch_size': batchSize,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return DekhoQueueResponse.fromJson(jsonData);
      } else {
        return DekhoQueueResponse(
          success: false,
          data: [],
          error: 'Failed to load images: ${response.statusCode}',
        );
      }
    } catch (e) {
      return DekhoQueueResponse(
        success: false,
        data: [],
        error: 'Network error: $e',
      );
    }
  }

  Future<bool> submitValidationDecision({
    required String itemId,
    required String decision,
  }) async {
    try {
      final requestBody = {
        'item_id': itemId,
        'decision': decision,
      };
      
      print('DEBUG: Validation URL: ${ApiUrl.dekhoValidationCorrectUrl}');
      print('DEBUG: Request body: ${jsonEncode(requestBody)}');
      
      final response = await http.post(
        Uri.parse(ApiUrl.dekhoValidationCorrectUrl),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(requestBody),
      );

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      
      return response.statusCode == 200;
    } catch (e) {
      print('DEBUG: Exception in submitValidationDecision: $e');
      return false;
    }
  }

  Future<bool> submitValidationCorrection({
    required String itemId,
    required String correctedLabel,
  }) async {
    try {
      final requestBody = {
        'item_id': itemId,
        'corrected_label': correctedLabel,
      };
      
      print('DEBUG: Correction URL: ${ApiUrl.dekhoValidationCorrectionUrl}');
      print('DEBUG: Request body: ${jsonEncode(requestBody)}');
      
      final response = await http.post(
        Uri.parse(ApiUrl.dekhoValidationCorrectionUrl),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(requestBody),
      );

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      
      return response.statusCode == 200;
    } catch (e) {
      print('DEBUG: Exception in submitValidationCorrection: $e');
      return false;
    }
  }

  Future<bool> submitLabel({
    required String itemId,
    required String language,
    required String label,
  }) async {
    try {
      final requestBody = {
        'item_id': itemId,
        'language': language,
        'label': label,
        'labels': [label],
        'metadata': {},
      };
      
      print('DEBUG: Submit URL: ${ApiUrl.dekhoSubmitUrl}');
      print('DEBUG: Request body: ${jsonEncode(requestBody)}');
      
      final response = await http.post(
        Uri.parse(ApiUrl.dekhoSubmitUrl),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(requestBody),
      );

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      
      return response.statusCode == 200;
    } catch (e) {
      print('DEBUG: Exception in submitLabel: $e');
      return false;
    }
  }

  Future<DekhoValidationResponse> getValidationQueue({
    required int batchSize,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiUrl.dekhoValidationUrl}?batch_size=$batchSize'),
        headers: {
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return DekhoValidationResponse.fromJson(jsonData);
      } else {
        return DekhoValidationResponse(
          success: false,
          data: [],
          error: 'Failed to load validation data: ${response.statusCode}',
        );
      }
    } catch (e) {
      return DekhoValidationResponse(
        success: false,
        data: [],
        error: 'Network error: $e',
      );
    }
  }

  String getFullImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }
    return '${ApiUrl.baseUrl}$imageUrl';
  }
}