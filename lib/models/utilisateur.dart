class Utilisateur {
  String id;
  String nom;
  String prenom;
  String email;
  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });
  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
    );
  }
  Map<String, dynamic> toMap() {
    return {'id': id, 'nom': nom, 'prenom': prenom, 'email': email};
  }
}
