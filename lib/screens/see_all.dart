import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './rating.dart';
import 'app_colors.dart';
import 'session_manager.dart'; // Add this import for session management

class SeeAllBooksPage extends StatefulWidget {
  String category = "";

  SeeAllBooksPage({super.key, required this.category});

  @override
  _SeeAllBooksPageState createState() => _SeeAllBooksPageState(category);
}

String responseData = "";
Map mapResponse = {};
Map mapData = {};
List listData = [];

class _SeeAllBooksPageState extends State<SeeAllBooksPage> {
  bool isLoading = true;
  String categoryname = '';
  bool isLoggedIn = false; // Track login status
  String user_id = ""; // Track user ID
  Map<String, bool> addedBooks = {}; // Track added books

  _SeeAllBooksPageState(String category) {
    categoryname = category;
  }

  Future<void> getUserId() async {
    String? userId = await SessionManager.getUserId();
    bool? islogin = await SessionManager.isLoggedIn();

    if (userId != null && islogin != null) {
      setState(() {
        user_id = userId;
        isLoggedIn = islogin;
      });
    }
  }

  Future<void> checkLibrary(String book_id) async {
    final response = await http.post(
      Uri.parse('http://192.168.29.145:8888/checkbook'),
      body: jsonEncode(<String, String>{
        'user_id': user_id,
        'book_id': book_id,
      }),
    );

    if (response.statusCode == 200) {
      Map result = json.decode(response.body);
      bool isAddedToLibrary = result['book_present'];
      setState(() {
        addedBooks[book_id] = isAddedToLibrary;
      });
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  Future<void> apicall() async {
    http.Response response;
    response = await http.get(
        Uri.parse("http://192.168.29.145:8888/getebooks?category=${categoryname}"));
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        listData = mapResponse["books"];
        isLoading = false;
      });

      // Check library status for each book
      for (var book in listData) {
        await checkLibrary(book['_id']);
      }
    }
  }

  Future<void> addBook(String book_id) async {
    final response = await http.post(
      Uri.parse('http://192.168.29.145:8888/user_cart'),
      body: jsonEncode(<String, String>{
        'book_id': book_id,
        'user_id': user_id,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        addedBooks[book_id] = true;
      });
      _showAlert('Book Successfully Added');
    }
  }

  Future<void> removeBook(String book_id) async {
    final response = await http.delete(
      Uri.parse('http://192.168.29.145:8888/user_cart'),
      body: jsonEncode(<String, String>{
        'book_id': book_id,
        'user_id': user_id,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        addedBooks[book_id] = false;
      });
      _showAlert('Book Successfully Removed');
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    await apicall();

  }

  @override
  void initState() {
    apicall();
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.category,
          style: TextStyle(
            fontSize: 19,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: _onRefresh,
            child: Column(
                    children: [
            Container(
              height: 70,
              padding: EdgeInsets.only(
                  left: 20, right: 25, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 2, color: Colors.grey[400]!))),
              child: Row(
                children: [
                  // Search bar
                  Expanded(
                    child: Container(
                      height: 43,
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Background color of the search bar
                        borderRadius:
                        BorderRadius.circular(8), // Rounded corners
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search here...",
                          hintStyle: TextStyle(
                            color: AppColors.grey800,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Icons.search_outlined,
                            size: 25,
                            color: AppColors.grey800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Filter icon
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: Icon(Icons.sort_outlined,
                          color: AppColors.grey800),
                      onPressed: () {
                        // Add your filter logic here
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: listData.isNotEmpty
                    ? ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 20),
                  scrollDirection: Axis.vertical,
                  itemCount:
                  listData.isEmpty ? 0 : listData.length,
                  itemBuilder: (context, i) {
                    String bookId = listData[i]['_id'];
                    bool isAdded = addedBooks[bookId] == true;

                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: Container(
                                width: 90,
                                height: 120,
                                margin: const EdgeInsets.only(
                                    right: 0, top: 0),
                                child: Image.network(
                                  listData[i]['image_url'],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              onTap: () {},
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 0, left: 10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listData[i]['title'] ??
                                              "Book Title",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight:
                                              FontWeight.w500,
                                              color:
                                              AppColors.primary),
                                        ),
                                        Text(
                                          listData[i]['sub_title'] ??
                                              "Subtitle of the book",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          listData[i]['author'] ??
                                              "Author name",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                            FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              RatingDisplay(
                                                  rating: double
                                                      .parse(listData[
                                                  i][
                                                  'rating'])),
                                              Material(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(20),
                                                color: AppColors
                                                    .primary,
                                                child: InkWell(
                                                  onTap: () {
                                                    if (isLoggedIn) {
                                                      if (isAdded) {
                                                        removeBook(
                                                            bookId);
                                                      } else {
                                                        addBook(
                                                            bookId);
                                                      }
                                                    } else {
                                                      Navigator.pushNamed(
                                                          context,
                                                          'login');
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4,
                                                        horizontal:
                                                        20),
                                                    child: Text(
                                                      isAdded
                                                          ? 'Remove'
                                                          : 'Add',
                                                      style:
                                                      const TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontSize: 15,
                                                        letterSpacing:
                                                        1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 25,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10),
                          child: Center(
                            child: Divider(
                              color: Colors.grey[400],
                              thickness: 0.6,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
                    : const Center(
                  child: Text('No data available'),
                ),
              ),
            ),
                    ],
                  ),
          ),
    );
  }
}
