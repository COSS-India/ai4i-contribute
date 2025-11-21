import 'dart:convert';
import 'package:VoiceGive/screens/bolo_india/models/bolo_validate_model.dart';
import 'package:VoiceGive/screens/bolo_india/models/session_completed_model.dart';
import 'package:VoiceGive/screens/bolo_india/models/validation_submit_model.dart';
import 'package:VoiceGive/screens/bolo_india/service/bolo_service.dart';
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
      if (response.statusCode == 200) {
        var content = jsonDecode(utf8.decode(response.bodyBytes));
        if (content['success'] == true) {
          return ValidationQueueModel.fromJson(content['data']);
        }
      }
    } catch (e) {
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
