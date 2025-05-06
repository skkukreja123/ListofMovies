import 'package:state_managment/core/error/failure.dart';
import 'package:state_managment/core/error/network_info.dart';

import '../../model/movie.dart';
import 'package:state_managment/data/service/movie_service.dart';
import 'package:state_managment/model/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getNowPlayingMovies();
}

class MovieRepositoryImpl implements MovieRepository {
  final MovieService service;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.service,
    required this.networkInfo,
  });

  @override
  Future<List<Movie>> getNowPlayingMovies() async {
    if (!await networkInfo.isConnected) {
      throw NetworkFailure('No Internet Connection');
    }
    return await service.getNowPlayingMovies();
  }
}
