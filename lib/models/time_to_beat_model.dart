class TimeToBeatModel {
  final double? hastily;
  final double? normally;
  final double? completely;

  TimeToBeatModel({this.hastily, this.normally, this.completely});

  factory TimeToBeatModel.fromJson(json) {
    return TimeToBeatModel(
      hastily: _secondsToHours(json['hastily']),
      normally: _secondsToHours(json['normally']),
      completely: _secondsToHours(json['completely']),
    );
  }

  static double? _secondsToHours(dynamic seconds) {
    if (seconds == null) return null;
    return (seconds as num) / 3600;
  }

  bool get isEmpty => hastily == null && normally == null && completely == null;
}
