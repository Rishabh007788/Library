import 'package:first_project/screens/login_screen.dart';
import 'package:first_project/screens/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'components.dart';
import 'session_manager.dart';

class MoreScreen extends StatefulWidget{
  const MoreScreen({Key? key}):super(key: key);
  @override
  _MoreScreen createState() => _MoreScreen();
}


class _MoreScreen extends State<MoreScreen>{

  String user_id = "";
  bool isLoggedIn = false;


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
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text('Are you sure you want to sign-out?',
            style: TextStyle(fontSize: 17),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                SessionManager.clearSession();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  'login',
                      (Route<dynamic> route) => false,
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopBar(),
            Container(
              padding: EdgeInsets.only(top: 30),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                          border: BorderDirectional(
                            bottom: BorderSide(
                              width: 0.8,
                              color: Colors.grey[600]!,
                            ),
                          )
                        ),
                        //color: Colors.grey,
                        child: TextButton(onPressed: (){
                          Navigator.pushNamed(context, 'userprofile');
                        },

                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 30,
                                    color: Colors.black,
                                ),
                                Text(
                                  " Profile",
                                  style: TextStyle(
                                    fontSize: 17,
                                    letterSpacing:0.5,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            )),
                      ),


                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: BorderDirectional(
                              bottom: BorderSide(
                                width: 0.8,
                                color: Colors.grey[600]!,
                              ),
                            )
                        ),
                        child: TextButton(onPressed: (){},
                            child: Row(
                              children: [
                                Icon(Icons.local_fire_department_sharp, size: 30, color: Colors.black),

                                Text(
                                  " Reading Insights",
                                  style: TextStyle(
                                      fontSize: 17,
                                      letterSpacing:0.5,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            )),
                      ),


                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: BorderDirectional(
                              bottom: BorderSide(
                                width: 0.8,
                                color: Colors.grey[600]!,
                              ),
                            )
                        ),
                        child: TextButton(onPressed: (){
                          print(isLoggedIn);
                          print("membership button tapped");
                          Navigator.pushNamed(context, 'membershipscreen');
                        },
                            child: Row(
                              children: [
                                Icon(Icons.workspace_premium_outlined, size: 30, color: Colors.black),

                                Text(
                                  " Membership",
                                  style: TextStyle(
                                      fontSize: 17,
                                      letterSpacing:0.5,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            )),
                      ),


                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: BorderDirectional(
                              bottom: BorderSide(
                                width: 0.8,
                                color: Colors.grey[600]!,
                              ),
                            )
                        ),
                        child: TextButton(onPressed: (){},
                            child: Row(
                              children: [
                                Icon(Icons.settings_sharp,size: 30, color: Colors.black),
                                Text(
                                  " Settings",
                                  style: TextStyle(
                                      fontSize: 17,
                                      letterSpacing:0.5,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            )),
                      ),

                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: BorderDirectional(
                              bottom: BorderSide(
                                width: 0.8,
                                color: Colors.grey[600]!,
                              ),
                            )
                        ),
                        child: TextButton(onPressed: (){},
                            child: Row(
                              children: [
                                Icon(Icons.maps_home_work_sharp,size: 30, color: Colors.black),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: " Swayam Library ",
                                        style: TextStyle(
                                            fontSize: 17,
                                            letterSpacing:0.5,
                                          color: Colors.black
                                        ),
                                      ),
                                      TextSpan(
                                        text: "(physical)",
                                        style: TextStyle(
                                          fontSize: 15,
                                            color: Colors.black
                                        )
                                      )
                                    ]
                                  ),
                                )
                              ],
                            )),
                      ),



                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: BorderDirectional(
                              bottom: BorderSide(
                                width: 0.8,
                                color: Colors.grey[600]!,
                              ),
                            )
                        ),
                        height: 55,
                        child: TextButton(onPressed: (){},
                            child: Row(
                              children: [
                                Icon(Icons.info_sharp,size: 30, color: Colors.black),
                                Text(
                                  " Info",
                                  style: TextStyle(
                                      fontSize: 17,
                                      letterSpacing:0.5,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            )),
                      ),



                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: BorderDirectional(
                              bottom: BorderSide(
                                width: 0.8,
                                color: Colors.grey[600]!,
                              ),
                            )
                        ),
                        child: TextButton(onPressed: (){},
                            child: Row(
                              children: [
                                Icon(Icons.feedback_sharp,size: 30, color: Colors.black,),
                                Text(
                                  " Help & Feedback",
                                  style: TextStyle(
                                      fontSize: 17,
                                      letterSpacing:0.5,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            )),
                      ),



                  FutureBuilder<bool>(
                    future: SessionManager.isLoggedIn(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        bool isLoggedIn = snapshot.data ?? false;
                        return isLoggedIn
                            ? Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: BorderDirectional(
                              bottom: BorderSide(
                                width: 0.8,
                                color: Colors.grey[600]!,
                              ),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              // SessionManager.clearSession();
                              // Navigator.of(context).pushNamedAndRemoveUntil(
                              //   'login', // Replace with your login route name
                              //       (Route<dynamic> route) => false, // Remove all routes until this condition is true
                              //
                              _showSignOutDialog(context);
                            },
                            child: Row(
                              children: [
                                Icon(Icons.output_sharp, size: 30, color: Colors.black),
                                Text(
                                  " Sign Out",
                                  style: TextStyle(
                                    fontSize: 17,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: BorderDirectional(
                              bottom: BorderSide(
                                width: 0.8,
                                color: Colors.grey[600]!,
                              ),
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Mylogin()),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.output_sharp, size: 30, color: Colors.black),
                                Text(
                                  " Sign In",
                                  style: TextStyle(
                                    fontSize: 17,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  )

                  ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}