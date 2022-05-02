import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:showcaseview/showcaseview.dart';

import 'Detail_Event.dart';
import 'Home_Search/search_page.dart';
import 'allPopularEvent.dart';

///
/// Intro if user open first apps
///
class showCaseHome extends StatefulWidget {
  String userId;

  showCaseHome({this.userId});
  _showCaseHomeState createState() => _showCaseHomeState();
}

class _showCaseHomeState extends State<showCaseHome> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
          builder: (context) => Home(
                userId: widget.userId,
              )),
    );
  }
}

class Home extends StatefulWidget {
  String userId;
  Home({this.userId});

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey _profileShowCase = GlobalKey();
  GlobalKey _searchShowCase = GlobalKey();

  @override

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
  bool loadImage = true;

  bool _connection = true;

  ///
  /// Check connectivity
  ///
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        loadImage = false;
      });
    });
    // TODO: implement initState

    @override
    void dispose() {
      super.dispose();
    }

    super.initState();
  }

  Widget _search = Container(
    height: 45.0,
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5.0,
              spreadRadius: 0.0)
        ]),
    child: Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            color: Colors.deepPurpleAccent,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            "Find some Goddesses",
            style: TextStyle(
                fontFamily: "Sofia",
                fontWeight: FontWeight.w400,
                color: Colors.black45,
                fontSize: 16.0),
          )
        ],
      ),
    ),
  );

  Widget build(BuildContext context) {
    SharedPreferences preferences;

    displayShowcase() async {
      preferences = await SharedPreferences.getInstance();
      bool showcaseVisibilityStatus = preferences.getBool("showShowcase");

      if (showcaseVisibilityStatus == null) {
        preferences.setBool("showShowcase", false).then((bool success) {
          if (success)
            print("Successfull in writing showshoexase");
          else
            print("some bloody problem occured");
        });

        return true;
      }

      return false;
    }

    displayShowcase().then((status) {
      if (status) {
        ShowCaseWidget.of(context).startShowCase([
          _profileShowCase,
          _searchShowCase,
        ]);
      }
    });

    return KeysToBeInherited(
      profileShowCase: _profileShowCase,
      searchShowCase: _searchShowCase,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Goddess Guild",
            style: TextStyle(
                fontFamily: "Sofia",
                fontWeight: FontWeight.w800,
                fontSize: 33.0,
                letterSpacing: 1.5,
                color: Colors.black),
          ),
          centerTitle: false,
          elevation: 0.0,
          actions: <Widget>[
            photoProfile(
              userId: widget.userId,
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new searchPage(
                                  idUser: widget.userId,
                                )));
                      },
                      child: search()),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Goddess Events",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: "Sofia",
                              fontSize: 17.0)),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    new allPopularEvents()));
                          },
                          child: Text("View all",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Sofia",
                                  color: Colors.deepPurpleAccent)))
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 0.0),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("event")
                            .snapshots(),
                        builder: (BuildContext ctx,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (loadImage) {
                            return _loadingDataHeader(ctx);
                          } else {
                            if (!snapshot.hasData) {
                              return _loadingDataHeader(ctx);
                            } else {
                              return new cardDataFirestore(
                                dataUser: widget.userId,
                                list: snapshot.data.docs,
                              );
                            }
                          }
                        },
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class photoProfile extends StatelessWidget {
  String userId;

  photoProfile({this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          var userDocument = snapshot.data;
          return Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 9.0),
              child: InkWell(
                  onTap: () {},
                  child: Showcase(
                    key: KeysToBeInherited.of(context).profileShowCase,
                    description: "Photo Profile",
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          image: DecorationImage(
                              image: NetworkImage(userDocument[
                                          "photoProfile"] !=
                                      null
                                  ? userDocument["photoProfile"]
                                  : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                              fit: BoxFit.cover)),
                    ),
                  )),
            ),
          ]);
        });
  }
}

class search extends StatelessWidget {
  const search({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: KeysToBeInherited.of(context).searchShowCase,
      description: "Click Here To Search Events",
      child: Container(
        height: 45.0,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5.0,
                  spreadRadius: 0.0)
            ]),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.search,
                color: Colors.deepPurpleAccent,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "Find on event",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                    fontSize: 16.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _loadingDataHeader(BuildContext context) {
  return ListView.builder(
    shrinkWrap: true,
    primary: false,
    itemCount: 8,
    itemBuilder: (context, i) {
      return cardHeaderLoading(context);
    },
  );
}

class cardDataFirestore extends StatelessWidget {
  String dataUser;
  cardDataFirestore({this.dataUser, this.list});

