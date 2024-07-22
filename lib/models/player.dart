import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String id;
  String name;
  String surname;
  String nationalityId;
  String actualTeamId;
  String positionId;
  DateTime dateOfBirth;
  int dorsal;
  int height;
  Map<String, dynamic> career;
  String imageUrl;

  Player({
    required this.id,
    required this.name,
    required this.surname,
    required this.nationalityId,
    required this.actualTeamId,
    required this.positionId,
    required this.dateOfBirth,
    required this.dorsal,
    required this.height,
    required this.career,
    required this.imageUrl
  });

  factory Player.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Player(
      id: doc.id,
      name: data['name'],
      surname: data['surname'],
      nationalityId: data['nationality'],
      actualTeamId: data['actual_team'],
      positionId: data['position'],
      dateOfBirth: DateTime.parse(data['date_of_birth']),
      dorsal: data['dorsal'],
      height: data['height'],
      career: Map<String, dynamic>.from(data['career']),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'surname': surname,
      'nationality': nationalityId,
      'actual_team': actualTeamId,
      'position': positionId,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'dorsal': dorsal,
      'height': height,
      'career': career,
      'imageUrl': imageUrl,
    };
  }
}
