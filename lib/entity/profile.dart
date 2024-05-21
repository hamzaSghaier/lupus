class Profile {
  final String nom;
  final String prenom;
  final String dateNaissance;
  final String numTel;
  final String numDossier;
  final String password;
  bool isLoggedIn;

  Profile(
      {required this.nom,
      required this.prenom,
      required this.dateNaissance,
      required this.numTel,
      required this.numDossier,
      required this.isLoggedIn,
      required this.password});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      nom: json['nom'],
      isLoggedIn: json['isLoggedIn'],
      prenom: json['prenom'],
      dateNaissance: json['dateNaissance'],
      numTel: json['numTel'],
      password: json['password'],
      numDossier: json['numDossier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'isLoggedIn': isLoggedIn,
      'password': password,
      'dateNaissance': dateNaissance,
      'numTel': numTel,
      'numDossier': numDossier,
    };
  }
}
