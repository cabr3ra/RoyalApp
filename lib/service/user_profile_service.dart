import 'package:flutter/material.dart';
import 'package:royal_app/firebase/auth_service.dart';
import 'package:royal_app/models/user_profile.dart';
import 'package:royal_app/firebase/firestore_service.dart';

class UserProfileService with ChangeNotifier {
  final FirestoreService _firestoreService;
  final AuthService _authService;
  UserProfile? _userProfile;

  UserProfileService(this._firestoreService, this._authService) {
    _loadUserProfile();
  }

  UserProfile? get userProfile => _userProfile;

  Future<void> _loadUserProfile() async {
    final user = _authService.currentUser;
    if (user != null) {
      _userProfile = await _firestoreService.getUserProfile(user.uid);
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(String name, int age) async {
    if (_userProfile != null) {
      _userProfile!.name = name;
      _userProfile!.age = age;
      await _firestoreService.updateUserProfile(_userProfile!);
      notifyListeners();
    }
  }

  Future<void> updateUserPoints(int points) async {
    if (_userProfile != null) {
      _userProfile!.points = points;
      await _firestoreService.updateUserProfile(_userProfile!);
      notifyListeners();
    }
  }

}
