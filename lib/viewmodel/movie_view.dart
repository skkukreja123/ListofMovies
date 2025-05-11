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

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  MovieSpecific _movieDetails = MovieSpecific.empty();
  MovieSpecific get movieDetails => _movieDetails;

  Future<void> getMovieDetails(int movieId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _movieDetails = await movieRepository.getMovieDetails(movieId);
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
}
