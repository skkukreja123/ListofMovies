import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_managment/di/locator.dart';
import 'package:state_managment/view/screen/home_screen.dart';

void main() {
  setupLocator(); // Initialize the service locator
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Management Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homeScreen(), // Set the home screen to homeScreen widget
    );
  }
}
