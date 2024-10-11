class WeightEntry {
  final int? id;
  final DateTime date;
  final double weight;

  WeightEntry({this.id, required this.date, required this.weight});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'weight': weight,
    };
  }

  factory WeightEntry.fromMap(Map<String, dynamic> map) {
    return WeightEntry(
      id: map['id'],
      date: DateTime.parse(map['date']),
      weight: map['weight'],
    );
  }
}