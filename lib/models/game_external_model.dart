import 'cover_model.dart';

class ExternalGameModel {
  final int id;
  final CoverModel? cover;
  final String name;

  ExternalGameModel(
      {required this.id, required this.cover, required this.name});

  factory ExternalGameModel.fromJson(json) {
    return ExternalGameModel(
      id: json['id'],
      cover: json?['cover'] != null ? CoverModel.fromJson(json['cover']) : null,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cover': cover?.toJson(),
      'name': name,
    };
  }
}
