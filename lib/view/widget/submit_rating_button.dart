import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:state_managment/data/service/rating_service.dart';
import 'package:state_managment/model/movie.dart';

class SubmitRatingButton extends StatelessWidget {
  final Movie movie;
  final double rating;

  const SubmitRatingButton({
    Key? key,
    required this.movie,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          try {
            final ratingService = RatingService(
                dio: Dio()); // Assuming Dio is imported and available

            final guestSessionId = await ratingService.createGuestSession();
            if (guestSessionId == null || guestSessionId.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to create guest session.'),
                ),
              );
              return;
            }
            final response = await ratingService.rateMovie(movie.id, rating,
                guestSessionId); // Use the actual guest session ID
            if (response.statusCode == 201) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Rating submitted successfully!'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to submit rating. Please try again.'),
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to submit rating: $e'),
              ),
            );
          }
        },
        child: Text('Submit Rating'),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ));
  }
}
