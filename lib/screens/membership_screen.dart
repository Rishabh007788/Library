import 'dart:convert';
import 'package:first_project/screens/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'app_colors.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  _MembershipScreen createState() => _MembershipScreen();
}

class _MembershipScreen extends State<MembershipScreen> {
  List membershipList = [];
  bool userDataIsLoading = true;
  String userId = "";
  bool isLoggedIn = false;
  Map userData = {};
  Map membership = {};
   bool membershipPlansIsLoading = true;
   String _warningMessage = '';


  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Membership Purchesed'),
          content: Text('.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                fetchUser();
              },
            ),
          ],
        );
      },
    );
  }

  void getUserId() async {
    String? fetchedUserId = await SessionManager.getUserId();

    print("Checking book in library");
    if (fetchedUserId != null) {
    } else {
      print('User ID not found');
    }
    setState(() {
      userId = fetchedUserId!;
    });
    if (userId.isNotEmpty) {
      await fetchUser();
    }
  }

  Future<void> fetchUser() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.29.145:8888/register?user_id=$userId"));
      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body);
          membership = userData['membership'];
          userDataIsLoading = false;
        });
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future fetchMembership() async {
    final response = await http.get(Uri.parse("http://192.168.29.145:8888/membership"));
    if (response.statusCode == 200) {
      setState(() {
        var mapPopularBooks = json.decode(response.body);
        membershipList = mapPopularBooks["memberships"];
        membershipPlansIsLoading = false;
      });
    }
  }

  Future<void> _submitForm(String membership_id) async {
      setState(() {
        membershipPlansIsLoading = true;
        userDataIsLoading = true;
      });
      try {
        final response = await http.post(
          Uri.parse('http://192.168.29.145:8888/user/membership'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
           "user_id": userId,
            "membership_id": membership_id,
          }),
        );
        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          print('response : $responseBody');
          _showSuccessDialog();
        } else {
          setState(() {
            _warningMessage = 'Failed : ${response.body}';
          });
        }
      } finally {
        setState(() {
          membershipPlansIsLoading = false;
          userDataIsLoading=false;
        });
      }
  }

  Future<void> _onRefresh() async {
    await fetchUser();
    await fetchMembership();
  }



  @override
  void initState() {
    super.initState();
    getUserId();
    fetchMembership();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Search bar
              Expanded(
                child: Container(
                  height: 20, // Adjust the height as needed
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Background color of the search bar
                    borderRadius: BorderRadius.circular(8), // Rounded corners
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
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
              color: Colors.grey[300],
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 15, bottom: 5, left: 10),
              child: Text(
                "Active Plan",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                ),
              ),
            ),
            userDataIsLoading?
                Container(
                  height: 260,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),

                )
                :Container(
              height: 260,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
              color: Colors.grey[200],
              child: membership.isEmpty?
              Container(
                height: 200,
                width: 280,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10), // Radius for rounded corners
                  border: Border.all(
                    color: Colors.black54, // Border color
                    width: 1, // Border width
                  ),
                ),
                child: Center(
                  child: Text(
                    "No Active Plan..."
                  ),
                ),
              ):Container(
                height: 230,
                width: 280,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10), // Radius for rounded corners
                  border: Border.all(
                    color: Colors.black54, // Border color
                    width: 1, // Border width
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Swayam",
                            style: TextStyle(
                                color: Colors.orange[900],
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                height: 1.3),
                          ),
                          TextSpan(
                            text: "Premium",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              height: 1.3,
                            ),
                          ),
                          TextSpan(
                            text: membership['type'],
                            style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.transparent, // Background color of the container
                        borderRadius: BorderRadius.circular(20), // Radius for rounded corners
                        // border: Border.all(
                        //   color: Colors.black54, // Border color
                        //   width: 0, // Border width
                        // ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Expires On: ",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[300]
                            ),
                          ),
                          Text(
                            membership['End_Date'],
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[300]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(text: TextSpan(
                            children: [
                              TextSpan(
                                  text: membership['price'].toString(),
                                  style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                  )
                              ),
                            ]
                        ),
                        ),
                        RichText(text: TextSpan(
                            children: [
                              TextSpan(
                                  text: " for ",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                  )
                              ),
                              TextSpan(
                                  text: membership['duration_in_months'].toString(),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                  )
                              ),
                              TextSpan(
                                  text: " months",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                  )
                              ),
                            ]
                        ),
                        ),
                      ],
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "✓   ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    )
                                ),
                                TextSpan(
                                    text: "  Physical Library Access",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    )
                                )
                              ]
                          ),
                          ),
                          RichText(text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "✓   ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    )
                                ),
                                TextSpan(
                                    text: "  Unlimited eBooks reading",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    )
                                )
                              ]
                          ),
                          ),
                          RichText(text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "✓   ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    )
                                ),
                                TextSpan(
                                    text: "  24×7 Support",
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0.8,
                                      fontSize: 16,
                                    )
                                )
                              ]
                          ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
              padding: EdgeInsets.only(top: 15, bottom: 5, left: 10),
              child: Text(
                "MemberShip Plans",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                ),
              ),
            ),
            Container(
              height: 260,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 15, bottom: 15),
              color: Colors.grey[200],
              child: membershipPlansIsLoading
                  ? Center(child: CircularProgressIndicator())
                  : membershipList.isEmpty
                  ? Center(child: Text("No memberships available"))
                  : PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                itemCount: membershipList.length,
                itemBuilder: (context, index) {
                  var data = membershipList[index];
                  return Container(
                    margin: EdgeInsets.only(right: 15),
                    height: 230,
                    width: 320,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10), // Radius for rounded corners
                      border: Border.all(
                        color: Colors.black54, // Border color
                        width: 1, // Border width
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Swayam",
                                style: TextStyle(
                                    color: Colors.orange[900],
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                    height: 1.3),
                              ),
                              TextSpan(
                                text: "Premium ",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  height: 1.3,
                                ),
                              ),
                              TextSpan(
                                text: data['type'],
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: data['price'].toString(),
                                    style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: " for ",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: data['duration_in_months'].toString(),
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " months",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "✓   ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "  Physical Library Access",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "✓   ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "  Unlimited eBooks reading",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "✓   ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "  24×7 Support",
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 0.8,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if(userId.isEmpty){
                              Navigator.pushNamed(context, "login");
                            }
                            else{
                              _submitForm(data['_id']);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue, // Background color
                            elevation: 5, // Elevation
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Rounded corners
                              side: BorderSide(color: Colors.black54, width: 2), // Border color and width
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10), // Adjust padding for a smaller button
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Get', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)), // Text
                            ],
                          ),
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
    );
  }
}
