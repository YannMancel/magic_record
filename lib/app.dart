import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const kAppName = 'Magic record';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(title: kAppName),
    );
  }
}
