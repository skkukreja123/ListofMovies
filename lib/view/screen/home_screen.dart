import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_managment/view/screen/datail_screen.dart';
import 'package:state_managment/view/widget/movie_card.dart';
import 'package:state_managment/viewmodel/movie_view.dart';

import '../widget/search_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<MovieViewModel>(context, listen: false);
    vm.getNowPlayingMovies(isInitial: true);

    _scrollController = ScrollController()
      ..addListener(() {
        final vm = Provider.of<MovieViewModel>(context, listen: false);
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300) {
          vm.getNowPlayingMovies();
        }
      });
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MovieViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('All Movies'),
            SizedBox(
              width: 200, // Adjust width as needed
              child: MovieSearchBar(
                onChanged: (value) {
                  final vm =
                      Provider.of<MovieViewModel>(context, listen: false);
                  if (value.trim().isNotEmpty) {
                    vm.searchMovies(value);
                  } else {
                    vm.getNowPlayingMovies(isInitial: true);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await vm.getNowPlayingMovies(isInitial: true);
        },
        child: vm.movies.isEmpty && vm.isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: _scrollController,
                itemCount: vm.movies.length + (vm.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < vm.movies.length) {
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
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
      ),
    );
  }
}
