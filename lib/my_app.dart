import 'package:flutter/material.dart';
import 'package:notepad/src/screen/homeNote.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple.txt',
      debugShowCheckedModeBanner: false,
      home: HomeNote(),
    );
  }
}