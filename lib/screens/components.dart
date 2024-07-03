
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class TopBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.only(top: 45, left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(15),
          bottomStart: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          // App name and bell icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        height: 1.3,
                      ),
                    ),
                    TextSpan(
                      text: "Library",
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
              Stack(
                children: [
                  Icon(
                    Icons.notifications,
                    size: 25,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          // search bar and sort icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Search bar
              Expanded(
                child: Container(
                  height: 43,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Background color of the search bar
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Category/Author/Title...",
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
            ],
          ),
        ],
      ),
    );
  }
}