import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/destination_provider.dart';
import 'package:frontend/providers/season_provider.dart';
import 'package:frontend/providers/trip_provider.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/payment_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/screens/trips/trip_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = "pk_test_51NEOG0BCaaBopW0JuSz4FUfcLLCJ4jSJw4xEn1EihJEwzVff4e19mGmo8dMnS9WeUxEFb8sSIoxnEeKrsfNT1YSN002vyYOYkQ";

  await dotenv.load(fileName: "assets/.env");
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthenticationProvider>(
        create: (_) => AuthenticationProvider(),
      ),
      ChangeNotifierProvider<TripProvider>(create: (_) => TripProvider()),
      ChangeNotifierProvider<SeasonProvider>(create: (_) => SeasonProvider()),
      ChangeNotifierProvider<DestinationProvider>(
          create: (_) => DestinationProvider()),
    ],
    child: const MyApp(),
  ));
}

Map<String, WidgetBuilder> _getRoutes() {
  return {
    '/': (context) => const MyHomePage(),
    '/signin': (context) => const LoginScreen(),
    '/signup': (context) => const RegisterScreen(),
    '/trip': (context) => const TripScreen(),
    '/payment':(context) => const PaymentScreen(),
    //'/filter': (context) => const FilterScreen(),
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/signin',
      routes: _getRoutes(),
      // home: const LoginScreen(),
    );
  }
}
