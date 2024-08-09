import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String id;
  final String email;
  String username;
  int points;

  UserData({
    required this.id,
    required this.email,
    this.username = '',
    this.points = 0,
  });

  // Crea una instancia de UserData a partir de un DocumentSnapshot de Firestore
  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserData(
      id: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? 'Usuario',
      points: data['points'] ?? 0,
    );
  }

  // Convierte una instancia de UserData a un mapa de datos para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'points': points,
    };
  }
}
