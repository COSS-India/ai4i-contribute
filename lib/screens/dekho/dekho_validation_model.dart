class DekhoValidationModel {
  final String itemId;
  final String language;
  final String imageUrl;
  final String label;
  final Map<String, dynamic> metadata;

  DekhoValidationModel({
    required this.itemId,
    required this.language,
    required this.imageUrl,
    required this.label,
    required this.metadata,
  });

  factory DekhoValidationModel.fromJson(Map<String, dynamic> json) {
    return DekhoValidationModel(
      itemId: json['item_id'] ?? '',
      language: json['language'] ?? '',
      imageUrl: json['image_url'] ?? '',
      label: json['label'] ?? '',
      metadata: json['metadata'] ?? {},
    );
  }
}

class DekhoValidationResponse {
  final bool success;
  final List<DekhoValidationModel> data;
  final String? error;

  DekhoValidationResponse({
    required this.success,
    required this.data,
    this.error,
  });

  factory DekhoValidationResponse.fromJson(Map<String, dynamic> json) {
    return DekhoValidationResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => DekhoValidationModel.fromJson(item))
              .toList() ??
          [],
      error: json['error'],
    );
  }
}