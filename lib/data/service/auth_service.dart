import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:state_managment/core/error/network_info.dart';

abstract class AuthService {
  get authStateChanges => null;
  Future<User?> login(String username, String password);
  Future<void> logout();
  Future<User?> register(String username, String password);
  Future<bool> isLoggedIn();
  Future<String?> getToken();
}

class AuthServiceImpl implements AuthService {
  final NetworkInfo networkInfo;
  final Dio dio;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<User?> login(String username, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: username, password: password);
      return userCredential.user;
    } catch (e) {
      // Handle login error
      rethrow;
    }
  }

  AuthServiceImpl({required this.networkInfo}) : dio = Dio();

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      // Handle registration error

      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    // Implement check for logged-in status
    return _auth.currentUser != null;
  }

  @override
  Future<String?> getToken() async {
    // Implement token retrieval logic
    return await _auth.currentUser?.getIdToken();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
