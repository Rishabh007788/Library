import 'package:first_project/screens/pdf_screen.dart';
import 'package:first_project/screens/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './rating.dart';
import 'app_colors.dart';
import 'book.dart';
import 'featured_books.dart';

class MyLibraryPage extends StatefulWidget {
  final String category;

  MyLibraryPage({Key? key, required this.category}) : super(key: key);

  @override
  _MyLibraryPageState createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends State<MyLibraryPage> {
  bool featuredBooksIsLoading = true;
  bool libraryBooksIsLoading = true;
  List featuredBooksListData = [];
  List myLibraryList = [];
  bool isLoggedIn = false; // Track login status
  String user_id = "";


  Future<void> getUserId() async {
    String? userId = await SessionManager.getUserId();
    bool? islogin = await SessionManager.isLoggedIn();

    if (userId != null && islogin != null) {
      print("fetched userid = $userId");
      setState(() {
        user_id = userId;
        isLoggedIn = islogin;
      });
    }
    if(user_id.isNotEmpty){
      print("user_id = $user_id");
      fetchLibrary();
    }
  }

  Future removeBook(String book_id) async {

    final response = await http.delete(
      Uri.parse('http://192.168.29.145:8888/user_cart'),
      body: jsonEncode(<String, String>{
        'book_id': book_id,
        'user_id' : user_id,
      }),
    );

    if(response.statusCode==200){
      fetchLibrary();
    }

  }

  Future<void> featuredBooksApicall() async {
    final response = await http.get(Uri.parse("http://192.168.29.145:8888/getebooks?category=Featured Books"));
    if (response.statusCode == 200) {
      setState(() {
        final mapResponse = json.decode(response.body);
        featuredBooksListData = mapResponse["books"];
        featuredBooksIsLoading = false;
      });
    }
  }

  Future<void> fetchLibrary() async {
    final response = await http.get(Uri.parse("http://192.168.29.145:8888/user_cart?user_id=$user_id"));
    print("fetching books from mylibrary");
    if (response.statusCode == 200) {
      print("books from mylibrary fetched");
      setState(() {
        final mapResponse = json.decode(response.body);
        myLibraryList = mapResponse["books"];
        libraryBooksIsLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await fetchLibrary();
    await featuredBooksApicall();
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    featuredBooksApicall();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                color: Colors.grey[100],
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 0, top: 5),
                child: featuredBooksListData.isNotEmpty
                    ? Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 15, bottom: 10, top: 10),
                      child: const Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.bookOpen,
                            color: Colors.black54,
                            size: 28,
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Featured Books",
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    featuredBooksIsLoading?
                        Container(
                          height: 180,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                        :Container(
                      height: 180, // Adjust height as needed
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.9),
                        itemCount: featuredBooksListData.length,
                        itemBuilder: (context, idx) {
                          var data = featuredBooksListData[idx];
                          return Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  height: 155,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: ClipRRect(
                                    child: Image.network(
                                      data['image_url'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 0, left: 15, right: 1),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data['title']??"Book Title:",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        Text(
                                          data['sub_title']??"The Subtitle of The Book Goes Here nfnd dmdm ksks kskks ksksks",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          data['author']??"Author name",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.grey800,
                                          ),
                                        ),
                                        RatingDisplay(rating: double.parse(data['rating'])),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              RichText(text: TextSpan(children: [
                                                TextSpan(
                                                  text: '₹',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    color: Colors.green[900],
                                                  ),

                                                ),
                                                TextSpan(
                                                  text: data['price'].toString()??"₹225.00",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w400,
                                                    color: AppColors.grey800,
                                                  ),

                                                ),
                                              ])),
                                              Material(
                                                borderRadius:
                                                BorderRadius.circular(15),
                                                color: Colors.green[800],
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context, MaterialPageRoute(
                                                        builder: (context)=> Book(book_title: data['_id'])
                                                    ));
                                                  },
                                                  child: Container(
                                                    padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                      vertical: 4,
                                                      horizontal: 20,
                                                    ),
                                                    child: const Text(
                                                      "View",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        letterSpacing: 1,
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
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 11,
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 10,
                      ),
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.6,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeaturedBooks(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("See All"),
                          Icon(Icons.keyboard_arrow_right),
                        ],
                      ),
                    ),
                  ],
                )
                    : Container(
                  height: 180,
                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                    ),
              ),

              SizedBox(height: 10,),

              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[100],
                //padding: EdgeInsets.only(top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Books Added To Library",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey800
                            ),
                          ),
                          InkWell(
                            child: Icon(
                              Icons.filter_alt_outlined,
                              color: AppColors.grey800,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),

                    libraryBooksIsLoading?
                    Container(
                      height: 400,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                        :Wrap(
                      spacing: 15.0,
                      runSpacing: 15.0,
                      children: List.generate(myLibraryList.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFScreen(bookId: myLibraryList[index]['_id']),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: 200, // Set your desired height
                                width: 140, // Set your desired width
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                ),
                                child: ClipRRect(
                                  child: Image.network(
                                    myLibraryList[index]['image_url'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white.withOpacity(0.4),
                                      child: IconButton(
                                        icon: Icon(Icons.download),
                                        onPressed: () {
                                          // Add your download logic here
                                        },
                                        iconSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.white.withOpacity(0.4),
                                      child: IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          removeBook(myLibraryList[index]['_id']);
                                        },
                                        iconSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
