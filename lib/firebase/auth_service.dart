import 'package:firebase_auth/firebase_auth.dart';
import 'package:royal_app/firebase/firestore_service.dart';
import 'package:royal_app/models/user_auth.dart';
import 'package:royal_app/models/user_profile.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Crear objeto UserAuth con los datos básicos
      UserAuth userAuth = UserAuth(
        id: userCredential.user!.uid,
        email: email,
      );

      // Crear objeto UserProfile con datos iniciales
      UserProfile userProfile = UserProfile(
        id: userCredential.user!.uid,
        email: email,
      );

      // Guardar documentos en Firestore
      await _firestoreService.createUserDocument(userAuth);
      await _firestoreService.createUserProfile(userProfile);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Future<void> deleteUserAccount() async {
    try {
      User user = _auth.currentUser!;
      await _firestoreService.deleteUserProfile(user.uid);
      await _firestoreService.deleteUserDocument(user.uid);
      await user.delete();
    } catch (e) {
      print('Error deleting user account: $e');
      throw e;
    }
  }
}
