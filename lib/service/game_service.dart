import 'package:royal_app/service/user_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GameService extends ChangeNotifier {
  int _playerPoints = 0;
  DateTime? _careerPlayerCompletedAt;
  DateTime? _searchPlayerCompletedAt;
  Map<String, DateTime?> _completedDates = {};
  bool _gameCompleted = false;

  // Getters públicos para acceder a la información del estado del juego
  int get playerPoints => _playerPoints;

  DateTime? get careerPlayerCompletedAt => _careerPlayerCompletedAt;

  DateTime? get searchPlayerCompletedAt => _searchPlayerCompletedAt;

  bool get gameCompleted => _gameCompleted;

  final UserProfileService _userProfileService;

  // Constructor de la clase, carga datos y programa el reinicio diario
  GameService(this._userProfileService) {
    _loadData();
    _scheduleDailyReset();
  }

  // Carga datos desde SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _playerPoints = prefs.getInt('playerPoints') ?? 0;
    _careerPlayerCompletedAt =
        DateTime.tryParse(prefs.getString('careerPlayerCompletedAt') ?? '');
    _searchPlayerCompletedAt =
        DateTime.tryParse(prefs.getString('searchPlayerCompletedAt') ?? '');
    _gameCompleted = prefs.getBool('gameCompleted') ?? false;
    _completedDates = (prefs.getStringList('completedDates') ?? [])
        .asMap()
        .map((_, dateStr) => MapEntry(
              dateStr,
              DateTime.tryParse(dateStr),
            ));
    notifyListeners();
  }

  // Programa el reinicio diario de las tareas completadas
  void _scheduleDailyReset() {
    Timer.periodic(Duration(days: 1), (timer) {
      _resetDailyTasks();
      notifyListeners();
    });

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final timeUntilNextReset =
        startOfDay.add(Duration(days: 1)).difference(now);

    // Inicializar el primer Timer para el primer reinicio
    Timer(timeUntilNextReset, () {
      _resetDailyTasks();
      notifyListeners();
    });
  }

  // Reinicia las tareas completadas del día actual
  void _resetDailyTasks() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    // Elimina tareas completadas antes del inicio del día actual
    _completedDates.removeWhere(
        (key, value) => value != null && value.isBefore(startOfDay));

    _saveData();
  }

  // Guarda datos en SharedPreferences
  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('playerPoints', _playerPoints);
    prefs.setString('careerPlayerCompletedAt',
        _careerPlayerCompletedAt?.toIso8601String() ?? '');
    prefs.setString('searchPlayerCompletedAt',
        _searchPlayerCompletedAt?.toIso8601String() ?? '');
    prefs.setBool('gameCompleted', _gameCompleted);
    prefs.setStringList(
      'completedDates',
      _completedDates.values
          .where((date) => date != null)
          .map((date) => date!.toIso8601String())
          .toList(),
    );
  }

  // Marca la tarea de búsqueda de jugador como completada
  void completeSearchPlayerGame(bool success) {
    final now = DateTime.now();
    print('Complete Search Player Game Called: $success');
    print('Current Time: $now');

    if (_searchPlayerCompletedAt == null ||
        now.difference(_searchPlayerCompletedAt!).inDays >= 1) {
      _searchPlayerCompletedAt = now;
      _gameCompleted = success;
      if (success) {
        _playerPoints++;
        _userProfileService.updateUserPoints(_playerPoints);
      }
      _completedDates[now.toIso8601String()] = now;
      _saveData();
      notifyListeners();
    }
  }

  // Marca la tarea de carrera de jugador como completada
  void completeCareerPlayerGame(bool success) {
    final now = DateTime.now();
    print('Complete Career Player Game Called: $success');
    print('Current Time: $now');

    if (_careerPlayerCompletedAt == null ||
        now.difference(_careerPlayerCompletedAt!).inDays >= 1) {
      _careerPlayerCompletedAt = now;
      _gameCompleted = success;
      if (success) {
        _playerPoints++;
        _userProfileService.updateUserPoints(_playerPoints);
      }
      _completedDates[now.toIso8601String()] = now;
      _saveData();
      notifyListeners();
    }
  }

  // Verifica si un juego está disponible para jugar
  bool isGameAvailable(String game) {
    final now = DateTime.now();
    if (game == 'careerPlayer') {
      return _careerPlayerCompletedAt == null ||
          now.difference(_careerPlayerCompletedAt!).inDays >= 1;
    } else if (game == 'searchPlayer') {
      return _searchPlayerCompletedAt == null ||
          now.difference(_searchPlayerCompletedAt!).inDays >= 1;
    } else {
      throw ArgumentError('Invalid game type');
    }
  }

  // Obtiene el tiempo restante hasta que una tarea esté disponible
  Duration getTimeUntilNextAvailable(String task) {
    final now = DateTime.now();
    DateTime? lastCompleted;

    if (task == 'careerPlayer') {
      lastCompleted = _careerPlayerCompletedAt;
    } else if (task == 'searchPlayer') {
      lastCompleted = _searchPlayerCompletedAt;
    } else {
      throw ArgumentError('Invalid task type');
    }

    if (lastCompleted != null) {
      final nextAvailableTime = lastCompleted.add(Duration(days: 1));
      return nextAvailableTime.difference(now);
    } else {
      return Duration(days: 1);
    }
  }
}
