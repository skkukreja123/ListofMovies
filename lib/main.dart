import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_managment/di/locator.dart';
import 'package:state_managment/view/screen/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:state_managment/viewmodel/movie_view.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<MovieViewModel>()..getNowPlayingMovies(),
      child: MaterialApp(
        title: 'Movie App',
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
