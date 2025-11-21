class ModuleSampleModel {
  final String comment;
  final String module;
  final List<SampleItem> sampleItems;

  ModuleSampleModel({
    required this.comment,
    required this.module,
    required this.sampleItems,
  });

  factory ModuleSampleModel.fromJson(Map<String, dynamic> json) {
    return ModuleSampleModel(
      comment: json['_comment'] ?? '',
      module: json['module'] ?? '',
      sampleItems: (json['sample_items'] as List<dynamic>?)
          ?.map((item) => SampleItem.fromJson(item))
          .toList() ?? [],
    );
  }
}

class SampleItem {
  final String id;
  final String text;

  SampleItem({
    required this.id,
    required this.text,
  });

  factory SampleItem.fromJson(Map<String, dynamic> json) {
    return SampleItem(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
    );
  }
}