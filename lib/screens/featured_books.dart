import 'dart:convert';
import 'package:first_project/screens/book.dart';
import 'package:first_project/screens/rating.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'app_colors.dart';

class FeaturedBooks extends StatefulWidget {
  const FeaturedBooks({super.key});

  @override
  _FeaturedBooks createState() => _FeaturedBooks();
}

class _FeaturedBooks extends State<FeaturedBooks> {
  bool isLoading = true;
  List listData = [];
  int currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.65);

  Future<void> apicall() async {
    final response = await http.get(Uri.parse("http://192.168.29.145:8888/getebooks?category=Featured Books"));
    if (response.statusCode == 200) {
      setState(() {
        final mapResponse = json.decode(response.body);
        listData = mapResponse["books"];
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await apicall();
  }

  @override
  void initState() {
    super.initState();
    apicall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/featuredbooks_wallpaper.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                "Featured Books",
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context); // Pop the current screen off the stack
                },
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : listData.isEmpty
                ? Center(
              child: Text("Data not found"),
            )
                : Column(
              children: [
                SizedBox(height: 20),
                Container(
                  color: Colors.transparent,
                  height: 240, // Fixed height for the image container
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemCount: listData.length,
                    itemBuilder: (context, index) {
                      var data = listData[index];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(4, 3),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          child: Image.network(
                            data['image_url'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            listData[currentPage]['title'],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.grey800,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            listData[currentPage]['sub_title'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey800,
                            ),
                          ),
                          SizedBox(height: 5),

                          RatingDisplay(rating: double.parse(listData[currentPage]['rating'])),

                          SizedBox(height: 10),
                          Text(
                            listData[currentPage]['description'],
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: AppColors.grey800,
                            ),
                            softWrap: true,
                          ),
                          SizedBox(height: 15),
                          Material(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.primary,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder:
                                (context) => Book(book_title: listData[currentPage]['_id']),));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 60,
                                ),
                                child: const Text(
                                  "View Book",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
