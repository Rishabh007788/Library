// search_results.dart

import 'dart:convert';
import 'package:first_project/screens/rating.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_colors.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({super.key, required this.query});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  bool isLoading = true;
  List searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchBooks(widget.query);
  }

  Future<void> _searchBooks(String query) async {
    http.Response response;
    response = await http.get(Uri.parse("http://192.168.29.145:8888/search"));
    if (response.statusCode==200){
      setState(() {
        List list = json.decode(response.body);
        searchResults=list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: isLoading
          ? Center(child: CircularProgressIndicator()):
          Container(
        color: Colors.white,
        //padding: EdgeInsets.symmetric(vertical: 15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: searchResults.isNotEmpty
            ?ListView.builder(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
          scrollDirection: Axis.vertical,
          itemCount: searchResults.isEmpty?0:searchResults.length,
          itemBuilder: (context, i){
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 90,
                        height: 100,
                        margin: const EdgeInsets.only(right: 0, top: 0),
                        child: Image.network(
                          searchResults[i]['avatar'],
                          fit: BoxFit.fill,
                        ),
                      ),
                      onTap: (){},
                    ),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 0, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Book Title:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary
                                  ),
                                ),
                                Text(
                                  "Subtitle of the book",
                                  style: TextStyle(
                                    fontSize: 15,

                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Author name",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      RatingDisplay(rating: 4.5),

                                      Material(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppColors.primary,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context, '');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 20,
                                            ),
                                            child: const Text(
                                              "Add",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 25,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Divider(
                      color: Colors.grey[400],
                      thickness: 0.6,
                    ),
                  ),
                )
              ],
            );
          },
        ): const Center(
          child: Text('No data available'), // Show a message if listData is null or empty
        ),
      )
    );
  }
}
