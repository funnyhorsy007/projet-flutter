import 'package:flutter/material.dart';
import 'package:younesse/screens/ann.dart';

import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/metheo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hammouda Oussama',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // home: HomePage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/metheo': (context) => WeatherPage(),
        '/ann': (context) => Ann(),
      },
      initialRoute: '/login',
    );
  }
}
