import 'package:flutter/material.dart';
import 'package:com_271063_lab3/view/mainpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ann's Hot Burger",
      theme: ThemeData(
    
        primarySwatch: Colors.amber,
      ),
      home: const Scaffold(
        backgroundColor: Colors.orangeAccent,
        body: MainPage(title:"Ann's Hot Burger"),
      ));
  }
}