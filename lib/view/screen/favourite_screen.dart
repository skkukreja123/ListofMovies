import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_managment/view/screen/datail_screen.dart';
import 'package:state_managment/viewmodel/movie_view.dart';

import '../widget/movie_card.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<MovieViewModel>(context, listen: false)
        .getFavoriteMovies());
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MovieViewModel>(context);
    final favoriteMovies =
        vm.movies.where((movie) => vm.favoriteIds.contains(movie.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Movies')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: favoriteMovies.isEmpty
                  ? const Center(child: Text("No favorites yet."))
                  : AnimatedList(
                      initialItemCount: favoriteMovies.length,
                      itemBuilder: (context, index, animation) {
                        final movie = favoriteMovies[index];
                        return FadeTransition(
                          opacity: animation,
                          child: MovieCard(
                            movie: movie,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailScreen(movieid: movie.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
