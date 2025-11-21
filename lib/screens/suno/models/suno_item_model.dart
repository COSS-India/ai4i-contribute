class SunoItemModel {
  final String itemId;
  final String language;
  final String audioUrl;
  final SunoMetadata metadata;

  SunoItemModel({
    required this.itemId,
    required this.language,
    required this.audioUrl,
    required this.metadata,
  });

  factory SunoItemModel.fromJson(Map<String, dynamic> json) {
    return SunoItemModel(
      itemId: json['item_id'] ?? '',
      language: json['language'] ?? '',
      audioUrl: json['audio_url'] ?? '',
      metadata: SunoMetadata.fromJson(json['metadata'] ?? {}),
    );
  }
}

class SunoMetadata {
  final double duration;

  SunoMetadata({required this.duration});

  factory SunoMetadata.fromJson(Map<String, dynamic> json) {
    return SunoMetadata(
      duration: (json['duration'] ?? 0.0).toDouble(),
    );
  }
}

class SunoQueueResponse {
  final bool success;
  final List<SunoItemModel> data;
  final String? error;

  SunoQueueResponse({
    required this.success,
    required this.data,
    this.error,
  });

  factory SunoQueueResponse.fromJson(Map<String, dynamic> json) {
    return SunoQueueResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => SunoItemModel.fromJson(item))
          .toList() ?? [],
      error: json['error'],
    );
  }
}