  final List<DocumentSnapshot> list;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: list.length,
        itemBuilder: (context, i) {
          String title = list[i].data()['title'].toString();
          String category = list[i].data()['category'].toString();
          String imageUrl = list[i].data()['imageUrl'].toString();
          String id = list[i].data()['id'].toString();
          String description = list[i].data()['desc1'].toString();
          String price = list[i].data()['price'].toString();
          String hours = list[i].data()['time'].toString();
          String date = list[i].data()['date'].toString();
          String location = list[i].data()['place'].toString();
          String description2 = list[i].data()['desc2'].toString();
          String description3 = list[i].data()['desc3'].toString();

          return InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new newsHeaderListDetail(
                        category: category,
                        desc: description,
                        price: price,
                        imageUrl: imageUrl,
                        index: list[i].reference,
                        time: hours,
                        date: date,
                        place: location,
                        title: title,
                        id: id,
                        userId: dataUser,
                        desc2: description2,
                        desc3: description3,
                      ),
                  transitionDuration: Duration(milliseconds: 600),
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return Opacity(
                      opacity: animation.value,
                      child: child,
                    );
                  }));
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: 'hero-tag-$id',
                    child: Material(
                      child: Container(
                        height: 390.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12.withOpacity(0.1),
                                  spreadRadius: 0.2,
                                  blurRadius: 0.5)
                            ]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Container(
                      width: 210.0,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            spreadRadius: 0.2,
                            blurRadius: 0.5)
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              title,
                              style: TextStyle(
                                  fontSize: 19.0,
                                  fontFamily: "Sofia",
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              location,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "Sofia",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              date,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "Sofia",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 3.0, bottom: 30.0),
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("JoinEvent")
                                      .doc("user")
                                      .collection(title)
                                      .snapshots(),
                                  builder: (BuildContext ctx,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return new joinEvent(
                                          list: snapshot.data.docs);
                                    }
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class joinEvent extends StatelessWidget {
  joinEvent({this.list});
  final List<DocumentSnapshot> list;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              height: 35.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                itemCount: list.length > 3 ? 3 : list.length,
                itemBuilder: (context, i) {
                  String _title = list[i].data()['name'].toString();
                  String _npm = list[i].data()['country'].toString();
                  String _img = list[i].data()['photoProfile'].toString();

                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Container(
                          height: 35.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(70.0)),
                              image: DecorationImage(
                                  image: NetworkImage(_img),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 135.0),
          child: Container(
            height: 38.0,
            width: 38.0,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurpleAccent, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(60.0))),
            child: Center(
              child: Text(
                "+" + list.length.toString(),
                style: TextStyle(fontFamily: "Popins"),
              ),
            ),
          ),
        )
      ],
    );
  }
}

Widget cardHeaderLoading(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0),
    child: Container(
      height: 390.0,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.grey[300],
          boxShadow: [
            BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                spreadRadius: 0.2,
                blurRadius: 0.5)
          ]),
      child: Shimmer.fromColors(
        baseColor: Colors.black38,
        highlightColor: Colors.white,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Container(
                height: 210.0,
                width: 180.0,
                decoration: BoxDecoration(color: Colors.black12, boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.1),
                      spreadRadius: 0.2,
                      blurRadius: 0.5)
                ]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 18.0,
                        width: 130.0,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        height: 13.0,
                      ),
                      Container(
                        height: 15.0,
                        width: 105.0,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        height: 13.0,
                      ),
                      Container(
                        height: 15.0,
                        width: 105.0,
                        color: Colors.black45,
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.black45,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.black45,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.black45,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey profileShowCase;
  final GlobalKey searchShowCase;
  final GlobalKey joinShowCase;

  KeysToBeInherited({
    this.profileShowCase,
    this.searchShowCase,
    this.joinShowCase,
    Widget child,
  }) : super(child: child);

  static KeysToBeInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KeysToBeInherited>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
