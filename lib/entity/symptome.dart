class Symptome {
  int fatigue;
  int arthralgies;
  int autonomie;
  int humeur;
  int sommeil;

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