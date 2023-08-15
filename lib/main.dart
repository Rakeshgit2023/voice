import 'package:flutter/material.dart';
import 'package:voice/colors.dart';
import 'package:voice/home_page.dart';
//import 'package:voice/list_class.dart';

//import 'speech_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const home_page(),
      //const SpeechScreen(),
      debugShowCheckedModeBanner: false,
      title: 'Speech to text',
      theme: ThemeData(
        primaryColor: bgColor,
      ),
    );
  }
}
