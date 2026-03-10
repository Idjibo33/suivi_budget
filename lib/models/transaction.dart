class TransactionModel {
  int? id;
  int montant;
  String category;
  String description;
  String type;
  String date;
  TransactionModel({
    this.id,
    required this.montant,
    required this.category,
    required this.description,
    required this.type,
    required this.date,
  });
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      montant: map['montant'],
      category: map['category'],
      description: map['description'],
      type: map['type'],
      date: map['date'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'montant': montant,
      'category': category,
      'description': description,
      'type': type,
      'date': date,
    };
  }
}
