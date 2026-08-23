class TimeToBeatModel {
  final double? hastily;
  final double? normally;
  final double? completely;
  final int? count;

  TimeToBeatModel({this.hastily, this.normally, this.completely, this.count});

  factory TimeToBeatModel.fromJson(json) {
    return TimeToBeatModel(
      hastily: _secondsToHours(json['hastily']),
      normally: _secondsToHours(json['normally']),
      completely: _secondsToHours(json['completely']),
      count: json['count'] != null ? (json['count'] as num).toInt() : null,
    );
  }

  static double? _secondsToHours(dynamic seconds) {
    if (seconds == null) return null;
    return (seconds as num) / 3600;
  }

  bool get isEmpty => hastily == null && normally == null && completely == null;
}
