import 'dart:async';
import 'dart:convert';
import 'package:first_project/screens/rating.dart';
import 'package:first_project/screens/search_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './app_colors.dart';
import 'package:http/http.dart' as http;
import './see_all.dart';
import './book.dart';
import 'featured_books.dart';
import 'session_manager.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

Map mapPopularBooks = {};
List listPopularBooks = [];

class HomePageState extends State<HomePage> {
  List popularbooks = PopularBookLinks.links;
  List recommendedbooks = [];
  bool recommendedBookIsLoading = true;
  bool popularBookIsLoading = true;
  bool isLogin = false;
  List categoryList = [];
  bool featuredBooksisLoading = true;
  List featuredBooksListData = [];
  String user_id = '';
  bool isLoggedin = false;
  List myLibraryList = [];
  bool libraryBooksIsLoading = true;

  void getUserStatus() async{
    String? userId = await SessionManager.getUserId();
    if (userId != null) {
      isLoggedin=true;
      print('User ID: $userId loginStatus $isLoggedin');
    } else {
      print('User ID not found');
    }
    setState(() {
      user_id = userId!;
    });
    if(user_id.isNotEmpty) fetchLibrary();
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

  Future popularBookApicall() async {
    http.Response responsePopularBooks;
    responsePopularBooks = await http.get(Uri.parse("http://192.168.29.145:8888/getebooks?category=Popular Books"));
    if (responsePopularBooks.statusCode==200){
      setState(() {
        mapPopularBooks = json.decode(responsePopularBooks.body);
        listPopularBooks = mapPopularBooks["books"];
        popularBookIsLoading=false;
      });
    }
  }
  Future recommendedBookApicall() async {
    http.Response responsePopularBooks;
    responsePopularBooks = await http.get(Uri.parse("http://192.168.29.145:8888/getebooks?category=Recommended"));
    if (responsePopularBooks.statusCode==200){
      setState(() {
        mapPopularBooks = json.decode(responsePopularBooks.body);
        recommendedbooks = mapPopularBooks["books"];
        recommendedBookIsLoading = false;
      });
    }
  }

  Future fetchCategory() async {
    http.Response response;
    response = await http.get(Uri.parse("http://192.168.29.145:8888/category"));
    if (response.statusCode==200){
      setState(() {
        List list = json.decode(response.body);
        categoryList=list;
      });
    }

  }


  Future<void> featuredBooksApicall() async {
    final response = await http.get(Uri.parse("http://192.168.29.145:8888/getebooks?category=Featured Books"));
    if (response.statusCode == 200) {
      setState(() {
        final mapResponse = json.decode(response.body);
        featuredBooksListData = mapResponse["books"];
        featuredBooksisLoading = false;
      });

    }
  }

  Future<void> _onRefresh() async {
    await fetchLibrary();
    await featuredBooksApicall();
    popularBookApicall();
    recommendedBookApicall();
  }

  @override
  void initState(){
    super.initState();
    getUserStatus();
    popularBookApicall();
    featuredBooksApicall();
    fetchCategory();
    recommendedBookApicall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 45,
          padding: EdgeInsets.symmetric(horizontal: 0,),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Search bar
              Expanded(
                child: Container(
                  height: 40, // Adjust the height as needed
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Background color of the search bar
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: TextField(
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
                    onSubmitted: (query){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchResultsPage(query: query)));
                    },
                  ),
                ),
              ),
              // Filter icon
              Container(
                margin: EdgeInsets.only(left: 10),
                child: IconButton(
                  icon: Icon(Icons.filter_alt_outlined, color: AppColors.grey800),
                  onPressed: () {
                    // Add your filter logic here
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Container(
          margin: EdgeInsets.only(top: 1),
          child: ListView(
            children: [
              // Explorer
              isLoggedin?Row(
                children: [
                  Container(
                    width: 100,
                    height: 50,
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 10),
                    child: Center(
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.red
                          )
                        ),
                        child: Center(
                          child: Text(
                              "Explore",
                            style: TextStyle(
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 20,
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        width: 1,
                        height: 35,
                        decoration: BoxDecoration(
                          border: Border.all(
                          width: 0.3,
                          color: Colors.black,
                        )
                      ),
                      ),
                    )
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.only(top: 7.5, bottom: 7.5),
                      color: Colors.white,
                      child: Center(
                        child: listPopularBooks.isNotEmpty
                            ?ListView.builder(
                          padding: const EdgeInsets.only(left: 0),
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryList.isEmpty?0:categoryList.length,
                          itemBuilder: (context, i){
                            return Container(
                              width: 100,
                              height: 35,
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: Colors.black,
                                )
                              ),
                              child: Center(
                                child: GestureDetector(
                                  child: Text(
                                    categoryList[i],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  onTap: () => Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context)=>SeeAllBooksPage(category: categoryList[i],) )),
                                ),
                              ),
                            );
                          },
                        ): const Center(
                          child: Text('No data available'), // Show a message if listData is null or empty
                        ),
                      ),
                    ),
                  ),
                ],
              ):Container(height: 2, color: Colors.white,),

