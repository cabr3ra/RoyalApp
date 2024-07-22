import 'package:cloud_firestore/cloud_firestore.dart';

class Position {
  String id;
  String name;
  String abbreviation;

  Position({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory Position.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Position(
      id: doc.id,
      name: data['name'],
      abbreviation: data['abbreviation'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'abbreviation': abbreviation,
    };
  }
}
