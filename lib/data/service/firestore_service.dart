import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirestoreService {
  // Add your Firestore service methods here
  Future<void> addFavoriteMovie(int movieId);
  Future<List<int>> getFavoriteMovies();
  Future<void> removeFavoriteMovie(int movieId);
}

class FirestoreServiceImpl implements FirestoreService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirestoreServiceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Future<void> addFavoriteMovie(int movieId) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      print(userId);
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_movies')
          .add({'movie_id': movieId});
    }
  }

  Future<List<int>> getFavoriteMovies() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_movies')
          .get();
      return snapshot.docs.map((doc) => doc['movie_id'] as int).toList();
    }
    return [];
  }

  Future<void> removeFavoriteMovie(int movieId) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_movies')
          .where('movie_id', isEqualTo: movieId)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
  }
}
