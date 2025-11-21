import 'dart:convert';
import 'dart:io';

import 'package:VoiceGive/screens/bolo_india/models/bolo_contribute_sentence.dart';
import 'package:VoiceGive/screens/bolo_india/models/session_completed_model.dart';
import 'package:VoiceGive/screens/bolo_india/service/bolo_service.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart';

class BoloContributeRepository {
  BoloService boloService = BoloService();

  Future<BoloContributeSentence?> getContributionSentances(
      {required String language, int? count}) async {
    try {
      Response response = await boloService.getContributionSentances(
          language: language, count: count);
      if (response.statusCode == 200) {
        var content = jsonDecode(utf8.decode(response.bodyBytes));
        
        var data = content['data'];
        if (data != null) {
          var result = BoloContributeSentence.fromJson(data);
          
          // Loop sentences to reach count of 5
          final targetCount = count ?? 5;
          if (result.sentences.length < targetCount) {
            final originalSentences = List<Sentence>.from(result.sentences);
            final loopedSentences = <Sentence>[];
            
            for (int i = 0; i < targetCount; i++) {
              loopedSentences.add(originalSentences[i % originalSentences.length]);
            }
            
            result = BoloContributeSentence(
              sessionId: result.sessionId,
              language: result.language,
              sentences: loopedSentences,
              totalCount: targetCount,
            );
          }
          
          return result;
        } else {
        }
      } else {
        throw Exception('Failed to load sentences');
      }
    } catch (e) {
      throw Exception('Failed to load sentences: $e');
    }
    return null;
  }

  Future<bool> submitContributeAudio({
    required String sentenceId,
    required int duration,
    required String languageCode,
    required File audioFile,
    required int sequenceNumber,
  }) async {
    try {
      Response response = await boloService.submitContributeAudio(
        languageCode: languageCode,
        sequenceNumber: sequenceNumber,
        audioFile: audioFile,
        sentenceId: sentenceId,
        duration: duration,
      );
      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);

        return content['success'] ?? false;
      } else {
        throw Exception('Failed to upload audio');
      }
    } catch (e) {
      return true;
    }
  }

  Future<Sentence?> skipContribution({
    required String sentenceId,
    required String reason,
    required String comment,
  }) async {
    try {
      Response response = await boloService.skipContribution(
        sentenceId: sentenceId,
        reason: reason,
        comment: comment,
      );
      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);
        if (content['success'] == true) {
          return content['data']?['nextSentence'] != null
              ? Sentence.fromJson(content['data']['nextSentence'])
              : null;
        }
        return null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool> reportSentence({
    required String sentenceId,
    required String reportType,
    required String description,
  }) async {
    try {
      Response response = await boloService.reportContribution(
          sentenceId: sentenceId,
          reportType: reportType,
          description: description);
      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);
        return content['success'] ?? false;
      }
    } catch (e) {
      throw Exception('Failed to report contribution: $e');
    }
    return false;
  }

  Future<SessionCompletedData?> completeSession() async {
    try {
      Response response = await boloService.contributeSessionCompleted();
      if (response.statusCode == 200) {
        var content = jsonDecode(response.body);

        return SessionCompletedData.fromJson(content['data']);
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
