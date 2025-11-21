class ModuleStatusModel {
  final String module;
  final String status;

  ModuleStatusModel({
    required this.module,
    required this.status,
  });

  factory ModuleStatusModel.fromJson(Map<String, dynamic> json) {
    return ModuleStatusModel(
      module: json['module'] ?? '',
      status: json['status'] ?? '',
    );
  }
}