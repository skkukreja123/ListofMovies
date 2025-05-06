import 'package:flutter/material.dart';
import 'package:state_managment/data/service/movie_service.dart';
import '../model/movie.dart';
import '../core/error/failure.dart';

class MovieViewModel extends ChangeNotifier {
  final MovieService movieService;
  MovieViewModel(this.movieService);

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> getNowPlayingMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _movies = await movieService.getNowPlayingMovies();
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
}
