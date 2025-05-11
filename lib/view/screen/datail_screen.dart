import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:state_managment/view/widget/submit_rating_button.dart';
import 'package:state_managment/viewmodel/movie_view.dart';
import '../../helper/movie_image.dart';

import '../../model/movie.dart';
import '../../ui/style/text_style.dart';

class DetailScreen extends StatefulWidget {
  final int movieid;

  const DetailScreen({required this.movieid, super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double _rating = 1.0; // Initial rating is 1.0
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the loading state
    _isLoading = true;
    final vm = Provider.of<MovieViewModel>(context, listen: false);
    vm.getMovieDetails(widget.movieid).then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print('Error fetching movie details: $error');
      }
    });
  }

  Future<void> _refreshDetail() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  Widget detailText(String label, String value) {
    return Text('$label: $value', style: AppTextStyles.bold16);
  }

  @override
  Widget build(BuildContext context) {
    final movie = Provider.of<MovieViewModel>(context).movieDetails;
    print('Movie ID: ${widget.movieid}');
    print('Movie Details: $movie');
    return Scaffold(
        appBar: AppBar(title: Text('Movie Details')),
        body: RefreshIndicator(
          onRefresh: _refreshDetail,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MovieImage(posterPath: movie.posterPath),
                      const SizedBox(height: 16),
                      Text(movie.overview, style: AppTextStyles.normal),
                      const SizedBox(height: 16),
                      detailText('Release Date', movie.releaseDate),
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
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
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
                      // detailText('Genres',
                      //     // movie.genres?.map((g) => g.name).join(', ') ?? 'N/A'),
                      // const SizedBox(height: 8),
                      detailText('Original Title', movie.originalTitle),
                      const SizedBox(height: 8),
                      detailText('Vote Count', movie.voteCount.toString()),
                      const SizedBox(height: 8),
                      detailText('Adult', movie.adult.toString()),
                      const SizedBox(height: 8),
                      detailText('Language', movie.originalLanguage),
                      const SizedBox(height: 8),
                      detailText('Video', movie.video.toString()),
                      const SizedBox(height: 8),
                      detailText('Popularity', movie.popularity.toString()),
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
                      // Genres
                      if (movie.genres.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                            'Genres: ${movie.genres.map((g) => g.name).join(', ')}',
                            style: AppTextStyles.bold16),
                      ],

// Production Companies
                      const SizedBox(height: 16),
                      const Text('Production Companies:',
                          style: AppTextStyles.bold16),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: movie.productionCompanies.map((company) {
                          return Row(
                            children: [
                              if (company.logoPath != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w200${company.logoPath}',
                                    width: 50,
                                    height: 50,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image),
                                  ),
                                ),
                              Expanded(
                                  child: Text(company.name,
                                      style: AppTextStyles.normal)),
                            ],
                          );
                        }).toList(),
                      ),

                      SubmitRatingButton(movie: movie, rating: _rating)
                    ],
                  ),
                ),
        ));
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
