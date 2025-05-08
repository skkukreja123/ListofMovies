import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class IRatingService {
  Future<String> createGuestSession();
  Future<Response> rateMovie(int movieId, double rating, String sessionId);
}

class RatingService implements IRatingService {
  final Dio dio;

  RatingService({required this.dio});

  @override
  Future<String> createGuestSession() async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    final questtoken = dotenv.env['guest_token'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key not found in .env');
    }

    final response = await dio.post(
      'https://api.themoviedb.org/3/authentication/guest_session/new?api_key=$apiKey',
      options: Options(
        headers: {
          'Content-Type': 'application/json;charset=utf-8',
          'Authorization': 'Bearer ${dotenv.env['guest_token']}',
        },
      ),
    );

    final data = response.data;
    if (data['success']) {
      print(data['guest_session_id']);
      return data['guest_session_id'];
    } else {
      throw Exception('Failed to create guest session');
    }
  }

  @override
  Future<Response> rateMovie(
      int movieId, double rating, String guestSessionId) async {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    final sessionId = guestSessionId;

    if (sessionId == null || sessionId.isEmpty) {
      throw Exception('Session ID not found in .env');
    }
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key not found in .env');
    }

    final response = await dio.post(
      'https://api.themoviedb.org/3/movie/$movieId/rating?api_key=$apiKey&guest_session_id=$sessionId',
      data: jsonEncode({'value': rating * 2}),
      options: Options(
        headers: {'Content-Type': 'application/json;charset=utf-8'},
      ),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to rate movie: ${response.statusCode}');
      return response;
    }
    return response;
  }
}
