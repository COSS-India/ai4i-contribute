import 'dart:convert';
import 'dart:io';
import 'package:VoiceGive/constants/api_url.dart';
import 'package:VoiceGive/constants/network_headers.dart';
import 'package:VoiceGive/constants/storage_constants.dart';
import 'package:VoiceGive/screens/bolo_india/models/language_model.dart';
import 'package:VoiceGive/services/secure_storage_service.dart';
import 'package:http/http.dart';

class BoloService {
  static final _storage = SecureStorageService.instance.storage;

  static Future<String> get sessionId async {
    return await _storage.read(key: StorageConstants.sessionId) ??
        "3fa85f64-5717-4562-b3fc-2c963f66afa6";
  }

  Future<Response> getContributionSentances(
      {required String language, int? count}) async {
    Map data = {
      //"language": language,
      "languageCode": language,
      "count": count ?? 5,
    };

    Response response = await post(
      Uri.parse(ApiUrl.getSentancesForRecordingUrl),
      headers: NetworkHeaders.postHeader,
      body: jsonEncode(data),
    );
    return response;
  }

  Future<Response> submitContributeAudio({
    required String sentenceId,
    required int duration,
    required String languageCode,
    required File audioFile,
    required int sequenceNumber,
  }) async {
    final audioBytes = await audioFile.readAsBytes();
    final audioBase64 = base64Encode(audioBytes);
    var sessionId = await BoloService.sessionId;

    final body = jsonEncode({
      'sessionId': sessionId,
      'sentenceId': sentenceId,
      'duration': duration,
      'languageCode': languageCode,
      'audioContent': audioBase64,
      'sequenceNumber': sequenceNumber,
      'metadata': "String",
    });

    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await post(
      Uri.parse(ApiUrl.sumbitAudioUrl),
      headers: headers,
      body: body,
    );

    return response;
  }

  Future<Response> skipContribution({
    required String sentenceId,
    required String reason,
    required String comment,
  }) async {
    var sessionId = await BoloService.sessionId;
    final body = jsonEncode({
      'sessionId': sessionId,
      'sentenceId': sentenceId,
      'reason': reason,
      'comment': comment,
    });

    final response = await post(
      Uri.parse(ApiUrl.skipContributionUrl),
      headers: NetworkHeaders.postHeader,
      body: body,
    );

    return response;
  }

  Future<Response> reportContribution({
    required String sentenceId,
    required String reportType,
    required String description,
  }) async {
    var url = ApiUrl.reportIssueUrl;

    final body = jsonEncode({
      'sentenceId': sentenceId,
      'reportType': reportType,
      'description': description,
    });

    final response = await post(
      Uri.parse(url),
      headers: NetworkHeaders.postHeader,
      body: body,
    );

    return response;
  }

  Future<Response> contributeSessionCompleted() async {
    var url = ApiUrl.contributeSessionCompleteUrl;
    var sessionId = await BoloService.sessionId;
    final body = jsonEncode({
      'sessionId': sessionId,
    });

    final response = await post(
      Uri.parse(url),
      headers: NetworkHeaders.postHeader,
      body: body,
    );

    return response;
  }

  Future<Response> validateSessionCompleted() async {
    var url = ApiUrl.validationSessionCompleteUrl;
    var sessionId = await BoloService.sessionId;

    final body = jsonEncode({
      'sessionId': sessionId,
    });

    final response = await post(
      Uri.parse(url),
      headers: NetworkHeaders.postHeader,
      body: body,
    );

    return response;
  }

  Future<Response> submitValidation({
    required String contributionId,
    required String sentenceId,
    required String decision,
    required String feedback,
    required int sequenceNumber,
  }) async {
    var sessionId = await BoloService.sessionId;

    final body = jsonEncode({
      'sessionId': sessionId,
      'contributionId': contributionId,
      'sentenceId': sentenceId,
      'decision': decision,
      'feedback': feedback,
      'sequenceNumber': sequenceNumber,
    });

    final response = await post(
      Uri.parse(ApiUrl.submitValidationUrl),
      headers: NetworkHeaders.postHeader,
      body: body,
    );

    return response;
  }

  Future<Response> getValidationsQueue({
    required String language,
    required int count,
  }) async {
    final url =
        '${ApiUrl.getValidationsQueUrl}?languageCode=$language&count=$count';

    final response = await get(
      Uri.parse(url),
      headers: NetworkHeaders.getHeader,
    );

    return response;
  }

  Future<List<LanguageModel>> getLanguages() async {
    final response = await get(
      Uri.parse(ApiUrl.getLanguages),
      headers: NetworkHeaders.getHeader,
    );
    if (response.statusCode == 200) {
      var content = jsonDecode(response.body);
      var data = content['data'] as List;
      return data.map((e) => LanguageModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
