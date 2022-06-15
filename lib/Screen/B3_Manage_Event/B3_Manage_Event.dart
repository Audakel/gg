import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:goddessGuild/db_service.dart';
import 'package:goddessGuild/models.dart';
import 'Manage_Event_Detail.dart';
import 'package:goddessGuild/gg_widgets.dart';

class manageEvent extends StatefulWidget {
  final String uid;

  manageEvent({this.uid});

  manageEventState createState() => manageEventState();
}

class manageEventState extends State<manageEvent> {
  bool checkMail = true;
  String mail;

  SharedPreferences prefs;

  Future<Null> _function() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    this.setState(() {
      mail = prefs.getString("username") ?? '';
    });
  }

  ///
  /// Get image data dummy from firebase server
  ///
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/Artboard%203.png?alt=media&token=dc7f4bf5-8f80-4f38-bb63-87aed9d59b95");

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
  bool loadImage = true;

  @override
  void initState() {
    setState(() {
      loadImage = false;
    });

    _function();
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Text(
            "Your Upcoming Events",
            style: TextStyle(
              fontFamily: "Popins",
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              fontSize: 26.0,
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
                child: FutureBuilder<List<GGEvent>>(
                    future: getAllWorkedEventsOfAGoddess(),
                    builder: (
                      BuildContext ctx,
                      AsyncSnapshot<List<GGEvent>> ggEvents,
                    ) {
                      if (!ggEvents.hasData) {
                        return noItem();
                      }
                      if (loadImage) {
                        return loadingEventsHeader(ctx);
                      } else {
                        //return new manageEventCard(ggEvents: ggEvents.data);
                        return new GGEventCardList(ggEventList: ggEvents.data);
                      }

                      //  return  new noItem();
                    })),
            SizedBox(
              height: 40.0,
            )
          ],
        ),
      ),
    );
  }
}

/**
class manageEventCard extends StatelessWidget {
  manageEventCard({this.ggEvents});

  final List<GGEvent> ggEvents;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            const Color(0xFF000000),
            const Color(0x00000000),
            Colors.black,
            Colors.black,
            Colors.black,
            Colors.black,
          ],
        ),
      ),
    );

    return SizedBox.fromSize(
//      size: const Size.fromHeight(410.0),
        child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.only(top: 0.0),
      itemCount: ggEvents.length,
      itemBuilder: (context, i) {
        /**
         * String _title = ggEvents[i].data()['title'].toString();
        String _date = ggEvents[i].data()['date'].toString();
        String _time = ggEvents[i].data()['time'].toString();
        String _img = ggEvents[i].data()['image_url'].toString();
        String _desc = ggEvents[i].data()['desc1'].toString();
        String _desc2 = ggEvents[i].data()['desc2'].toString();
        String _desc3 = ggEvents[i].data()['desc3'].toString();
        String _price = ggEvents[i].data()['price'].toString();
        String _category = ggEvents[i].data()['category'].toString();
        String _id = ggEvents[i].data()['id'].toString();
        String _place = ggEvents[i].data()['address'].toString();
        String _user_id = .data()['user'].toString();
        */
        return Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
          child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new manageEventDetail(ggEvents[i]),
                      transitionDuration: Duration(milliseconds: 600),
                      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                        return Opacity(
                          opacity: animation.value,
                          child: child,
                        );
                      }),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.2), spreadRadius: 3.0, blurRadius: 10.0)]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Hero(
                        tag: 'hero-tag-list-$_id',
                        child: Material(
                          child: Container(
                            height: 165.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: NetworkImage(_img), fit: BoxFit.cover),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => NetworkGiffyDialog(
                                            image: Image.network(
                                              "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
                                              fit: BoxFit.cover,
                                            ),
                                            title: Text('Cancel this event?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontFamily: "Gotik", fontSize: 22.0, fontWeight: FontWeight.w600)),
                                            description: Text(
                                              "Are you sure you want to delete the event activity " + _title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontFamily: "Popins", fontWeight: FontWeight.w300, color: Colors.black26),
                                            ),
                                            onOkButtonPressed: () {
                                              Navigator.pop(context);
                                              FirebaseFirestore.instance
                                                  .collection("JoinEvent")
                                                  .doc("user")
                                                  .collection(_title)
                                                  .doc(_user_id)
                                                  .delete();

                                              FirebaseFirestore.instance.runTransaction((transaction) async {
                                                DocumentSnapshot snapshot = await transaction.get(ggEvents[i].reference);
                                                await transaction.delete(snapshot.reference);
                                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                                prefs.remove(_title);
                                              });
                                              Scaffold.of(context).showSnackBar(SnackBar(
                                                content: Text("Cancel event " + _title),
                                                backgroundColor: Colors.red,
                                                duration: Duration(seconds: 3),
                                              ));
                                            },
                                          ));
                                },
                                child: CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.black38,
                                    )),
                              ),
                            ),
                            alignment: Alignment.topRight,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 13.0, top: 7.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5.0),
                            Text(
                              _title,
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17.0, fontFamily: "Popins"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Icon(
                                      Icons.place,
                                      size: 17.0,
                                    ),
                                    Container(
                                        width: 120.0,
                                        child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              _place,
                                              style:
                                                  TextStyle(fontSize: 14.0, fontFamily: "popins", fontWeight: FontWeight.w400, color: Colors.black38),
                                              overflow: TextOverflow.ellipsis,
                                            )))
                                  ]),
                                  Row(children: <Widget>[
                                    Icon(
                                      Icons.timer,
                                      size: 17.0,
                                    ),
                                    Container(
                                        width: 140.0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            _date,
                                            style:
                                                TextStyle(fontSize: 14.0, fontFamily: "popins", fontWeight: FontWeight.w400, color: Colors.black38),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                  ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
    ));
  }
}


 */






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
            Padding(padding: EdgeInsets.only(top: mediaQueryData.padding.top + 80.0)),
            Image.asset(
              "assets/image/IlustrasiCart.png",
              height: 300.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Text(
              "Not dancing",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19.5, color: Colors.black26.withOpacity(0.2), fontFamily: "Popins"),
            ),
          ],
        ),
      ),
    );
  }
}
