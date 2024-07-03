import 'package:flutter/material.dart';
import 'package:first_project/screens/featured_books.dart';
import 'package:first_project/screens/membership_screen.dart';
import 'package:first_project/screens/user_profile.dart';
import 'package:first_project/screens/login_screen.dart';
import 'package:first_project/screens/register_screen.dart';
import 'package:first_project/screens/Main_screen.dart';
import 'package:first_project/screens/welcome_screen.dart';
import 'package:first_project/screens/library_page.dart';
import './screens/session_manager.dart';
import './screens/home_page2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized

  String initialRoute = await determineInitialRoute();

  runApp(MyApp(initialRoute: initialRoute));
}

Future<String> determineInitialRoute() async {
  String? userId = await SessionManager.getUserId();
  return (userId != null && userId.isNotEmpty) ? 'home' : 'welcome';
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: initialRoute,
      routes: {
        'welcome': (context) => const WelcomeScreen(),
        'login': (context) => const Mylogin(),
        'register': (context) => const UserRegister(),
        'home': (context) => const MainScreen(),
        'library': (context) => const LibraryScreen(),
        'featuredbooks': (context) => const FeaturedBooks(),
        'userprofile': (context) => const UserProfile(),
        'membershipscreen': (context) => const MembershipScreen(),
        'home2': (context) => const HomePage2(),
      },
    );
  }
}
