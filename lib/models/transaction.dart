import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String id;
  String userId;
  int montant;
  String category;
  String description;
  String type;
  DateTime date;
  TransactionModel({
    required this.id,
    required this.userId,
    required this.montant,
    required this.category,
    required this.description,
    required this.type,
    required this.date,
  });
  factory TransactionModel.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      userId: data['userId'],
      montant: data['montant'],
      category: data['category'],
      description: data['description'],
      type: data['type'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'montant': montant,
      'category': category,
      'description': description,
      'type': type,
      'date': date,
    };
  }
}
