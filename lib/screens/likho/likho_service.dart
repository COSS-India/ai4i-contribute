import 'dart:convert';
import 'package:http/http.dart' as http;
import 'likho_item_model.dart';
import 'likho_validation_model.dart';

class LikhoService {
  static const String baseUrl = 'http://3.7.77.1:9000';

  Future<LikhoQueueResponse> getLikhoQueue({
    required String srcLanguage,
    required int batchSize,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/likho/queue'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'src_language': srcLanguage,
          'tgt_language': 'en',
          'batch_size': batchSize,
        }),
      );

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
    required String translation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/likho/submit'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'item_id': itemId,
          'src_language': srcLanguage,
          'tgt_language': 'en',
          'translation': translation,
          'metadata': {},
        }),
      );

      print('Submit Response Status: ${response.statusCode}');
      print('Submit Response Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Submit Error: $e');
      return false;
    }
  }

  Future<LikhoValidationResponse> getValidationQueue({required int batchSize}) async {
    try {
      List<LikhoValidationModel> allItems = [];
      int totalNeeded = batchSize;
      
      while (allItems.length < totalNeeded) {
        final response = await http.get(
          Uri.parse('$baseUrl/likho/validation?batch_size=5'),
          headers: {
            'accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final batchResponse = LikhoValidationResponse.fromJson(jsonData);
          
          if (batchResponse.success && batchResponse.data.isNotEmpty) {
            allItems.addAll(batchResponse.data);
          } else {
            break;
          }
        } else {
          break;
        }
      }

      return LikhoValidationResponse(
        success: allItems.isNotEmpty,
        data: allItems.take(totalNeeded).toList(),
      );
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
      final response = await http.post(
        Uri.parse('$baseUrl/likho/validation/correct'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'item_id': itemId,
          'decision': 'correct',
        }),
      );

      print('Validation Correct Response: ${response.statusCode}');
      print('Validation Correct Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Validation Correct Error: $e');
      return false;
    }
  }

  Future<bool> submitValidationCorrection({
    required String itemId,
    required String correctedTranslation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/likho/validation/submit-correction'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'item_id': itemId,
          'corrected_translation': correctedTranslation,
        }),
      );

      print('Validation Correction Response: ${response.statusCode}');
      print('Validation Correction Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Validation Correction Error: $e');
      return false;
    }
  }
}