import 'package:first_flutter_app/random_words_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(primaryColor: Colors.green[900], splashColor: Colors.grey),
      home: RandomWords(),
    );
  }
}
