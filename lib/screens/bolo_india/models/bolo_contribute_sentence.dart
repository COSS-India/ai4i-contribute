class SentenceMetadata {
  final String? category;
  final String? difficulty;

  SentenceMetadata({
    this.category,
    this.difficulty,
  });

  factory SentenceMetadata.fromJson(Map<String, dynamic> json) {
    return SentenceMetadata(
      category: json['category'],
      difficulty: json['difficulty'],
    );
  }
}

class Sentence {
  final String sentenceId;
  final String text;
  final int sequenceNumber;
  final SentenceMetadata? metadata;

  Sentence({
    required this.sentenceId,
    required this.text,
    required this.sequenceNumber,
    this.metadata,
  });

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      sentenceId: json['sentenceId'] as String,
      text: json['text'] as String,
      sequenceNumber: json['sequenceNumber'] as int,
      metadata: json['metadata'] != null
          ? SentenceMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BoloContributeSentence {
  final String sessionId;
  final String language;
  final List<Sentence> sentences;
  final int totalCount;

  BoloContributeSentence({
    required this.sessionId,
    required this.language,
    required this.sentences,
    required this.totalCount,
  });

  factory BoloContributeSentence.fromJson(Map<String, dynamic> json) {
    return BoloContributeSentence(
      sessionId: json['sessionId'] as String,
      language: json['language'] as String,
      sentences: (json['sentences'] as List)
          .map((e) => Sentence.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int,
    );
  }
}
