import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_managment/viewmodel/movie_view.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieViewModel>(context, listen: false).fetchGenreCounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MovieViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Genre Movie Counts'),
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                },
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: Colors.grey),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Genre',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Count',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Poster',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...vm.genreCounts.map((entry) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(entry['genre'].toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(entry['count'].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: entry['poster_path'] != null &&
                                  entry['poster_path'].isNotEmpty
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: (entry['poster_path'] as List)
                                        .map<Widget>((path) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/w500$path',
                                          width: 50,
                                          height: 50,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const Icon(Icons.image_not_supported),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }
}
