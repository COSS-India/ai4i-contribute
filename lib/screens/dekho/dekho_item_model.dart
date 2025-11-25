class DekhoItemModel {
  final String itemId;
  final String language;
  final String imageUrl;
  final Map<String, dynamic> metadata;

  DekhoItemModel({
    required this.itemId,
    required this.language,
    required this.imageUrl,
    required this.metadata,
  });

  factory DekhoItemModel.fromJson(Map<String, dynamic> json) {
    return DekhoItemModel(
      itemId: json['item_id'] ?? '',
      language: json['language'] ?? '',
      imageUrl: json['image_url'] ?? '',
      metadata: json['metadata'] ?? {},
    );
  }
}

class DekhoQueueResponse {
  final bool success;
  final List<DekhoItemModel> data;
  final String? error;

  DekhoQueueResponse({
    required this.success,
    required this.data,
    this.error,
  });

  factory DekhoQueueResponse.fromJson(Map<String, dynamic> json) {
    return DekhoQueueResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => DekhoItemModel.fromJson(item))
              .toList() ??
          [],
      error: json['error'],
    );
  }
}