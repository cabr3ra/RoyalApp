import 'package:cloud_firestore/cloud_firestore.dart';

class Nationality {
  String id;
  String name;
  String abbreviation;
  String imageUrl;

  Nationality({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.imageUrl,
  });

  factory Nationality.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Nationality(
      id: doc.id,
      name: data['name'],
      abbreviation: data['abbreviation'],
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'abbreviation': abbreviation,
      'imageUrl': imageUrl,
    };
  }
}
