class CoverModel {
  final int id;
  final String imageId;

  CoverModel({required this.id, required this.imageId});

  factory CoverModel.fromJson(json) {
    return CoverModel(
      id: json['id'],
      imageId: json['image_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_id': imageId,
    };
  }
}
