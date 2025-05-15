import 'package:state_managment/core/error/failure.dart';
import 'package:state_managment/core/error/network_info.dart';
import 'package:state_managment/model/movie.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

import '../../model/specfic_movie.dart';

abstract class MovieService {
  Future<List<Movie>> getNowPlayingMovies({int page = 1});
  Future<List<Movie>> searchMovies(String query);
  Future<MovieSpecific> getMovieDetails(int movieId);
}

class MovieServiceImpl implements MovieService {
  final NetworkInfo networkInfo;
  final Dio dio;

  MovieServiceImpl({required this.networkInfo}) : dio = Dio();

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    await dotenv.load();
    if (!await networkInfo.isConnected) {
      throw NetworkFailure('No Internet Connection');
    }

    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw ServerFailure('API key not found in .env');
    }

    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey&page=$page',
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final List results = data['results'];
      print('Results: $results');
      // Check if the response contains valid data
      print(results.map((json) => Movie.fromJson(json)).toList());
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw ServerFailure('Failed to load movies: ${response.statusCode}');
    }
  }

  @override
  Future<MovieSpecific> getMovieDetails(int movieId) async {
    await dotenv.load();
    if (!await networkInfo.isConnected) {
      throw NetworkFailure('No Internet Connection');
    }

    final apiKey = dotenv.env['TMDB_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw ServerFailure('API key not found in .env');
    }

    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey',
    );

    if (response.statusCode == 200) {
      final jsondata = response.data;
      // Check if the response contains valid data

      return MovieSpecific.fromJson(jsondata);
    } else {
      throw ServerFailure(
          'Failed to load movie details: ${response.statusCode}');
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    await dotenv.load();
    final apiKey = dotenv.env['TMDB_API_KEY']; // Get API key from .env
    if (apiKey == null || apiKey.isEmpty) {
      throw ServerFailure('API key not found in .env');
    }

    final response = await dio.get(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query');

    if (response.statusCode == 200) {
      final data = response.data;
      return List<Movie>.from(data['results'].map((x) => Movie.fromJson(x)));
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
