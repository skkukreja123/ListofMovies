import 'package:firebase_auth/firebase_auth.dart';
import 'package:state_managment/data/service/firestore_service.dart';

abstract class FireStoreRepository {
  Future<void> addFavoriteMovie(int movieId);
  Future<List<int>> getFavoriteMovies();
  Future<void> removeFavoriteMovie(int movieId);
  Future<void> addMovieThroughGenre(
      String genre, int movieId, String posterPath);
  Future<void> removeMovieThroughGenre(String genre, int movieId);
  Future<List<Map<String, dynamic>>> getAllGenreCounts();
}

class FireStoreRepositoryImpl implements FireStoreRepository {
  final FirestoreService _firestoreService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FireStoreRepositoryImpl({
    required FirestoreServiceImpl firestoreService,
  }) : _firestoreService = firestoreService;

  @override
  Future<void> addFavoriteMovie(int movieId) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      print(userId);
      await _firestoreService.addFavoriteMovie(movieId);
    }
  }

  @override
  Future<List<int>> getFavoriteMovies() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      return await _firestoreService.getFavoriteMovies();
    }
    return [];
  }

  @override
  Future<void> removeFavoriteMovie(int movieId) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _firestoreService.removeFavoriteMovie(movieId);
    }
  }

  @override
  Future<void> addMovieThroughGenre(
      String genre, int movieId, String posterPath) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _firestoreService.addMovieThroughGenre(
        genre,
        movieId,
        posterPath,
      );
      // await _firestoreService.incrementGenreCount(genre);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllGenreCounts() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      return await _firestoreService.getAllGenreCounts();
    }
    return [];
  }

  @override
  Future<void> removeMovieThroughGenre(String genre, int movieId) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _firestoreService.removeMovieThroughGenre(genre, movieId);
      await _firestoreService.decrementGenreCount(genre);
    }
  }
}
