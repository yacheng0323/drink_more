import 'package:drink_more/config/router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DrinkMoreApp());
}

class DrinkMoreApp extends StatefulWidget {
  const DrinkMoreApp({super.key});

  @override
  State<DrinkMoreApp> createState() => _DrinkMoreAppState();
}

class _DrinkMoreAppState extends State<DrinkMoreApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: "Drink More",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
