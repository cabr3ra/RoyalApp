import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:royal_app/models/player.dart';
import 'package:royal_app/models/user_auth.dart';
import 'package:royal_app/models/user_profile.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Crear documento de 'users' en Firestore
  Future<void> createUserDocument(UserAuth user) async {
    await _db.collection('users').doc(user.id).set({
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Crear documento de 'userProfiles' en Firestore
  Future<void> createUserProfile(UserProfile userProfile) async {
    await _db
        .collection('usersProfiles')
        .doc(userProfile.id)
        .set(userProfile.toFirestore());
  }

  // Obtener datos del 'users' por su ID
  Future<UserAuth> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _db.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return UserAuth(
          id: userId,
          email: userDoc['email'] ?? '',
        );
      } else {
        throw 'Usuario no encontrado con ID: $userId';
      }
    } catch (e) {
      print('Error obteniendo datos del usuario: $e');
      throw e;
    }
  }

  // Obtener datos del 'userProfiles' por su ID
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc =
          await _db.collection('usersProfiles').doc(uid).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      } else {
        throw 'Perfil de usuario no encontrado con ID: $uid';
      }
    } catch (e) {
      print('Error obteniendo perfil del usuario: $e');
      throw e;
    }
  }

  // Actualizar 'userProfiles' en Firestore
  Future<void> updateUserProfile(UserProfile userProfile) async {
    await _db
        .collection('usersProfiles')
        .doc(userProfile.id)
        .update(userProfile.toFirestore());
  }

  // Eliminar documento de 'users' en Firestore
  Future<void> deleteUserDocument(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user document: $e');
      throw e;
    }
  }

  // Eliminar documento de 'userProfiles' en Firestore
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _db.collection('userProfiles').doc(userId).delete();
    } catch (e) {
      print('Error deleting user profile: $e');
      throw e;
    }
  }

  // Obtener todos los usuarios
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final QuerySnapshot snapshot = await _db.collection('users').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

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
      print('Error getting random player: $e');
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
      print('Error searching players: $e');
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
      print('Error getting position abbreviation: $e');
      return '';
    }
  }
}
