import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  String id;
  String name;
  String president;
  String teamImageUrl;
  String presidentImageUrl;

  Team({
    required this.id,
    required this.name,
    required this.president,
    required this.teamImageUrl,
    required this.presidentImageUrl,
  });

  factory Team.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Team(
      id: doc.id,
      name: data['name'],
      president: data['president'],
      teamImageUrl: data['teamImageUrl'],
      presidentImageUrl: data['presidentImageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'president': president,
      'teamImageUrl': teamImageUrl,
      'presidentImageUrl': presidentImageUrl,
    };
  }
}
