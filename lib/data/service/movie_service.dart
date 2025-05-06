import 'package:state_managment/core/error/failure.dart';
import 'package:state_managment/core/error/network_info.dart';
import 'package:state_managment/model/movie.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv package
import 'package:dio/dio.dart'; // Import dio package

abstract class MovieService {
  Future<List<Movie>> getNowPlayingMovies();
}

class MovieServiceImpl implements MovieService {
  final NetworkInfo networkInfo;
  final Dio dio;

  MovieServiceImpl({required this.networkInfo}) : dio = Dio();

  Future<List<Movie>> getNowPlayingMovies() async {
    await dotenv.load();
    if (!await networkInfo.isConnected) {
      throw NetworkFailure('No Internet Connection');
    }

    final apiKey = dotenv.env['TMDB_API_KEY']; // Get API key from .env
    if (apiKey == null || apiKey.isEmpty) {
      throw ServerFailure('API key not found in .env');
    }

    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey',
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final List results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw ServerFailure('Failed to load movies: ${response.statusCode}');
    }
  }
}
