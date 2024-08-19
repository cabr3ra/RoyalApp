import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:royal_app/models/user_data.dart';

class UserService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserData? _userData;

  // Método para actualizar la instancia de FirebaseFirestore
  void updateFirestore(FirebaseFirestore firestore) {
    loadUserData();
    notifyListeners();
  }

  // Método para registrar un nuevo usuario
  Future<String?> signUp(String email, String password) async {
    try {
      // Crear el usuario en Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enviar correo de verificación
      await userCredential.user!.sendEmailVerification();

      // Crear un perfil de usuario inicial en Firestore
      UserData user = UserData(
        id: userCredential.user!.uid,
        email: email,
        username: '',
        points: 0,
      );

      await _firestore.collection('users').doc(user.id).set(user.toFirestore());

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'El correo electrónico ya está en uso.';
        case 'invalid-email':
          return 'El correo electrónico no es válido.';
        case 'weak-password':
          return 'La contraseña es demasiado débil.';
        default:
          return 'Error al registrar el usuario. Inténtelo de nuevo.';
      }
    } catch (e) {
      return 'Error desconocido: ${e.toString()}';
    }
  }

  // Método para iniciar sesión con un usuario existente
  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCredential.user!.emailVerified) {
        return 'Por favor, verifica tu correo electrónico antes de iniciar sesión.';
      }

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuario no encontrado.';
        case 'wrong-password':
          return 'Contraseña incorrecta.';
        default:
          return 'Error al iniciar sesión. Inténtelo de nuevo.';
      }
    } catch (e) {
      return 'Error desconocido: ${e.toString()}';
    }
  }


  // Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Getter para obtener el usuario actualmente autenticado
  User? get currentUser => _auth.currentUser;

  // Getter para escuchar los cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Getter público para obtener los datos del usuario
  UserData? get userData => _userData;

  // Método para obtener los datos de un usuario específico desde Firestore
  Future<UserData> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return UserData.fromFirestore(doc);
  }

  // Método para actualizar el perfil del usuario
  Future<String?> updateUser({
    required String username,
    required int points,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      return 'No hay usuario autenticado.';
    }

    try {
      DocumentReference userRef = _firestore.collection('users').doc(user.uid);
      await userRef.update({
        'username': username,
        'points': points,
      });

      return null;
    } catch (e) {
      print('Error actualizando el perfil del usuario: $e');
      return 'Error al actualizar el perfil.';
    }
  }

  // Método para eliminar un usuario
  Future<String?> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      return null;
    } catch (e) {
      print('Error eliminando el usuario: $e');
      return 'Error al eliminar el usuario.';
    }
  }

  // Método para cargar los datos del perfil del usuario
  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      _userData = UserData.fromFirestore(doc);
      notifyListeners();
    }
  }

  // Método para obtener todos los usuarios
  Future<List<UserData>> getAllUsers() async {
    final QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => UserData.fromFirestore(doc)).toList();
  }

  // Función para actualizar solo el nombre del usuario
  Future<void> updateUserName(String username) async {
    if (_userData != null) {
      await updateUser(username: username, points: _userData!.points);
    }
  }

  // Función para actualizar solo los puntos del usuario
  Future<void> updateUserPoints(int points) async {
    if (_userData != null) {
      await updateUser(username: _userData!.username, points: points);
    }
  }

  // Método para obtener el conteo de usuarios
  Future<int> getUserCount() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('users').get();
      int userCount = snapshot.size;

      print('Total de usuarios: $userCount');

      return userCount;
    } catch (e) {
      print('Error al obtener el conteo de usuarios: $e');
      return 0;
    }
  }
}
