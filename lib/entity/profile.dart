class Profile {
  final String nom;
  final String prenom;
  final String dateNaissance;
  final String numTel;
  final String numDossier;

  Profile({
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.numTel,
    required this.numDossier,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      nom: json['nom'],
      prenom: json['prenom'],
      dateNaissance: json['dateNaissance'],
      numTel: json['numTel'],
      numDossier: json['numDossier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance,
      'numTel': numTel,
      'numDossier': numDossier,
    };
  }
}
