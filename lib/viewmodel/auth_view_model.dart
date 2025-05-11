import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:state_managment/core/error/failure.dart';
import 'package:state_managment/resporitory/auth_resporitory.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  User? _user;
  User? get user => _user;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authRepository.login(username, password);
      _error = null;
    } catch (e) {
      if (e is Failure) {
        _error = e.message;
      } else {
        _error = 'Unexpected error: $e';
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    print('Registering user: $username');
    print('Password: $password');

    try {
      await _authRepository.register(username, password);
      _error = null;
    } catch (e) {
      if (e is Failure) {
        _error = e.message;
      } else {
        _error = 'Unexpected error: $e';
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.logout();
      _error = null;
    } catch (e) {
      if (e is Failure) {
        _error = e.message;
      } else {
        _error = 'Unexpected error: $e';
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void listenAuthChanges() {
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        // User is logged in
        print('User is logged in: ${user.uid}');
        _user = user;
        notifyListeners();
      } else {
        // User is logged out
        print('User is logged out');
      }
    });
  }
}
