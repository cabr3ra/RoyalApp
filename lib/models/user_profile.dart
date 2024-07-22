import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String id;
  String email;
  String name;
  int age;
  int points;

  UserProfile({
    required this.id,
    required this.email,
    this.name = '',
    this.age = 0,
    this.points = 0,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? 'Nombre',
      age: data['age'] ?? 0,
      points: data['points'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'age': age,
      'points': points,
    };
  }
}
