import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:state_managment/data/service/firestore_service.dart';
import 'package:state_managment/data/service/movie_service.dart';
import 'package:state_managment/model/movie.dart';
import 'package:state_managment/core/error/failure.dart';
import 'package:state_managment/model/specfic_movie.dart';
import 'package:state_managment/resporitory/firestore_resporitory.dart';
import 'package:state_managment/resporitory/movie_resporitory.dart';

class MovieViewModel extends ChangeNotifier {
  final MovieRepository movieRepository;
  MovieViewModel(this.movieRepository);

  final FireStoreRepository _firestore = FireStoreRepositoryImpl(
    firestoreService:
        FirestoreServiceImpl(firestore: FirebaseFirestore.instance),
  );

  List<int> favoriteIds = [];

  Map<String, int> genreIds = {};

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  MovieSpecific _movieDetails = MovieSpecific.empty();
  MovieSpecific get movieDetails => _movieDetails;

  Future<void> getMovieDetails(int movieId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _movieDetails = await movieRepository.getMovieDetails(movieId);
      await fetchGenreCounts();
      print('Movie details: $_movieDetails');
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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int currentPage = 1;
  String? _error;

  bool _hasMore = true;

  String? get error => _error;

  Future<void> getNowPlayingMovies({bool isInitial = false}) async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    _error = null;
    if (isInitial) {
      _movies = [];
      _hasMore = true;
    }
    notifyListeners();

    try {
      final newmovies =
          await movieRepository.getNowPlayingMovies(page: currentPage);
      if (newmovies.isEmpty) {
        _hasMore = false;
      } else {
        _movies.addAll(newmovies);
        currentPage++;
      }
      await getFavoriteMovies();
      await fetchGenreCounts();
    } catch (e) {
      if (e is Failure) {
        _error = e.message;
      } else {
        _error = 'Unexpected error: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchMovies(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await movieRepository.searchMovies(query);
      _movies = results;
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

  Future<void> toggleFavorite(int movieId) async {
    if (favoriteIds.contains(movieId)) {
      await _firestore.removeFavoriteMovie(movieId);
      favoriteIds.remove(movieId);
    } else {
      await _firestore.addFavoriteMovie(movieId);
      print(movieId);
      favoriteIds.add(movieId);
    }
    notifyListeners();
  }

  Future<void> getFavoriteMovies() async {
    favoriteIds = await _firestore.getFavoriteMovies();
    notifyListeners();
  }

  List<Map<String, dynamic>> genreCounts = [];
  List<Map<String, dynamic>> get getGenreCounts => genreCounts;

  Future<void> fetchGenreCounts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch your data (e.g., from Firestore)
      genreCounts = await _firestore.getAllGenreCounts();
      print(genreCounts);
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMovieThroughGenre(
      String genre, int movieId, String posterPath) async {
    try {
      final existingEntry = genreCounts.firstWhere(
        (entry) =>
            entry['genre'] == genre &&
            (entry['movie_id'] as List).contains(movieId),
        orElse: () => {},
      );
      print('Existing entry: $existingEntry');
      if (existingEntry.isNotEmpty) {
        // Both genre and movieId match, so remove
        await _firestore.removeMovieThroughGenre(genre, movieId);

        // genreCounts.remove
        print('Removed movie from genre: $genre');
      } else {
        // Either genre is new or movieId is different, so add/update
        print('Adding movie through genre: $genre');
        print('Movie ID: $movieId');
        await _firestore.addMovieThroughGenre(genre, movieId, posterPath);
      }
      notifyListeners();
    } catch (e) {
      print('Error in addMovieThroughGenre: $e');
    }
  }
}
