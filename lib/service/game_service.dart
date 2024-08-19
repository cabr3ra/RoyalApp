import 'package:royal_app/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class GameService extends ChangeNotifier {
  bool _gameCompleted = false;

  // Getter públicos para acceder a la información del estado del juego
  bool get gameCompleted => _gameCompleted;

  UserService? _userService;

  // Constructor de la clase, carga datos
  GameService(this._userService) {
    _loadData();
  }

  // Método para actualizar la referencia a UserService
  void updateUserService(UserService userService) {
    _userService = userService;
    notifyListeners();
  }

  // Carga datos desde SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _gameCompleted = prefs.getBool('gameCompleted') ?? false;
    notifyListeners();
  }

  // Guarda datos en SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('gameCompleted', _gameCompleted);
  }

  // Completa el juego 'searchPlayer'
  Future<void> completeSearchPlayerGame(bool success) async {
    _gameCompleted = success;
    if (success) {
      if (_userService?.userData != null) {
        await _userService!
            .updateUserPoints(_userService!.userData!.points + 1);
      }
    }
    await _saveData();
    notifyListeners();
  }

  // Completa el juego 'careerPlayer'
  Future<void> completeCareerPlayerGame(bool success) async {
    _gameCompleted = success;
    if (success) {
      if (_userService?.userData != null) {
        await _userService!
            .updateUserPoints(_userService!.userData!.points + 1);
      }
    }
    await _saveData();
    notifyListeners();
  }

  // Verifica si un juego está disponible para jugar
  bool isGameAvailable(String game) {
    return true; // Siempre disponible
  }

  // Obtiene el tiempo restante hasta que una tarea esté disponible (si aplica)
  Duration getTimeUntilNextAvailable(String task) {
    return Duration.zero; // Siempre disponible
  }
}
