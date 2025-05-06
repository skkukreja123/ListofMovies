import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_managment/view/screen/datail_screen.dart';
import 'package:state_managment/view/widget/movie_card.dart';
import 'package:state_managment/viewmodel/movie_view.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MovieViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('All Movies')),
      body: RefreshIndicator(
        onRefresh: vm.getNowPlayingMovies,
        child: vm.isLoading
            ? Center(child: CircularProgressIndicator())
            : vm.error != null
                ? Center(child: Text(vm.error!))
                : ListView.builder(
                    itemCount: vm.movies.length,
                    itemBuilder: (context, index) {
                      final movie = vm.movies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(movie: movie),
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
