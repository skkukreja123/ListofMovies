import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../helper/movie_image.dart';
import '../../helper/star_rating.dart';
import '../../model/movie.dart';
import '../../ui/style/text_style.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({required this.movie, super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double _rating = 1.0; // Initial rating is 1.0
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("Movie details:");
    print("ID: ${widget.movie.id}");
    print("Title: ${widget.movie.title}");
    print("Original Title: ${widget.movie.originalTitle}");
    print("Overview: ${widget.movie.overview}");
    print("Release Date: ${widget.movie.releaseDate}");
    print("Poster: ${widget.movie.posterPath}");
    print("Backdrop: ${widget.movie.backdropPath}");
    print("Vote Avg: ${widget.movie.voteAverage}");
    print("Vote Count: ${widget.movie.voteCount}");
    print("Genres: ${widget.movie.genreIds.join(', ')}");
    print("Adult: ${widget.movie.adult}");
    print("Language: ${widget.movie.originalLanguage}");
    print("Video: ${widget.movie.video}");
    print("Popularity: ${widget.movie.popularity}");
  }

  Widget detailText(String label, String value) {
    return Text('$label: $value', style: AppTextStyles.bold16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MovieImage(posterPath: widget.movie.posterPath),
            const SizedBox(height: 16),
            Text(widget.movie.overview, style: AppTextStyles.normal),
            const SizedBox(height: 16),
            detailText('Release Date', widget.movie.releaseDate),
            const SizedBox(height: 8),
            Text('Rating:', style: AppTextStyles.bold16),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1.0,
              maxRating: 2.0,
              allowHalfRating: true,
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 36,
              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              updateOnDrag: true,
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = double.parse(rating.toStringAsFixed(1));
                });
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Selected: ${_rating.toStringAsFixed(1)} ⭐',
                style: AppTextStyles.bold16,
              ),
            ),
            detailText('Genre IDs', widget.movie.genreIds.join(', ')),
            const SizedBox(height: 8),
            detailText('Original Title', widget.movie.originalTitle),
            const SizedBox(height: 8),
            detailText('Vote Count', widget.movie.voteCount.toString()),
            const SizedBox(height: 8),
            detailText('Adult', widget.movie.adult.toString()),
            const SizedBox(height: 8),
            detailText('Language', widget.movie.originalLanguage),
            const SizedBox(height: 8),
            detailText('Video', widget.movie.video.toString()),
            const SizedBox(height: 8),
            detailText('Popularity', widget.movie.popularity.toString()),
            const SizedBox(height: 16),
            const Text('Leave a Review', style: AppTextStyles.bold16),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Write your review...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
