class PlatformModel {
  final int id;
  final String name;
  final String slug;
  final String abbreviation;

  PlatformModel(
      {required this.id,
      required this.name,
      required this.slug,
      required this.abbreviation});

  factory PlatformModel.fromJson(json) {
    return PlatformModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'abbreviation': abbreviation,
    };
  }
}
