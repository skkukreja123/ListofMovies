import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:state_managment/core/error/failure.dart';
import 'package:state_managment/core/error/network_info.dart';
import 'package:state_managment/data/service/movie_service.dart';
import 'package:state_managment/model/movie.dart';
import 'package:state_managment/resporitory/movie_resporitory.dart';

class MockMovieService extends Mock implements MovieService {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockMovieService mockService;
  late MockNetworkInfo mockNetworkInfo;
  late MovieRepositoryImpl repository;

  // Set up the mocks
  try {
    setUp(() {
      mockService = MockMovieService();
      mockNetworkInfo = MockNetworkInfo();

      repository = MovieRepositoryImpl(
        service: mockService,
        networkInfo: mockNetworkInfo,
      );
    });
  } catch (e) {
    log('Error in setUp: $e');
  }

  final testMovies = [
    Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Overview',
      posterPath: '/poster.jpg',
      backdropPath: '/backdrop.jpg',
      releaseDate: '2025-01-01',
      voteAverage: 7.5,
      voteCount: 100,
      genreIds: [28, 12],
    ),
  ];

  group('Movie Repository Tests', () {
    test('should return movies when internet is connected', () async {
      // Arrange: Mock the network status and movie service
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true); // Proper Future<bool> return
      when(mockService.getNowPlayingMovies())
          .thenAnswer((_) async => testMovies); // Proper movie fetch mock

      // Act: Call the repository method
      final result = await repository.getNowPlayingMovies();

      // Assert: Verify that the result is as expected
      expect(result, testMovies);
      verify(mockNetworkInfo.isConnected).called(1);
      verify(mockService.getNowPlayingMovies()).called(1);
    });

    test('should throw NetworkFailure when there is no internet', () async {
      // Arrange: Mock network failure (no internet)
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => false); // Mock to return `false`

      // Act & Assert: Ensure NetworkFailure is thrown when trying to fetch movies
      expect(
        () => repository.getNowPlayingMovies(),
        throwsA(isA<NetworkFailure>()
            .having((e) => e.message, 'message', 'No Internet')),
      );

      // Verify: Ensure that movie service was never called when there's no internet
      verify(mockNetworkInfo.isConnected).called(1);
      verifyNever(mockService.getNowPlayingMovies());
    });
  });
}
