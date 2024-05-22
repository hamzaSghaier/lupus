class Symptome {
  SymptomeData fatigue;
  SymptomeData arthralgies;
  SymptomeData autonomie;
  SymptomeData humeur;
  SymptomeData sommeil;
  DateTime createdAt;
  DateTime updatedAt;

  Symptome({
    required this.fatigue,
    required this.arthralgies,
    required this.autonomie,
    required this.humeur,
    required this.sommeil,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Symptome.fromJson(Map<String, dynamic> json) {
    return Symptome(
      fatigue: SymptomeData.fromJson(json['fatigue']),
      arthralgies: SymptomeData.fromJson(json['arthralgies']),
      autonomie: SymptomeData.fromJson(json['autonomie']),
      humeur: SymptomeData.fromJson(json['humeur']),
      sommeil: SymptomeData.fromJson(json['sommeil']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'fatigue': fatigue.toJson(),
        'arthralgies': arthralgies.toJson(),
        'autonomie': autonomie.toJson(),
        'humeur': humeur.toJson(),
        'sommeil': sommeil.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
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
