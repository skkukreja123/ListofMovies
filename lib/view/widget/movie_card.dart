import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_managment/model/movie.dart';
import 'package:state_managment/viewmodel/movie_view.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({required this.movie, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MovieViewModel>(context);

    final isFavorite = viewModel.favoriteIds.contains(movie.id);

    return Card(
      child: ListTile(
        leading: Hero(
          tag: movie.id,
          child: Image.network(
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
        ),
        title: Text(movie.title),
        subtitle: Text(
          movie.overview,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            viewModel.toggleFavorite(movie.id);
          },
        ),
      ),
    );
  }
}