              //Welcome note
              !isLoggedin?Container(
                margin: EdgeInsets.only(top: 1),
                color: Colors.white,
                child: Column(
                  children: [
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: Text(
                          "Welcome to Swayam!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            wordSpacing: 2,
                          ),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30,bottom: 10),
                      child: Text(
                        "Find your next great read by browsing top pics and recommendations below.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ):
              //From Your Library Container
              Container(
                margin: EdgeInsets.only(top: 10),
                color: Colors.white,
                padding: const EdgeInsets.only(top: 11, bottom: 20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 15),
                      child: const Row(
                        children: [
                        FaIcon(
                        FontAwesomeIcons.bookOpen,
                        color: Colors.black54,
                        size: 30,
                        ),
                          SizedBox(width: 15,),
                          Text(
                            "From Your Library",
                            style: TextStyle(
                                fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.6,
                      ),
                    ),

                    // books container
                    !libraryBooksIsLoading?Container(
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      color: Colors.grey[250],
                      child: myLibraryList.isNotEmpty
                          ?ListView.builder(
                        padding: const EdgeInsets.only(left: 15),
                        scrollDirection: Axis.horizontal,
                        itemCount: myLibraryList==null?0:myLibraryList.length,
                        itemBuilder: (context, i){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (context)=>Book(book_title: myLibraryList[i]["_id"])));
                            },
                            child: Container(
                              width: 110,
                              height: 120,
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.network(
                                myLibraryList[i]["image_url"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ): const Center(
                        child: Text('No data available'), // Show a message if listData is null or empty
                      ),
                    ):Container(
                      height: 180,
                      child: Center(child: CircularProgressIndicator()),
                    )

                  ],
                ),
              ),

              const SizedBox(height: 12,),

              // popular books container
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 11),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "Popular books",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.6,
                      ),
                    ),
                    SizedBox(height: 7,),

                    // books container
                    popularBookIsLoading?Container(
                      height: 160,
                        child: Center(child: CircularProgressIndicator(color: Colors.blueAccent,),))
                        :Container(
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      color: Colors.grey[250],
                      child: listPopularBooks.isNotEmpty
                      ?ListView.builder(
                        padding: const EdgeInsets.only(left: 15),
                        scrollDirection: Axis.horizontal,
                        itemCount: listPopularBooks==null?0:listPopularBooks.length,
                        itemBuilder: (context, i){
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context)=>Book(book_title: listPopularBooks[i]['_id'].toString())));
                          },
                          child: Container(
                            width: 110,
                            height: 140,
                            margin: const EdgeInsets.only(right: 10),
                            child: Image.network(
                              listPopularBooks[i]['image_url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      ): const Center(
                            child: Text('No data available'), // Show a message if listData is null or empty
                              ),
                    ),
                    SizedBox(height: 7,),

                    Container(
                      height: 1,
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.6,

                      ),
                    ),
                    TextButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeeAllBooksPage(category: "Popular Books"),
                        ),
                      );
                    },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "See All"
                            ),
                            Icon(
                              Icons.keyboard_arrow_right
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12,),

              //Recommended books
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 11),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "Recommended Books",
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.6,
                      ),
                    ),
                    SizedBox(height: 7,),

                    // books container
                    recommendedBookIsLoading?
                        Container(
                          height: 16,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                        :Container(
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      color: Colors.grey[250],
                      child: recommendedbooks.isNotEmpty
                          ?ListView.builder(
                        padding: const EdgeInsets.only(left: 15),
                        scrollDirection: Axis.horizontal,
                        itemCount: recommendedbooks==null?0:recommendedbooks.length,
                        itemBuilder: (context, i){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Book(book_title: recommendedbooks[i]["_id"])));
                            },
                            child: Container(
                              width: 110,
                              height: 140,
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.network(
                                recommendedbooks[i]["image_url"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ): const Center(
                        child: Text('No data available'), // Show a message if listData is null or empty
                      ),
                    ),
                    SizedBox(height: 7,),

                    Container(
                      height: 1,
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.6,

                      ),
                    ),
                    TextButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeeAllBooksPage(category: "Recommended Books"),
                        ),
                      );
                    },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "See All"
                            ),
                            Icon(
                                Icons.keyboard_arrow_right
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12,),

              //Best Sellers container
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 11),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 15),
                      child: const Text(
                        "Best Sellers",
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.6,
                      ),
                    ),
                    SizedBox(height: 7,),

                    // books container
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      color: Colors.grey[250],
                      child: popularbooks.isNotEmpty
                          ?ListView.builder(
                        padding: const EdgeInsets.only(left: 15),
                        scrollDirection: Axis.horizontal,
                        itemCount: popularbooks==null?0:popularbooks.length,
                        itemBuilder: (context, i){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Book(book_title: "222")));
                            },
                            child: Container(
                              width: 110,
                              height: 140,
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.network(
                                popularbooks[i],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ): const Center(
                        child: Text('No data available'), // Show a message if listData is null or empty
                      ),
                    ),
                    SizedBox(height: 7,),

                    Container(
                      height: 1,
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 0.6,

                      ),
                    ),
                    TextButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SeeAllBooksPage(category: "Best Sellers"),
                        ),
                      );
                    },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "See All"
                            ),
                            Icon(
                                Icons.keyboard_arrow_right
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),

              //featured books
              Container(
                color: Colors.grey[100],
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 0, top: 5),
                child: Column(
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
                    Container(
                      height: 180, // Adjust height as needed
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.95),
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
                                      data['image_url']??"image",
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
                                          data['title']??"title",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        Text(
                                          data['sub_title']??"The Subtitle of The Book Goes Here ",
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
                                        RatingDisplay(rating: 3.5),
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
              ),

              SizedBox(height: 15,),

        ],
          ),
        ),
      ),
    );
  }
}