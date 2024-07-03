import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:first_project/screens/app_colors.dart'; // Ensure this import is correct
import 'category_items.dart';
import 'components.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  final List<Map<String, dynamic>> categories = [
    {"name": "Romance", "icon": Icons.favorite, "color": Colors.pink},
    {"name": "Crime & Thriller", "icon": Icons.local_police, "color": Colors.blue},
    {"name": "Literature", "icon": Icons.book, "color": Colors.green},
    {"name": "Biography", "icon": Icons.person, "color": Colors.purple},
    {"name": "Business", "icon": Icons.business, "color": Colors.orange},
    {"name": "History", "icon": Icons.history, "color": Colors.brown},
    {"name": "Politics", "icon": Icons.gavel, "color": Colors.red},
    {"name": "Religion", "icon": Icons.account_balance, "color": Colors.teal},
    {"name": "Health & Fitness", "icon": Icons.fitness_center, "color": Colors.indigo},
  ];

  final List<String> carouselImages = [
    'assets/Featured books2.jpg',
    'assets/hand picked.jpg',
    'assets/popular books.jpg',
  ];

  List books = PopularBookLinks.links;

  List authors = PopularBookLinks.authors;

  final List<String> bookCategories = ["Latest", "Trending", "Best Seller", "Popular"];
  String selectedCategory = "Latest";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App top bar
            TopBar(),

            // main body container
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, top: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Explore", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                        Row(
                          children: [
                            Text("more", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 100,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return CategoryItem(
                          name: categories[index]['name'],
                          icon: categories[index]['icon'],
                          color: categories[index]['color'],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 190,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          // Update state if needed
                        });
                      },
                    ),
                    items: carouselImages.map((imagePath) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 2.0),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 15),

                  // Horizontal list of categories
                  Container(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bookCategories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = bookCategories[index];
                            });
                          },
                          child: Container(
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),

                            ),
                            child: Center(
                              child: Text(
                                bookCategories[index],
                                style: TextStyle(
                                  color: selectedCategory == bookCategories[index]
                                      ? Colors.black
                                      : Colors.grey[700],
                                  fontSize: selectedCategory == bookCategories[index]? 17:15,
                                    fontWeight: selectedCategory == bookCategories[index]? FontWeight.w500:FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),


                  // Display books based on selected category
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 19.0,
                            runSpacing: 20.0,
                            children: List.generate(books.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                },
                                child: Container(
                                  height: 170, // Set your desired height
                                  width: 125, // Set your desired width
                                  decoration: BoxDecoration(
                                  ),
                                  child: ClipRRect(
                                    child: Image.network(
                                      books[index],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 15,),
                          Container(
                            child: Text("see more..."),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    height: 155, // Increase the height to accommodate image and name
                    child: Column(
                      children: [
                        Container(
                          height:30,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Authors", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                              Row(
                                children: [
                                  Text("more", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                                  Icon(Icons.keyboard_arrow_right)
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: authors.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(left: 10),
                                width: 120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        authors[index]['image'],
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      authors[index]['name'],
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  // Footer
                  Container(
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.only(top: 0),
                      color: AppColors.primary.withOpacity(0.98),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
                            color: AppColors.primary.withOpacity(0.98),
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Swayam",
                                        style: TextStyle(
                                            color: Colors.orange[900],
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                            height: 1.3),
                                      ),
                                      TextSpan(
                                        text: "Library",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Explore a universe of books and knowledge",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text("...................................", style: TextStyle(color: Colors.white54),),
                                SizedBox(height: 20),
                                Text(
                                  "© 2024 Swayam Library. All Rights Reserved.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadiusDirectional.only(
                                bottomEnd: Radius.circular(15),
                                bottomStart: Radius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
