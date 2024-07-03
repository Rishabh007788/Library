import 'session_manager.dart';
import './rating.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/gestures.dart';
import './app_colors.dart';

class Book extends StatefulWidget {
  String _id = "";

  Book({super.key, required String book_title}) : _id = book_title;

  @override
  _Book createState() => _Book(_id);

}

Map book = {};

class _Book extends State<Book> {

  bool isLoading = true;
  String _id = "";
  String user_id = "";
  bool isLoggedIn = false;
  bool isAddedToLibrary = false;

  _Book(String booktitle){
    String title=booktitle;
    _id=title;
  }

  void addAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Book Sucessfully Added'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void removeAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Book Sucessfully removed'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }



  void getUserId() async{
    String? userId = await SessionManager.getUserId();
    bool? islogin  = await SessionManager.isLoggedIn();

    print("checking book in library");
    if (userId != null) {
      print('User ID: $userId loginstatus : $islogin');
    } else {
      print('User ID not found');
    }
    setState(() {
      user_id = userId!;
      isLoggedIn=islogin;
    });
    checkLibrary();
  }


  Future addBook(String book_id, String user_id) async {

    final response = await http.post(
      Uri.parse('http://192.168.29.145:8888/user_cart'),
      body: jsonEncode(<String, String>{
        'book_id': book_id,
        'user_id' : user_id,
      }),
    );

    if(response.statusCode==200){
      addAlert(context);
      setState(() {
        isAddedToLibrary = true;
      });
    }

  }

  Future removeBook(String book_id, String user_id) async {

    final response = await http.delete(
      Uri.parse('http://192.168.29.145:8888/user_cart'),
      body: jsonEncode(<String, String>{
        'book_id': book_id,
        'user_id' : user_id,
      }),
    );

    if(response.statusCode==200){
      removeAlert(context);
      setState(() {
        isAddedToLibrary = false;
      });
    }

  }

  Future apicall() async {
    http.Response response;
    response = await http.get(Uri.parse("http://192.168.29.145:8888/fetchbook?book_id=$_id"));
    if (response.statusCode == 200) {
      setState(() {
        book = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  Future checkLibrary() async {
    print('userid is $user_id');
    final response = await http.post(
      Uri.parse('http://192.168.29.145:8888/checkbook'),
      body: jsonEncode(<String, String>{
        'user_id' : user_id,
        'book_id': _id,

      }),
    );

    if(response.statusCode==200){
      Map result = json.decode(response.body);
      isAddedToLibrary = result['book_present'];
      print("book is checked present $isAddedToLibrary");
    }
    else{
      print(response.statusCode);
      print(response.body);
    }
  }

  Future<void> _onRefresh() async {
    await apicall();
   await checkLibrary();
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
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Discover New Books',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // book header container
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //book cover
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            width: 120,
                            height: 170,
                            margin:
                            const EdgeInsets.only(right: 0, top: 10),
                            child: Image.network(
                              book['image_url'],
                              fit: BoxFit.fill,
                            ),
                          ),

                          //book details
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, right: 5),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    book['title']??"Title Goes Here: ",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    book['sub_title']??"The Subtitle Of The Book Goes Here",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    book['author']??"Author name",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black
                                    ),
                                  ),

                                  // rating
                                  RatingDisplay(rating: double.parse(book['rating'])),

                                  // price
                                  Container(
                                    padding:
                                    const EdgeInsets.only(top: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: "₹0.00 ",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                              TextSpan(
                                                text: "Swayam",
                                                style: TextStyle(
                                                  color:
                                                  Colors.orange[900],
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "Premium",
                                                style: TextStyle(
                                                  color:
                                                  Colors.grey[600],
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: "or ₹",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                              TextSpan(
                                                text: book['price'].toString(),
                                                style: TextStyle(
                                                  color:
                                                  Colors.black,
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: " to buy ebook",
                                                style: TextStyle(
                                                  color:
                                                  Colors.black,
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Membership ad
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Swayam",
                                    style: TextStyle(
                                        color: Colors.orange[900],
                                        fontSize: 19,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1,
                                        height: 1.3),
                                  ),
                                  TextSpan(
                                    text: "Premium",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                      'Unlimited reading. Free membership to the offline library. ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black
                                      )
                                  ),
                                  TextSpan(
                                    text: 'Learn more',
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15), // or any color you prefer
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Handle the tap here
                                        if (kDebugMode) {
                                          print('Learn more tapped');
                                        }
                                      },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // button
                            Center(
                              child: Material(
                                color: AppColors.primary,
                                child: InkWell(
                                  onTap: () {
                                    if(isAddedToLibrary){
                                      removeBook(book['_id'], user_id);
                                    }
                                    else if(isLoggedIn){
                                      addBook(book['_id'], user_id);
                                    }
                                    else{
                                      Navigator.pushNamed(context, 'login');
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 80,
                                    ),
                                    child: Builder(
                                      builder: (BuildContext context){
                                        if(isAddedToLibrary){
                                          return Text(
                                            "Remove From Library",
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                          );
                                        }
                                        else if(isLoggedIn){
                                          return Text(
                                              "Add To Library",
                                            style: TextStyle(
                                                color: Colors.white
                                            ),
                                          );
                                        }
                                        else{
                                          return Text(
                                              "Add To Library",
                                            style: TextStyle(
                                                color: Colors.white
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5),
                              child: Divider(
                                thickness: 0.8,
                                color: Colors.grey[400],
                              ),
                            ),
                            // Book Description
                            Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "DESCRIPTION",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        height: 1.8,
                                        letterSpacing: 0.1,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    book['description']??"",
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        color: Colors.black// Adjust line height as needed
                                    ),
                                    softWrap: true,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[600],
                        ),
                      ),

                      // Customer Review
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "CUSTOMER REVIEWS",
                          style: TextStyle(
                              color: AppColors.grey800,
                              fontSize: 18,
                              height: 1.8,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      RatingDisplay(rating: 4.5),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
