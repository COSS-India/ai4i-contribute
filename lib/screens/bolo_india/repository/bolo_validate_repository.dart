import 'dart:convert';
import 'package:VoiceGive/screens/bolo_india/models/bolo_validate_model.dart';
import 'package:VoiceGive/screens/bolo_india/models/session_completed_model.dart';
import 'package:VoiceGive/screens/bolo_india/models/validation_submit_model.dart';
import 'package:VoiceGive/screens/bolo_india/service/bolo_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class BoloValidateRepository {
  BoloService boloService = BoloService();

  Future<ValidationQueueModel?> getValidationsQueue({
    required String language,
    required int count,
  }) async {
    try {
     
      Response response = await boloService.getValidationsQueue(
          count: count, language: language);
      debugPrint(
          'Validation Repository - Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        var content = jsonDecode(utf8.decode(response.bodyBytes));
        debugPrint('Validation Repository - Response content: $content');
        if (content['success'] == true) {
          var result = ValidationQueueModel.fromJson(content['data']);

          // Fix invalid audio URLs for all items
          final fixedItems = result.validationItems.map((item) {
            var audioUrl = item.audioContent;
            debugPrint('Original audio URL: $audioUrl');
            if (audioUrl.contains('storage.example.com') || !audioUrl.startsWith('http')) {
              audioUrl = 'http://3.7.77.1:9000/suno/static/sample2.mp3';
              debugPrint('Replaced with fallback URL: $audioUrl');
            }
            return ValidationItem(
              contributionId: item.contributionId,
              sentenceId: item.sentenceId,
              text: item.text,
              audioContent: audioUrl,
              duration: item.duration,
              sequenceNumber: item.sequenceNumber,
            );
          }).toList();

          // Always loop validation items to reach exactly the target count
          final loopedItems = <ValidationItem>[];
          for (int i = 0; i < count; i++) {
            loopedItems.add(fixedItems[i % fixedItems.length]);
          }
          
          result = ValidationQueueModel(
            sessionId: result.sessionId,
            language: result.language,
            validationItems: loopedItems,
            totalCount: count,
          );

          debugPrint(
              'Validation Repository - Successfully parsed with ${result.validationItems.length} items');
          debugPrint('Validation Repository - Final totalCount: ${result.totalCount}');
          return result;
        }
      }
    } catch (e) {
      debugPrint('Validation Repository - Exception: $e');
      return null;
    }
    return null;
  }

  Future<ValidationSubmitData?> submitValidation({
    required String contributionId,
    required String sentenceId,
    required String decision,
    required String feedback,
    required int sequenceNumber,
  }) async {
    try {
      Response response = await boloService.submitValidation(
        contributionId: contributionId,
        sentenceId: sentenceId,
        decision: decision,
        feedback: feedback,
        sequenceNumber: sequenceNumber,
      );

      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);
        return ValidationSubmitData.fromJson(content['data']);
      } else {
        throw Exception('Failed to submit validation');
      }
    } catch (e) {
      throw Exception('Failed to submit validation: $e');
    }
  }

  Future<SessionCompletedModel?> validateSessionCompleted() async {
    try {
      Response response = await boloService.validateSessionCompleted();
      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);
        return SessionCompletedModel.fromJson(content['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
