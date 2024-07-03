import 'package:first_project/screens/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'app_colors.dart';

class OwnedBooksPage extends StatefulWidget {
  final String category;

  OwnedBooksPage({Key? key, required this.category}) : super(key: key);

  @override
  _OwnedBooksPageState createState() => _OwnedBooksPageState();
}

class _OwnedBooksPageState extends State<OwnedBooksPage> {
  bool isLoading = true;
  List listData = [];
  String user_id = "";

  Future<void> getUserId() async {
    String? userId = await SessionManager.getUserId();
    if (userId != null) {
      print("fetched userid = $userId");
      setState(() {
        user_id = userId;
      });
    }
    if(user_id.isNotEmpty){
      print("user_id = $user_id");
      fetchLibrary();
    }
  }

  Future<void> fetchLibrary() async {
    final response = await http.get(Uri.parse("http://192.168.29.145:8888/user_cart?user_id=$user_id"));
    if (response.statusCode == 200) {
      setState(() {
        final mapResponse = json.decode(response.body);
        listData = mapResponse["books"];
        isLoading = false;
        print("Datafetched successfully");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Books",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                    ),
                  ),
                  InkWell(
                    child: Icon(
                      Icons.sort,
                      color: Colors.black,
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
            Wrap(
              spacing: 15.0,
              runSpacing: 15.0,
              children: List.generate(listData.length, (index) {
                return Stack(
                  children: [
                    Container(
                      height: 180, // Set your desired height
                      width: 130, // Set your desired width
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        child: Image.network(
                          listData[index]['image_url'],
                          fit: BoxFit.cover,
                          height: 150,
                          width: 130,
                        ),
                      ),
                    ),
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
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
