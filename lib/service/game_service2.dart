import 'package:royal_app/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GameService2 extends ChangeNotifier {
  DateTime? _careerPlayerCompletedAt;
  DateTime? _searchPlayerCompletedAt;
  Map<String, DateTime?> _completedDates = {};
  bool _gameCompleted = false;

  // Getters públicos para acceder a la información del estado del juego
  bool get gameCompleted => _gameCompleted;

  DateTime? get careerPlayerCompletedAt => _careerPlayerCompletedAt;

  DateTime? get searchPlayerCompletedAt => _searchPlayerCompletedAt;

  UserService? _userService;

  // Constructor de la clase, carga datos y programa el reinicio diario
  GameService2(this._userService) {
    _loadData();
    _scheduleDailyReset();
  }

  // Método para actualizar la referencia a UserService
  void updateUserService(UserService userService) {
    _userService = userService;
    notifyListeners();
  }

  // Carga datos desde SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _careerPlayerCompletedAt =
        DateTime.tryParse(prefs.getString('careerPlayerCompletedAt') ?? '');
    _searchPlayerCompletedAt =
        DateTime.tryParse(prefs.getString('searchPlayerCompletedAt') ?? '');
    _gameCompleted = prefs.getBool('gameCompleted') ?? false;
    _completedDates = Map.fromEntries(
        (prefs.getStringList('completedDates') ?? [])
            .map((dateStr) => MapEntry(dateStr, DateTime.tryParse(dateStr))));
    notifyListeners();
  }

  // Programa el reinicio diario de las tareas completadas
  void _scheduleDailyReset() {
    Timer.periodic(Duration(days: 1), (timer) {
      _resetDailyTasks();
      notifyListeners();
    });

    final now = DateTime.now();
    final startOfNextDay =
    DateTime(now.year, now.month, now.day).add(Duration(days: 1));
    final timeUntilNextReset = startOfNextDay.difference(now);

    // Inicializar el primer Timer para el primer reinicio
    Timer(timeUntilNextReset, () {
      _resetDailyTasks();
      notifyListeners();
    });
  }

  // Reinicia las tareas completadas del día actual
  void _resetDailyTasks() {
    final now = DateTime.now();
    final startOfNextDay =
    DateTime(now.year, now.month, now.day).add(Duration(days: 1));

    // Elimina tareas completadas antes del inicio del siguiente día
    _completedDates.removeWhere(
            (key, value) => value != null && value.isBefore(startOfNextDay));

    // Reinicia las fechas de completado de los juegos si es el nuevo día
    if (_careerPlayerCompletedAt != null &&
        !_isSameDay(now, _careerPlayerCompletedAt!)) {
      _careerPlayerCompletedAt = null;
    }
    if (_searchPlayerCompletedAt != null &&
        !_isSameDay(now, _searchPlayerCompletedAt!)) {
      _searchPlayerCompletedAt = null;
    }

    _saveData();
  }

  // Guarda datos en SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
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

  // Completa el juego 'searchPlayer'
  Future<void> completeSearchPlayerGame(bool success) async {
    final now = DateTime.now();

    if (_searchPlayerCompletedAt == null ||
        !_isSameDay(now, _searchPlayerCompletedAt!)) {
      _searchPlayerCompletedAt = now;
      _gameCompleted = success;
      if (success) {
        if (_userService?.userData != null) {
          await _userService!
              .updateUserPoints(_userService!.userData!.points + 1);
        }
      }
      _completedDates[now.toIso8601String()] = now;
      await _saveData();
      notifyListeners();
    }
  }

  // Completa el juego 'careerPlayer'
  Future<void> completeCareerPlayerGame(bool success) async {
    final now = DateTime.now();

    if (_careerPlayerCompletedAt == null ||
        !_isSameDay(now, _careerPlayerCompletedAt!)) {
      _careerPlayerCompletedAt = now;
      _gameCompleted = success;
      if (success) {
        if (_userService?.userData != null) {
          await _userService!
              .updateUserPoints(_userService!.userData!.points + 1);
        }
      }
      _completedDates[now.toIso8601String()] = now;
      await _saveData();
      notifyListeners();
    }
  }

  // Verifica si un juego está disponible para jugar
  bool isGameAvailable(String game) {
    final now = DateTime.now();

    if (game == 'careerPlayer') {
      return _careerPlayerCompletedAt == null ||
          !_isSameDay(now, _careerPlayerCompletedAt!);
    } else if (game == 'searchPlayer') {
      return _searchPlayerCompletedAt == null ||
          !_isSameDay(now, _searchPlayerCompletedAt!);
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
      final nextAvailableTime = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(Duration(days: 1));
      return nextAvailableTime.difference(now);
    } else {
      final startOfNextDay =
      DateTime(now.year, now.month, now.day).add(Duration(days: 1));
      return startOfNextDay.difference(now);
    }
  }

  // Verifica si dos fechas son del mismo día
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
