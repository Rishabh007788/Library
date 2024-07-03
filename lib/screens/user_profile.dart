import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:first_project/screens/app_colors.dart';
import 'package:first_project/screens/session_manager.dart';
import 'package:flutter/material.dart';

import 'change_password.dart';
import 'edit_profile.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfile createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  bool isLoading = true;
  String userId = "";
  bool isLoggedIn = false;
  Map userData = {};
  Map membership = {};

  Future<void> getUserId() async {
    String? fetchedUserId = await SessionManager.getUserId();
    bool? fetchedIsLoggedIn = await SessionManager.isLoggedIn();

    if (fetchedUserId != null) {
      print('User ID is fetched###############: $fetchedUserId login status: $fetchedIsLoggedIn');
    } else {
      print('User ID not found');
    }
    setState(() {
      userId = fetchedUserId ?? "";
      isLoggedIn = fetchedIsLoggedIn ?? false;
    });

    if (userId.isNotEmpty) {
      await fetchUser();
    }
  }

  Future<void> fetchUser() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.29.145:8888/register?user_id=${Uri.encodeFull(userId)}"));
      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body);
          membership = userData['membership'];
          isLoading = false;
        });
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _onRefresh() async {
    await fetchUser();
  }


  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/profilebackground.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.white,
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onSelected: (String value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfile(userData: userData),
                    ),
                  );
                } else if (value == 'change_password') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePassword(),
                    ),
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit Profile'),
                  ),
                  PopupMenuItem<String>(
                    value: 'change_password',
                    child: Text('Change Password'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/profilebackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.only(top: 50, bottom: 5),
              child: isLoading?
                  Container(
                    height: 300,
                    color: Colors.transparent,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                  :Column(
                children: [
                  Text(
                    userData['name'] ?? 'Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 18),
                  Container(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 60,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Column(
                      children: [
                        userInfoRow(Icons.person_outline, userData['name'] ?? 'Name'),
                        userInfoRow(Icons.phone_android_outlined, userData['mobile'] ?? 'Mobile'),
                        userInfoRow(Icons.email_outlined, userData['email'] ?? 'Email'),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 15, bottom: 5, left: 10),
                    child: Text(
                      "Active Plan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  membership.isEmpty
                      ? Container(
                    height: 230,
                    width: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black54,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No Active Plan"),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "membershipscreen");
                            },
                            child: Text("Get Membership")),
                      ],
                    ),
                  )
                      : Container(
                    height: 230,
                    width: 320,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black54,
                        width: 1,
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
                                  height: 1.3,
                                ),
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
                                text: userData['membership']?['type'] ?? '',
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
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            // border: Border.all(
                            //   color: Colors.black54,
                            //   width: 0,
                            // ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Expires On: ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[300],
                                ),
                              ),
                              Text(
                                userData['membership']?['End_Date'] ?? 'End Date',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[300],
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
                                    text: userData['membership']?['price']?.toString() ?? 'Price',
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
                                    text: userData['membership']?['duration_in_months']?.toString() ?? 'Duration',
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
                              membershipFeature("✓   ", "Physical Library Access"),
                              membershipFeature("✓   ", "Unlimited eBooks reading"),
                              membershipFeature("✓   ", "24×7 Support"),
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
        ),
      ),
    );
  }

  Widget userInfoRow(IconData icon, String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: BorderDirectional(
          bottom: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      padding: EdgeInsets.all(13),
      child: Row(
        children: [
          Icon(icon, size: 30, color: AppColors.primary),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget membershipFeature(String prefix, String text) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: prefix,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
