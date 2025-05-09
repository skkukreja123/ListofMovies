import 'package:flutter/material.dart';
import 'package:state_managment/data/service/movie_service.dart';
import 'package:state_managment/model/movie.dart';
import 'package:state_managment/core/error/failure.dart';
import 'package:state_managment/resporitory/movie_resporitory.dart';

class MovieViewModel extends ChangeNotifier {
  final MovieRepository movieRepository;
  MovieViewModel(this.movieRepository);

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

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
}
