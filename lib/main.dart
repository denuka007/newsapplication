import 'package:flutter/material.dart';
import 'package:s_newz/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEWS-APP',
      debugShowCheckedModeBanner: false,
      //theme: ThemeData.dark(),
      home: const Home(),
    );
  }
}
