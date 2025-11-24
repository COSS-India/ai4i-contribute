import 'dart:convert';
import 'package:VoiceGive/constants/api_url.dart';
import 'package:VoiceGive/constants/network_headers.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'likho_item_model.dart';
import 'likho_validation_model.dart';

class LikhoService {

  Future<LikhoQueueResponse> getLikhoQueue({
    required String srcLanguage,
    required int batchSize,
  }) async {
    try {
      Map data = {
        'src_language': srcLanguage,
        'tgt_language': 'en',
        'batch_size': batchSize,
      };

      debugPrint('API Call - getLikhoQueue');
      debugPrint('Payload: ${jsonEncode(data)}');

      Response response = await post(
        Uri.parse(ApiUrl.likhoQueueUrl),
        headers: NetworkHeaders.postHeader,
        body: jsonEncode(data),
      );

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return LikhoQueueResponse.fromJson(jsonData);
      } else {
        return LikhoQueueResponse(
          success: false,
          data: [],
          error: 'Failed to load data: ${response.statusCode}',
        );
      }
    } catch (e) {
      return LikhoQueueResponse(
        success: false,
        data: [],
        error: 'Network error: $e',
      );
    }
  }

  Future<bool> submitTranslation({
    required String itemId,
    required String srcLanguage,
    required String tgtLanguage,
    required String translation,
  }) async {
    try {
      final body = jsonEncode({
        'item_id': itemId,
        'src_language': srcLanguage,
        'tgt_language': tgtLanguage,
        'translation': translation,
        'metadata': {},
      });

      debugPrint('=== LIKHO SUBMIT CURL ===');
      debugPrint('curl -X POST "${ApiUrl.likhoSubmitUrl}" \\');
      debugPrint('  -H "accept: application/json" \\');
      debugPrint('  -H "Content-Type: application/json" \\');
      debugPrint('  -d \'$body\'');
      debugPrint('========================');

      final response = await post(
        Uri.parse(ApiUrl.likhoSubmitUrl),
        headers: NetworkHeaders.postHeader,
        body: body,
      );

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Submit Error: $e');
      return false;
    }
  }

  Future<LikhoValidationResponse> getValidationQueue({required int batchSize}) async {
    try {
      final url = '${ApiUrl.likhoValidationUrl}?batch_size=$batchSize';

      final response = await get(
        Uri.parse(url),
        headers: NetworkHeaders.getHeader,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return LikhoValidationResponse.fromJson(jsonData);
      } else {
        return LikhoValidationResponse(
          success: false,
          data: [],
          error: 'Failed to load data: ${response.statusCode}',
        );
      }
    } catch (e) {
      return LikhoValidationResponse(
        success: false,
        data: [],
        error: 'Network error: $e',
      );
    }
  }

  Future<bool> submitValidationCorrect({required String itemId}) async {
    try {
      final response = await post(
        Uri.parse(ApiUrl.likhoValidationCorrectUrl),
        headers: NetworkHeaders.postHeader,
        body: jsonEncode({
          'item_id': itemId,
          'decision': 'correct',
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Validation Correct Error: $e');
      return false;
    }
  }

  Future<bool> submitValidationCorrection({
    required String itemId,
    required String correctedTranslation,
  }) async {
    try {
      final response = await post(
        Uri.parse(ApiUrl.likhoValidationCorrectionUrl),
        headers: NetworkHeaders.postHeader,
        body: jsonEncode({
          'item_id': itemId,
          'corrected_translation': correctedTranslation,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Validation Correction Error: $e');
      return false;
    }
  }
}