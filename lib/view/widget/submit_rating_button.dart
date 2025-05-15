import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_managment/data/service/rating_service.dart';
import 'package:state_managment/model/movie.dart';
import 'package:state_managment/model/specfic_movie.dart';
import 'package:state_managment/viewmodel/movie_view.dart';

class SubmitRatingButton extends StatelessWidget {
  final MovieSpecific movie;
  final double rating;
  final String review;

  const SubmitRatingButton({
    Key? key,
    required this.movie,
    required this.rating,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MovieViewModel>(context);
    return ElevatedButton(
        onPressed: () async {
          try {
            await vm.addMovieRatingAndReview(movie.id, rating, review);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Rating submitted successfully!'),
              ),
            );
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
