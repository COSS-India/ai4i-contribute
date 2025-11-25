class LikhoValidationModel {
  final String itemId;
  final String srcLanguage;
  final String tgtLanguage;
  final String text;
  final String translation;
  final Map<String, dynamic> metadata;

  LikhoValidationModel({
    required this.itemId,
    required this.srcLanguage,
    required this.tgtLanguage,
    required this.text,
    required this.translation,
    required this.metadata,
  });

  factory LikhoValidationModel.fromJson(Map<String, dynamic> json) {
    return LikhoValidationModel(
      itemId: json['item_id'] ?? '',
      srcLanguage: json['src_language'] ?? '',
      tgtLanguage: json['tgt_language'] ?? '',
      text: json['text'] ?? '',
      translation: json['translation'] ?? '',
      metadata: json['metadata'] ?? {},
    );
  }
}

class LikhoValidationResponse {
  final bool success;
  final List<LikhoValidationModel> data;
  final String? error;

  LikhoValidationResponse({
    required this.success,
    required this.data,
    this.error,
  });

  factory LikhoValidationResponse.fromJson(Map<String, dynamic> json) {
    return LikhoValidationResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => LikhoValidationModel.fromJson(item))
              .toList() ??
          [],
      error: json['error'],
    );
  }
}