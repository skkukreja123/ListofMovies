import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_managment/di/locator.dart';
import 'package:state_managment/view/auth/login_screen.dart';
import 'package:state_managment/view/screen/favourite_screen.dart';
import 'package:state_managment/view/screen/genre_screen.dart';
import 'package:state_managment/view/screen/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:state_managment/viewmodel/auth_view_model.dart';
import 'package:state_managment/viewmodel/movie_view.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['API_KEY'] ?? '',
        authDomain: dotenv.env['AUTH_DOMAIN'],
        projectId: dotenv.env['PROJECT_ID'] ?? '',
        storageBucket: dotenv.env['STORAGE_BUCKET'],
        messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? '',
        appId: dotenv.env['APP_ID'] ?? '',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => getIt<AuthViewModel>()..listenAuthChanges()),
        ChangeNotifierProvider(
            create: (_) => getIt<MovieViewModel>()..getNowPlayingMovies()),
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'State Management',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home:
                authVM.user != null ? HomeScreen() : LoginScreen(isLogin: true),
            routes: {
              '/home': (context) => HomeScreen(),
              '/login': (context) => LoginScreen(isLogin: true),
              '/register': (context) => LoginScreen(isLogin: false),
              '/favorites': (context) => FavoritesScreen(),
              '/genre': (context) => GenreScreen(),
            },
          );
        },
      ),
    );
  }
}
