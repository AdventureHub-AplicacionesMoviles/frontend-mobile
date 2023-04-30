import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<AuthenticationProvider>(
      create: (_) => AuthenticationProvider(),
      child: const MyApp(),
    ),
  );
}

Map<String, WidgetBuilder> _getRoutes() {
  return {
    '/': (context) => const MyHomePage(),
    '/signin': (context) => const LoginScreen(),
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/signin',
      routes: _getRoutes(),
      // home: const LoginScreen(),
    );
  }
}
