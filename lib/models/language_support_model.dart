class LanguageSupportModel {
  final String language;
  final String supportType;

  LanguageSupportModel({required this.language, required this.supportType});

  factory LanguageSupportModel.fromJson(json) {
    return LanguageSupportModel(
      language: json['language']?['name'] ?? '',
      supportType: json['language_support_type']?['name'] ?? '',
    );
  }
}
