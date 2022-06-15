import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goddessGuild/Library/bubbleTabCustom/bubbleTab.dart';
import 'package:goddessGuild/constants.dart';

import 'package:goddessGuild/Screen/B1_Home/Home_Search/search_page.dart';
import 'package:goddessGuild/Screen/B2_Category/Category_Place/L1/stripclub.dart';
import 'package:goddessGuild/Screen/B2_Category/Category_Place/L1/category/bacheloretteEvents.dart';
import 'package:goddessGuild/Screen/B2_Category/Category_Place/L1/category/stripclubEvents.dart';
import 'package:goddessGuild/Screen/B2_Category/Category_Place/L1/category/bachelorEvents.dart';
import 'package:goddessGuild/Screen/B2_Category/Page_Transformer_Card/page_transformer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'category/patronEventSubset.dart';

class stripclub extends StatefulWidget {
  String user_id, nameAppbar;
  stripclub({this.user_id, this.nameAppbar});

  _stripclubState createState() => _stripclubState();
}

class _stripclubState extends State<stripclub> {
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
                                      EVENT_TYPES[0], // bachlor party
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  new Tab(
                                    child: Text(
                                      EVENT_TYPES[1],
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  new Tab(
                                    child: Text(
                                      EVENT_TYPES[2],
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        body: new TabBarView(
                          children: [
                            patronEventSubset(
                              idUser: widget.user_id,
                              event_filter: null,
                            ),
                            patronEventSubset(
                              idUser: widget.user_id,
                              event_filter: EVENT_TYPES[0],
                            ),
                            patronEventSubset(
                              idUser: widget.user_id,
                              event_filter: EVENT_TYPES[1],
                            ),
                            patronEventSubset(
                              idUser: widget.user_id,
                              event_filter: EVENT_TYPES[2],
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
                  widget.nameAppbar,
                  style: TextStyle(
                      fontFamily: "Sofia",
                      fontWeight: FontWeight.w800,
                      fontSize: 27.0,
                      letterSpacing: 1.5,
                      color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new searchPage(
                                  idUser: widget.user_id,
                                )));
                      },
                      child: Icon(
                        Icons.search,
                        size: 28.0,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
