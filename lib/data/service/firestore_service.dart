import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FirestoreService {
  // Add your Firestore service methods here
  Future<void> addFavoriteMovie(int movieId);
  Future<List<int>> getFavoriteMovies();
  Future<void> removeFavoriteMovie(int movieId);
  Future<void> addMovieThroughGenre(
      String genre, int movieId, String posterPath);
  Future<List<int>> getMovieThroughGenre(String genre);
  Future<void> removeMovieThroughGenre(String genre, int movieId);
  Future<List<Map<String, dynamic>>> getAllGenreCounts();
  Future<void> incrementGenreCount(String genre);
  Future<void> decrementGenreCount(String genre);
  Future<void> addMovieRatingAndReview(
      int movieid, double rating, String review);
  Future<List<Map<String, dynamic>>> getMovieRatingAndReview();
  Future<List<Map<String, dynamic>>> getRatingAndReview(int movieid);
  Future<void> updateMovieRatingAndReview(
      int movieid, double rating, String review);
}

class FirestoreServiceImpl implements FirestoreService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirestoreServiceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<void> addMovieRatingAndReview(
      int movieid, double rating, String review) async {
    final userId = _auth.currentUser?.uid;
    print(userId);
    if (userId != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('movie_rating_and_review')
          .where('movie_id', isEqualTo: movieid)
          .get();
      if (snapshot.docs.isEmpty) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('movie_rating_and_review')
            .add({
          'movie_id': movieid,
          'rating': rating,
          'review': review,
        });
      } else {
        for (var doc in snapshot.docs) {
          await doc.reference.update({
            'rating': rating,
            'review': review,
          });
        }
      }
    }
  }

  @override
  Future<void> updateMovieRatingAndReview(
      int movieid, double rating, String review) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('movie_rating_and_review')
          .where('movie_id', isEqualTo: movieid)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.update({
          'rating': rating,
          'review': review,
        });
      }
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMovieRatingAndReview() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('movie_rating_and_review')
          .get();
      return snapshot.docs
          .map((doc) => {
                'movie_id': doc['movie_id'],
                'rating': doc['rating'],
                'review': doc['review']
              })
          .toList();
    }
    return [];
  }

  @override
  Future<List<Map<String, dynamic>>> getRatingAndReview(int movieid) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('movie_rating_and_review')
          .where('movie_id', isEqualTo: movieid)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    }
    return [];
  }

  @override
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

  @override
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

  Future<void> addMovieThroughGenre(
      String genre, int movieId, String posterPath) async {
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
          'poster_path': posterPath,
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

  Future<List<Map<String, dynamic>>> getAllGenreCounts() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot =
        await _firestore.collection('users').doc(userId).collection('genres');

    final finalsnapshot = await snapshot.get();
    final List<Map<String, dynamic>> genreCounts = [];

    for (var doc in finalsnapshot.docs) {
      final data = doc.data();
      final genre = doc.id;
      final count = data['count'] ?? 0;
      final movieshot = await snapshot.doc(genre).collection('movies').get();
      print(genre);
      print(movieshot.docs.map((doc) => doc.data()));
      // for (var m in movieshot.docs) {
      //   print(m.data());
      // }
      List<String>? posterpath;
      List<int>? movieId;
      if (movieshot.docs.isNotEmpty) {
        posterpath = movieshot.docs
            .map((e) => e.data()['poster_path'] as String)
            .toList();
        movieId =
            movieshot.docs.map((e) => e.data()['movie_id'] as int).toList();
      }
      genreCounts.add({
        'genre': genre,
        'count': count,
        'movie_id': movieId,
        'poster_path': posterpath,
      });
    }
    return genreCounts;
  }

  Future<void> incrementGenreCount(String genre) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final genreRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('genres')
        .doc(genre);

    await genreRef
        .set({'count': FieldValue.increment(1)}, SetOptions(merge: true));
  }

  Future<void> decrementGenreCount(String genre) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final genreRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('genres')
        .doc(genre);

    await genreRef
        .set({'count': FieldValue.increment(-1)}, SetOptions(merge: true));
  }
}
