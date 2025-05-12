import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirestoreService {
  // Add your Firestore service methods here
  Future<void> addFavoriteMovie(int movieId);
  Future<List<int>> getFavoriteMovies();
  Future<void> removeFavoriteMovie(int movieId);
  Future<void> addMovieThroughGenre(String genre, int movieId);
  Future<List<int>> getMovieThroughGenre(String genre);
  Future<void> removeMovieThroughGenre(String genre, int movieId);
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

  Future<void> addMovieThroughGenre(String genre, int movieId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final genref = await _firestore
            .collection('users')
            .doc(userId)
            .collection('genres')
            .doc(genre);

        final movieDocRef = genref.collection('movies').doc(movieId.toString());
        await movieDocRef.set({
          'movie_id': movieId,
        });

        await genref.set({
          'count': FieldValue.increment(1),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<int>> getMovieThroughGenre(String genre) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('genres')
          .doc(genre)
          .collection('movies')
          .get();
      return snapshot.docs.map((doc) => doc['movie_id'] as int).toList();
    }
    return [];
  }

  Future<void> removeMovieThroughGenre(String genre, int movieId) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('genres')
          .doc(genre)
          .collection('movies')
          .where('movie_id', isEqualTo: movieId)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
  }
}
