import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goddessGuild/Library/loader_animation/dot.dart';
import 'package:goddessGuild/Library/loader_animation/loader.dart';

//import 'package:goddessGuild/Screen/B1_Home/Home_Search/searchBoxEmpty.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:goddessGuild/models.dart';

import '../../../event_detail.dart';
import 'Search_Detail_Home.dart';

class searchPage extends StatefulWidget {
  String idUser;
  List<GGEvent> ggEvents;

  searchPage({this.idUser, this.ggEvents});

  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  TextEditingController _addNameController;
  String searchString;

  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      setState(() {
        load = false;
      });
    });
    _addNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.deepPurpleAccent,
        ),
        title: Text(
          "Search",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 19.0,
              color: Colors.black54,
              fontFamily: "Sofia"),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
        Padding(
        padding:
        const EdgeInsets.only(top: 25.0, left: 20.0, right: 50.0),
        child: Text(
          "",
          style: TextStyle(
              letterSpacing: 0.1,
              fontWeight: FontWeight.w600,
              fontSize: 27.0,
              color: Colors.black54,
              fontFamily: "Sofia"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
            top: 25.0, right: 20.0, left: 20.0, bottom: 20.0),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15.0,
                    spreadRadius: 0.0)
              ]),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 10.0,
              ),
              child: Theme(
                data: ThemeData(hintColor: Colors.transparent),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      searchString = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.search,
                        color: Colors.black38,
                        size: 28.0,
                      ),
                      hintText: "Search",
                      hintStyle: TextStyle(
                          color: Colors.black38,
                          fontFamily: "Sofia",
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ),
        ),
      ),

      // Column(
      //     children:
      //     snapshot.data.docs.map((DocumentSnapshot document) {
      //       return Padding(
      //         padding: const EdgeInsets.only(
      //             left: 20.0, right: 20.0, top: 15.0, bottom: 5.0),
      //         child: InkWell(
      //           onTap: () {
      //             Navigator.of(context).push(
      //               PageRouteBuilder(
      //                   pageBuilder: (_, __, ___) =>
      //                   new eventListDetail(
      //
      //                   ),
      //                   transitionDuration:
      //                   Duration(milliseconds: 600),
      //                   transitionsBuilder: (_,
      //                       Animation<double> animation,
      //                       __,
      //                       Widget child) {
      //                     return Opacity(
      //                       opacity: animation.value,
      //                       child: child,
      //                     );
      //                   }),
      //             );
      //           },
      //           child: Container(
      //             width: double.infinity,
      //             decoration: BoxDecoration(
      //               color: Colors.white,
      //               borderRadius:
      //               BorderRadius.all(Radius.circular(10.0)),
      //               boxShadow: [
      //                 BoxShadow(
      //                     color: Colors.black12.withOpacity(0.1),
      //                     blurRadius: 1.0,
      //                     spreadRadius: 1.0)
      //               ],
      //             ),
      //             child: Row(
      //               children: <Widget>[
      //                 Hero(
      //                   tag: 'hero-tag-${document['id']}',
      //                   child: Material(
      //                     child: Container(
      //                       height: 180.0,
      //                       width: 120.0,
      //                       decoration: BoxDecoration(
      //                         image: DecorationImage(
      //                             image: NetworkImage(
      //                                 document['image_url']),
      //                             fit: BoxFit.cover),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 Padding(
      //                   padding: const EdgeInsets.only(
      //                       top: 20.0, left: 20.0),
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     crossAxisAlignment:
      //                     CrossAxisAlignment.start,
      //                     children: <Widget>[
      //                       Container(
      //                         width: 174.0,
      //                         child: Text(
      //                           document['title'],
      //                           style: TextStyle(
      //                             fontFamily: "Sofia",
      //                             fontSize: 18.0,
      //                             fontWeight: FontWeight.w700,
      //                           ),
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         height: 15.0,
      //                       ),
      //                       Row(
      //                         mainAxisAlignment:
      //                         MainAxisAlignment.start,
      //                         crossAxisAlignment:
      //                         CrossAxisAlignment.start,
      //                         children: <Widget>[
      //                           Icon(
      //                             Icons.location_on,
      //                             size: 16.0,
      //                             color: Colors.black38,
      //                           ),
      //                           SizedBox(
      //                             width: 5.0,
      //                           ),
      //                           Container(
      //                             width: 150.0,
      //                             child: Text(
      //                               document['address'],
      //                               style: TextStyle(
      //                                 fontFamily: "Sofia",
      //                                 fontSize: 14.0,
      //                                 fontWeight: FontWeight.w400,
      //                               ),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                       SizedBox(
      //                         height: 5.0,
      //                       ),
      //                       Row(
      //                         mainAxisAlignment:
      //                         MainAxisAlignment.start,
      //                         crossAxisAlignment:
      //                         CrossAxisAlignment.start,
      //                         children: <Widget>[
      //                           Icon(
      //                             Icons.date_range,
      //                             size: 16.0,
      //                             color: Colors.black38,
      //                           ),
      //                           SizedBox(
      //                             width: 5.0,
      //                           ),
      //                           Container(
      //                             width: 150.0,
      //                             child: Text(
      //                               document['date'],
      //                               style: TextStyle(
      //                                 fontFamily: "Sofia",
      //                                 fontSize: 13.0,
      //                                 fontWeight: FontWeight.w400,
      //                               ),
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                       SizedBox(
      //                         height: 10.0,
      //                       ),
      //                       Row(
      //                         mainAxisAlignment:
      //                         MainAxisAlignment.start,
      //                         crossAxisAlignment:
      //                         CrossAxisAlignment.start,
      //                         children: <Widget>[
      //                           Icon(
      //                             Icons.monetization_on,
      //                             size: 16.0,
      //                             color: Colors.black38,
      //                           ),
      //                           SizedBox(
      //                             width: 5.0,
      //                           ),
      //                           Text(
      //                             document['price'],
      //                             style: TextStyle(
      //                               fontFamily: "Sofia",
      //                               fontSize: 15.0,
      //                               fontWeight: FontWeight.w400,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                       SizedBox(
      //                         height: 10.0,
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       );
      //     }).toList())
      ],
    ),)
    ,
    );
  }
}

///
///
/// If no item cart this class showing
///
class noItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: 500.0,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                EdgeInsets.only(top: mediaQueryData.padding.top + 30.0)),
            Image.asset(
              "assets/image/searching.png",
              height: 200.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Text(
              "No Matching Views ",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.5,
                  color: Colors.black26.withOpacity(0.3),
                  fontFamily: "Popins"),
            ),
          ],
        ),
      ),
    );
  }
}
