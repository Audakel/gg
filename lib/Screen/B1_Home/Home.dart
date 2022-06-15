import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:goddessGuild/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goddessGuild/gg_widgets.dart';
import '../../event_detail.dart';
import 'Home_Search/search_page.dart';
import 'allPopularEvent.dart';
import 'package:goddessGuild/db_service.dart';
import 'package:goddessGuild/constants.dart';
import 'package:showcaseview/showcaseview.dart';

///
/// Intro if user open first apps
///
class showCaseHome extends StatefulWidget {
  String user_id;

  showCaseHome({this.user_id});

  _showCaseHomeState createState() => _showCaseHomeState();
}

class _showCaseHomeState extends State<showCaseHome> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
          builder: (context) => Home(
                user_id: widget.user_id,
              )),
    );
  }
}

class Home extends StatefulWidget {
  String user_id;
  String _search_filter = "";

  Home({this.user_id});

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey _profileShowCase = GlobalKey();
  GlobalKey _searchShowCase = GlobalKey();

  List<GGEvent> _ggEvents = <GGEvent>[];

  @override

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
  bool loadImage = true;

  ///
  /// Check connectivity
  ///
  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
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
            "Goddesses",
            style: TextStyle(fontFamily: "Sofia", fontWeight: FontWeight.w800, fontSize: 33.0, letterSpacing: 1.5, color: Colors.black),
          ),
          centerTitle: false,
          elevation: 0.0,
          actions: <Widget>[
            profilePhoto(
              user_id: widget.user_id,
              globalKey: _profileShowCase,
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
                  InkWell(onTap: () {
                    // Navigator.of(context)
                    //     .push(PageRouteBuilder(pageBuilder: (_, __, ___) => new searchPage(idUser: widget.user_id, ggEvents: _ggEvents)));
                  }, child: search(search_function: (xxx) {
                    setState(() {widget._search_filter = xxx;});
                  })),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Goddesses Needed For These Events!", style: TextStyle(fontWeight: FontWeight.w600, fontFamily: "Sofia", fontSize: 17.0)),
                      InkWell(
                          onTap: () {
                            //Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => new allPopularEvents()));
                          },
                          child: Text("View all", style: TextStyle(fontWeight: FontWeight.w400, fontFamily: "Sofia", color: Colors.deepPurpleAccent)))
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 0.0),
                      child: FutureBuilder<List<GGEvent>>(
                        future: getAllGGEvents(),
                        builder: (BuildContext ctx, AsyncSnapshot<List<GGEvent>> ggEvents) {
                          if (loadImage) {
                            return loadingEventsHeader(ctx);
                          } else {
                            if (!ggEvents.hasData) {
                              return loadingEventsHeader(ctx);
                            } else {
                              _ggEvents = ggEvents.data;

                              return new GGEventCardList(
                                ggEventList: ggEvents.data,
                                redraw_parent: () => setState(() {}),
                                //filter_list: null,
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

class search extends StatelessWidget {
  const search({
    Key key,
    this.search_function,
  }) : super(key: key);
  final void Function(String) search_function;

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
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5.0, spreadRadius: 0.0)]),
        child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: TextField(
              onChanged: (text) {
                search_function(text);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            )

            // Row(
            //   children: <Widget>[
            //     Icon(
            //       Icons.search,
            //       color: Colors.deepPurpleAccent,
            //     ),
            //     SizedBox(
            //       width: 10.0,
            //     ),
            //     Text(
            //       "Find events",
            //       style: TextStyle(fontFamily: "Sofia", fontWeight: FontWeight.w400, color: Colors.black45, fontSize: 16.0),
            //     )
            //   ],
            // ),
            ),
      ),
    );
  }
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
