import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class searchDetail extends StatefulWidget {
  @override
  final String title,
      category,
      imageUrl,
      description,
      price,
      time,
      date,
      place,
      id,
      userId;
  final index;

  searchDetail(
      {this.id,
      this.category,
      this.description,
      this.price,
      this.imageUrl,
      this.index,
      this.time,
      this.date,
      this.place,
      this.title,
      this.userId});

  _searchDetailState createState() => _searchDetailState();
}

class _searchDetailState extends State<searchDetail> {
  @override
  Widget build(BuildContext context) {
    void addData() {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        SharedPreferences prefs;
        prefs = await SharedPreferences.getInstance();
        FirebaseFirestore.instance
            .collection("users")
            .doc(widget.userId)
            .collection('Join Event')
            .add({
          "user": "userss",
          "title": widget.title,
          "category": widget.category,
          "img": widget.imageUrl,
          "description": widget.description,
          "price": widget.price,
          "time": widget.time,
          "date": widget.date,
          "id": widget.id,
          "place": widget.place
        });
      });
      Navigator.pop(context);
    }

    /// Hero animation for image
    final hero = Hero(
      tag: 'hero-tag-list-${widget.id}',
      child: new DecoratedBox(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: new NetworkImage(widget.imageUrl),
          ),
          shape: BoxShape.rectangle,
        ),
        child: Container(
          margin: EdgeInsets.only(top: 130.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.8),
                Colors.white.withOpacity(0.65),
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.01),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              /// Appbar Custom using a SliverAppBar
              SliverAppBar(
                centerTitle: true,
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                expandedHeight: MediaQuery.of(context).size.height - 90,
                elevation: 0.1,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Container(
                      width: 220.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Text(
                          "Event",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.5,
                              letterSpacing: 1.2,
                              fontFamily: "Popins",
                              fontWeight: FontWeight.w700),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    background: Stack(
                      children: <Widget>[
                        Material(
                          child: hero,
                        ),
                      ],
                    )),
              ),

              SliverToBoxAdapter(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30.0, left: 20.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            fontFamily: "Popins"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            color: Colors.black26,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.date,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily: "Popins"),
                                ),
                                Text(
                                  widget.time,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.place,
                            color: Colors.black26,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Location",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily: "Popins"),
                                ),
                                Text(
                                  widget.place,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.payment,
                            color: Colors.black26,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              widget.price,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily: "Popins"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      height: 20.0,
                      width: double.infinity,
                      color: Colors.black12.withOpacity(0.04),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0, left: 20.0),
                      child: Text(
                        "About",
                        style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: "Popins"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
                      child: Text(
                        widget.description,
                        style: TextStyle(
                            fontFamily: "Popins",
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                      child: Text(
                        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                        style: TextStyle(
                            fontFamily: "Popins",
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                      child: Text(
                        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",
                        style: TextStyle(
                            fontFamily: "Popins",
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(
                      height: 100.0,
                    )
                  ])),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70.0,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      widget.price,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 19.0,
                          fontFamily: "Popins"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: InkWell(
                      onTap: () {
                        addData();
                      },
                      child: Container(
                        height: 50.0,
                        width: 180.0,
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0))),
                        child: Center(
                          child: Text(
                            "Join Event",
                            style: TextStyle(
                                fontFamily: "Popins",
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
