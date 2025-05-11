import 'package:state_managment/core/error/failure.dart';
import 'package:state_managment/core/error/network_info.dart';
import 'package:state_managment/model/specfic_movie.dart';

import '../../model/movie.dart';
import 'package:state_managment/data/service/movie_service.dart';
import 'package:state_managment/model/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlayingMovies({required int page});
  Future<List<Movie>> searchMovies(String query);
  Future<MovieSpecific> getMovieDetails(int movieId);
}

class MovieRepositoryImpl implements MovieRepository {
  final MovieService service;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.service,
    required this.networkInfo,
  });

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    if (!await networkInfo.isConnected) {
      throw NetworkFailure('No Internet Connection');
    }
    return await service.getNowPlayingMovies(page: page);
  }

  @override
  Future<MovieSpecific> getMovieDetails(int movieId) async {
    if (!await networkInfo.isConnected) {
      throw NetworkFailure('No Internet Connection');
    }
    return await service.getMovieDetails(movieId);
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (!await networkInfo.isConnected) {
      throw NetworkFailure('No Internet Connection');
    }
    return await service.searchMovies(query);
  }
}
