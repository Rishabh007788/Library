import 'package:flutter/material.dart';
import 'downloded_books.dart';
import 'login_screen.dart';
import 'owned_books_page.dart';
import 'my_library.dart';
import 'app_colors.dart';
import 'session_manager.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 35),
          child: FutureBuilder<bool>(
            future: SessionManager.isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                bool isLoggedIn = snapshot.data ?? false;
                return isLoggedIn
                    ? Column(
                  children: [
                    TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: AppColors.grey800,
                      indicatorColor: Colors.blue,
                      tabs: [
                        Tab(text: 'My Library'),
                        Tab(text: 'Downloaded'),
                        Tab(text: 'Owned'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          MyLibraryScreen(),
                          DownloadedBooksScreen(),
                          OwnedBooksScreen(),
                        ],
                      ),
                    ),
                  ],
                )
                    : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/em.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "It's a little empty here...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Material(
                        color: myColor,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'login');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 40,
                            ),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class OwnedBooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OwnedBooksPage(category: '',);
  }
}

class DownloadedBooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DownloadedBooksPage();
  }
}

class MyLibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyLibraryPage(category: '',);
  }
}

void main() => runApp(MaterialApp(
  home: LibraryScreen(),
));
