import 'package:flutter/material.dart';

import 'components.dart';

class MoreScreen2 extends StatefulWidget {
  @override
  _MoreScreen2State createState() => _MoreScreen2State();
}

class _MoreScreen2State extends State<MoreScreen2> {
  void _showPopupMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                // Handle edit profile action
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                Navigator.pop(context);
                // Handle change password action
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                // Handle sign out action
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildContainer(String text, IconData icon, Color color) {
    return Container(
      height: 106,
      width: 150,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: color.withOpacity(0.6),
                ),
                SizedBox(height: 10),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 10,
                shadowColor: Colors.black54,
                color: Colors.blue[200],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            'https://i1.wp.com/pagesix.com/wp-content/uploads/sites/3/2017/04/colson.jpg?quality=90&strip=all&ssl=1', // Replace with the actual URL of the user image
                            width: 100,
                            height: 115,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'User Name', // Replace with the actual user name
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
                            ),
                            SizedBox(height: 2),
                            Text('user@example.com', style: TextStyle(color: Colors.black87, fontSize: 16)), // Replace with the actual email
                            SizedBox(height: 5),
                            Text('123-456-7890', style: TextStyle(color: Colors.black87, fontSize: 16)), // Replace with the actual mobile number
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showPopupMenu(context);
                        },
                        child: Icon(Icons.more_vert, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildContainer('Reading Insights', Icons.bar_chart, Colors.purple),
                      buildContainer('Membership', Icons.card_membership, Colors.teal),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildContainer('Subscription Plans', Icons.subscriptions, Colors.orange),
                      buildContainer('Borrow History', Icons.history, Colors.blue),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildContainer('Settings', Icons.settings, Colors.black),
                      buildContainer('Help & Feedback', Icons.help_outline, Colors.green),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildContainer('Swayam Library Physical', Icons.maps_home_work_outlined, Colors.pink),
                      buildContainer('Info', Icons.info_outline, Colors.cyan),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
