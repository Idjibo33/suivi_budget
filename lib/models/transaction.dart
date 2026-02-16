class TransactionModel {
  String userId;
  int montant;
  String category;
  String description;
  String type;
  DateTime date;
  TransactionModel({
    required this.userId,
    required this.montant,
    required this.category,
    required this.description,
    required this.type,
    required this.date,
  });
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      userId: map['userId'],
      montant: map['montant'],
      category: map['category'],
      description: map['description'],
      type: map['type'],
      date: map['date'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'montant': montant,
      'category': category,
      'description': description,
      'type': type,
      'date': date,
    };
  }
}
