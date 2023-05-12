class Symptome {
  SymptomeData fatigue;
  SymptomeData arthralgies;
  SymptomeData autonomie;
  SymptomeData humeur;
  SymptomeData sommeil;

  Symptome({
    required this.fatigue,
    required this.arthralgies,
    required this.autonomie,
    required this.humeur,
    required this.sommeil,
  });

  factory Symptome.fromJson(Map<String, dynamic> json) => Symptome(
        fatigue: json['fatigue'],
        arthralgies: json['arthralgies'],
        autonomie: json['autonomie'],
        humeur: json['humeur'],
        sommeil: json['sommeil'],
      );

  Map<String, dynamic> toJson() => {
        'fatigue': fatigue,
        'arthralgies': arthralgies,
        'autonomie': autonomie,
        'humeur': humeur,
        'sommeil': sommeil,
      };
}
class SymptomeData {
  int value;
  DateTime date;

  SymptomeData({required this.value, required this.date});

  factory SymptomeData.fromJson(Map<String, dynamic> json) {
    return SymptomeData(
      value: json['value'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'date': date.toIso8601String(),
    };
  }
}