import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:royal_app/models/player.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtener todos los jugadores
  Future<List<Player>> getAllPlayers() async {
    final QuerySnapshot snapshot = await _db.collection('players').get();
    return snapshot.docs.map((doc) => Player.fromFirestore(doc)).toList();
  }

  // Obtener un jugador aleatorio
  Future<Player> getRandomPlayer() async {
    try {
      QuerySnapshot snapshot = await _db.collection('players').get();
      if (snapshot.docs.isEmpty) {
        throw 'No hay jugadores registrados';
      }
      int randomIndex = Random().nextInt(snapshot.docs.length);
      DocumentSnapshot randomPlayerDoc = snapshot.docs[randomIndex];
      return Player.fromFirestore(randomPlayerDoc);
    } catch (e) {
      print('Error obteniendo jugador aleatorio: $e');
      rethrow;
    }
  }

  // Buscar jugadores por nombre o apellido
  Future<List<Player>> searchPlayers(String query) async {
    try {
      print('Buscando jugadores con el query: $query');
      List<Player> allPlayers = await getAllPlayers();

      // Filtrar por nombre y apellido
      List<Player> filteredPlayers = allPlayers.where((player) {
        return player.name.toLowerCase().contains(query.toLowerCase()) ||
            player.surname.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (filteredPlayers.isEmpty) {
        print('No se encontraron jugadores');
      } else {
        print('Jugadores encontrados: ${filteredPlayers.length}');
      }

      return filteredPlayers;
    } catch (e) {
      print('Error buscando jugadores: $e');
      throw e;
    }
  }

  // Obtener datos de la carrera de un jugador por su ID
  Future<Map<String, dynamic>> getPlayerCareer(String playerId) async {
    try {
      DocumentSnapshot playerDoc =
          await _db.collection('players').doc(playerId).get();
      if (playerDoc.exists) {
        Map<String, dynamic> careerData = playerDoc.get('career');
        return careerData;
      } else {
        throw 'Jugador no encontrado con ID: $playerId';
      }
    } catch (e) {
      print('Error obteniendo datos de la carrera del jugador: $e');
      throw e;
    }
  }

  // Obtener abreviatura de posición
  Future<String> getPositionAbb(String positionId) async {
    try {
      DocumentSnapshot positionDoc =
          await _db.collection('positions').doc(positionId).get();
      if (positionDoc.exists) {
        return positionDoc['abbreviation'];
      } else {
        return '';
      }
    } catch (e) {
      print('Error obteniendo abreviatura de posición: $e');
      return '';
    }
  }

  // Método para actualizar el estado del juego en Firestore
  Future<void> updateGameStatus(
      String userId, String game, bool completed) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('games')
        .doc(game)
        .set({
      'completed': completed,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Método para obtener el estado del juego
  Future<Map<String, dynamic>> getGameStatus(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> searchPlayerDoc = await _db
        .collection('users')
        .doc(userId)
        .collection('games')
        .doc('searchPlayer')
        .get();

    DocumentSnapshot<Map<String, dynamic>> careerPlayerDoc = await _db
        .collection('users')
        .doc(userId)
        .collection('games')
        .doc('careerPlayer')
        .get();

    return {
      'searchPlayer': searchPlayerDoc.data() ?? {},
      'careerPlayer': careerPlayerDoc.data() ?? {},
    };
  }
}
