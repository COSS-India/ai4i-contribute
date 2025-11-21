class SunoValidationModel {
  final String itemId;
  final String language;
  final String audioUrl;
  final String transcript;
  final Map<String, dynamic> metadata;

  SunoValidationModel({
    required this.itemId,
    required this.language,
    required this.audioUrl,
    required this.transcript,
    required this.metadata,
  });

  factory SunoValidationModel.fromJson(Map<String, dynamic> json) {
    return SunoValidationModel(
      itemId: json['item_id'] ?? '',
      language: json['language'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      transcript: json['transcript'] ?? '',
      metadata: json['metadata'] ?? {},
    );
  }
}

class SunoValidationResponse {
  final bool success;
  final List<SunoValidationModel> data;
  final String? error;

  SunoValidationResponse({
    required this.success,
    required this.data,
    this.error,
  });

  factory SunoValidationResponse.fromJson(Map<String, dynamic> json) {
    return SunoValidationResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => SunoValidationModel.fromJson(item))
          .toList() ?? [],
      error: json['error'],
    );
  }
}