import 'package:flutter/material.dart'; // UI
import '../../model/movie.dart'; // Movie model

class DetailScreen extends StatelessWidget {
  final Movie movie;

  DetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              ),
              SizedBox(height: 16),
              Text(movie.overview),
              SizedBox(height: 16),
              Text(
                'Release Date: ${movie.releaseDate}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Rating: ${movie.voteAverage}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'genreIds: ${movie.genreIds.join(', ')}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
