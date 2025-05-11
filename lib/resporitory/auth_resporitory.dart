import 'package:firebase_auth/firebase_auth.dart';
import 'package:state_managment/data/service/auth_service.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<User?> login(String username, String password);
  Future<void> logout();
  Future<User?> register(String username, String password);
  Future<bool> isLoggedIn();
  Future<String?> getToken();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  AuthRepositoryImpl({required AuthService authService})
      : _authService = authService;

  @override
  Future<User?> login(String username, String password) async {
    return await _authService.login(username, password);
  }

  @override
  Future<void> logout() async {
    await _authService.logout();
  }

  @override
  Future<User?> register(String username, String password) async {
    return await _authService.register(username, password);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  @override
  Future<String?> getToken() async {
    return await _authService.getToken();
  }
}
