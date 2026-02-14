import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suivi_budget/constants.dart';

class TransactionModel {
  String userId;
  int montant;
  String category;
  String type;
  FieldValue date;
  TransactionModel({
    required this.userId,
    required this.montant,
    required this.category,
    required this.type,
    required this.date,
  });
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      userId: map['id'],
      montant: map['montant'],
      category: map['category'],
      type: map['type'],
      date: map['date'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'montant': montant,
      'category': category,
      'type': type,
      'date': FieldValue.serverTimestamp(),
    };
  }
}
