import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goddessGuild/Library/bubbleTabCustom/bubbleTab.dart';
import 'package:goddessGuild/constants.dart';
import 'package:goddessGuild/Screen/B1_Home/Home_Search/search_page.dart';
import 'package:goddessGuild/Screen/B2_Category/Category_Place/L2/category/allBrazil.dart';
import 'package:goddessGuild/Screen/B2_Category/Category_Place/L2/category/artBrazil.dart';
import 'package:goddessGuild/Screen/B2_Category/Category_Place/L2/category/musicBrazil.dart';
import 'package:goddessGuild/Screen/B2_Category/Category_Place/L2/category/sportBrazil.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class needMoreLevels extends StatefulWidget {
  String user_id, nameAppbar;
  needMoreLevels({this.user_id, this.nameAppbar});

  _needMoreLevelsState createState() => _needMoreLevelsState();
}

class _needMoreLevelsState extends State<needMoreLevels> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[

              Text(
                "Error: 0x06",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 30.0,
                  letterSpacing: 1.5,
                  color: Colors.red,
                ),
              ),
              Text(
                "(user_insufficient_level)",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 25.0,
                  letterSpacing: 1.5,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Hint: Increase level to attend these events. "
                    "Go to lower level event to earn reputation ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  fontSize: 20.0,
                  letterSpacing: 1,
                  color: Colors.black,
                ),
              ),

            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              left: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.clear)),
                Text(
                  widget.nameAppbar,
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontWeight: FontWeight.w800,
                      fontSize: 17.0,
                      letterSpacing: 1,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
