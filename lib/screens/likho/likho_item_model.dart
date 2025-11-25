class LikhoItemModel {
  final String itemId;
  final String srcLanguage;
  final String tgtLanguage;
  final String text;
  final Map<String, dynamic> metadata;

  LikhoItemModel({
    required this.itemId,
    required this.srcLanguage,
    required this.tgtLanguage,
    required this.text,
    required this.metadata,
  });

  factory LikhoItemModel.fromJson(Map<String, dynamic> json) {
    return LikhoItemModel(
      itemId: json['item_id'] ?? '',
      srcLanguage: json['src_language'] ?? '',
      tgtLanguage: json['tgt_language'] ?? '',
      text: json['text'] ?? '',
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'src_language': srcLanguage,
      'tgt_language': tgtLanguage,
      'text': text,
      'metadata': metadata,
    };
  }
}

class LikhoQueueResponse {
  final bool success;
  final List<LikhoItemModel> data;
  final String? error;

  LikhoQueueResponse({
    required this.success,
    required this.data,
    this.error,
  });

  factory LikhoQueueResponse.fromJson(Map<String, dynamic> json) {
    return LikhoQueueResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => LikhoItemModel.fromJson(item))
              .toList() ??
          [],
      error: json['error'],
    );
  }
}