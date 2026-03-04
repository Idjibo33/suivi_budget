class Utilisateur {
  String nom;
  String prenom;
  String email;
  Utilisateur({required this.nom, required this.prenom, required this.email});
  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
    );
  }
  Map<String, dynamic> toMap() {
    return {'nom': nom, 'prenom': prenom, 'email': email};
  }
}
