import 'package:flutter/material.dart';
import '../../model/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({required this.movie, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        'https://image.tmdb.org/t/p/w200${movie.posterPath}',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        cacheWidth: 60,
        cacheHeight: 60,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            width: 60,
            height: 60,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
      ),
      title: Text(movie.title),
      subtitle: Text(
        movie.overview,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward),
    );
  }
}
