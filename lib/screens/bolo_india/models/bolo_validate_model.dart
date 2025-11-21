class ValidationItem {
  final String contributionId;
  final String sentenceId;
  final String text;
  final String audioContent;
  final double duration;
  final int sequenceNumber;

  ValidationItem({
    required this.contributionId,
    required this.sentenceId,
    required this.text,
    required this.audioContent,
    required this.duration,
    required this.sequenceNumber,
  });

  factory ValidationItem.fromJson(Map<String, dynamic> json) {
    return ValidationItem(
      contributionId: json['contributionId'] as String,
      sentenceId: json['sentenceId'] as String,
      text: json['text'] as String,
      audioContent: json['audioUrl'] as String,
      duration: json['duration'] as double,
      sequenceNumber: json['sequenceNumber'] as int,
    );
  }
}

class ValidationQueueModel {
  final String sessionId;
  final String language;
  final List<ValidationItem> validationItems;
  final int totalCount;

  ValidationQueueModel({
    required this.sessionId,
    required this.language,
    required this.validationItems,
    required this.totalCount,
  });

  factory ValidationQueueModel.fromJson(Map<String, dynamic> json) {
    return ValidationQueueModel(
      sessionId: json['sessionId'] as String,
      language: json['language'] as String,
      validationItems: (json['validationItems'] as List)
          .map((e) => ValidationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int,
    );
  }
}
