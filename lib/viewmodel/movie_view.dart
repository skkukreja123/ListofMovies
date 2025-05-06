import 'package:flutter/material.dart';
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

  String? _error;
  String? get error => _error;

  Future<void> getNowPlayingMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _movies = await movieRepository.getNowPlayingMovies();
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
