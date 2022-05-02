import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goddessGuild/Library/bubbleTabCustom/bubbleTab.dart';
import 'package:goddessGuild/Screen/B1_Home/Home_Search/search_page.dart';
import 'package:goddessGuild/Screen/B2_Category/Category_Place/L2/category/allBrazil.dart';
import 'package:goddessGuild/Screen/B2_Category/Category_Place/L2/category/artBrazil.dart';
import 'package:goddessGuild/Screen/B2_Category/Category_Place/L2/category/musicBrazil.dart';
import 'package:goddessGuild/Screen/B2_Category/Category_Place/L2/category/sportBrazil.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class brazil extends StatefulWidget {
  String userId;
  brazil({this.userId});

  _brazilState createState() => _brazilState();
}

class _brazilState extends State<brazil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 4,
                      child: new Scaffold(
                        backgroundColor: Colors.white,
                        appBar: PreferredSize(
                          preferredSize:
                              Size.fromHeight(40.0), // here the desired height
                          child: new AppBar(
                              backgroundColor: Colors.transparent,
                              elevation: 0.0,
                              centerTitle: true,
                              automaticallyImplyLeading: false,
                              title: new TabBar(
                                indicatorSize: TabBarIndicatorSize.tab,
                                unselectedLabelColor: Colors.black12,
                                labelColor: Colors.white,
                                labelStyle: TextStyle(fontSize: 19.0),
                                indicator: new BubbleTabIndicator(
                                  indicatorHeight: 36.0,
                                  indicatorColor: Color(0xFF928CEF),
                                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                                ),
                                tabs: <Widget>[
                                  new Tab(
                                    child: Text(
                                      "All",
                                      style: TextStyle(
                                        fontSize: 11.2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  new Tab(
                                    child: Text(
                                      "Sport",
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  new Tab(
                                    child: Text(
                                      "Art",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  new Tab(
                                    child: Text(
                                      "Music",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        body: new TabBarView(
                          children: [
                            allBrazil(
                              idUser: widget.userId,
                            ),
                            sportBrazil(
                              idUser: widget.userId,
                            ),
                            artBrazil(
                              idUser: widget.userId,
                            ),
                            musicBrazil(
                              idUser: widget.userId,
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
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              left: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.clear)),
                Text(
                  "Level 2: Gentlemen's Club",
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