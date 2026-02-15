class Utilisateur {
  String userId;
  String nom;
  String prenom;
  String email;
  Utilisateur({
    required this.userId,
    required this.nom,
    required this.prenom,
    required this.email,
  });
  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      userId: map['userId'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
    );
  }
  Map<String, dynamic> toMap() {
    return {'userId': userId, 'nom': nom, 'prenom': prenom, 'email': email};
  }
}
