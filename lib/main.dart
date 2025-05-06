import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_managment/di/locator.dart';

void main() {
  setupLocator(); // Initialize the service locator
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider();
  }
}
