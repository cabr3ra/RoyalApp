import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Obtener URL de imagen de jugador
  Future<String> getPlayerImageUrl(String name, String surname) async {
    try {
      String fileName = '${name.toLowerCase()}_${surname.toLowerCase()}.png';
      String filePath = 'players/$fileName';
      String downloadURL = await _storage.ref(filePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error getting player image URL: $e');
      return '';
    }
  }

  // Obtener URL de imagen de nacionalidad
  Future<String> getNationalityImageUrl(String nationalityId) async {
    try {
      String filePath = 'nationalities/$nationalityId.png';
      String downloadURL = await _storage.ref(filePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error getting nationality image URL: $e');
      return '';
    }
  }

  // Obtener URL de imagen de equipo
  Future<String> getTeamImageUrl(String teamId) async {
    try {
      String filePath = 'teams/$teamId.png';
      String downloadURL = await _storage.ref(filePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error getting team image URL: $e');
      return '';
    }
  }
}
