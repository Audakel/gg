import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goddessGuild/models.dart';
import 'package:shimmer/shimmer.dart';
import 'package:goddessGuild/constants.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:goddessGuild/db_service.dart';
import 'package:goddessGuild/event_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';


class whoIsDancing extends StatelessWidget {
  whoIsDancing({this.ggEvent});

  final GGEvent ggEvent;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: DancerRow(
          event_id: ggEvent.doc_id,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 135.0),
        child: Container(
          height: 40.0,
          width: 40.0,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.deepPurpleAccent, width: 1.0), borderRadius: BorderRadius.all(Radius.circular(60.0))),
          child: Center(
            child: FutureBuilder<List<QueryDocumentSnapshot>>(
                future: getAllGoddessesAtEvent(ggEvent.doc_id),
                builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot>> ggUserList) {
                  if (!ggUserList.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    return Text(
                      // TODO:: if 3 digit number it dosen't dispaly right
                      ggUserList.data.length.toString() + "/" + ggEvent.goddesses_needed.toString(),
                      style: TextStyle(fontFamily: "Popins"),
                    );
                  }
                }),
          ),
        ),
      )
    ]);
  }
}

class DancerRow extends StatelessWidget {
  const DancerRow({
    Key key,
    this.event_id,
    this.show_count: 3
  }) : super(key: key);

  final String event_id;
  final int show_count;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35.0,
        child: FutureBuilder<List<QueryDocumentSnapshot>>(
          future: getAllGoddessesAtEvent(event_id),
          builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot>> ggUserList) {
            if (!ggUserList.hasData) {
              return CircularProgressIndicator();
            } else {
              var eventDancerList = ggUserList.data;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                itemCount: eventDancerList.length > show_count ? show_count : eventDancerList.length,
                itemBuilder: (context, i) {
                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Container(
                          height: 35.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(70.0)),
                              image: DecorationImage(
                                  image: eventDancerList[i].data()['profile_photo'] == null
                                      ? AssetImage("assets/image/emptyProfilePicture.png")
                                      : NetworkImage(eventDancerList[i].data()['profile_photo']),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ));
  }
}

class GGEventCardList extends StatefulWidget {
  final List<GGEvent> ggEventList;
  final void Function() redraw_parent;
  final void Function(String) search_function;

  const GGEventCardList({Key key, this.ggEventList, this.redraw_parent, this.search_function}) : super(key: key);

  @override
  GGEventCardListState createState() {
    return GGEventCardListState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class GGEventCardListState extends State<GGEventCardList> {
  SharedPreferences gg_prefs;

  getPrefs() async{
    gg_prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: widget.ggEventList.length,
        itemBuilder: (context, i) {
          GGEvent ggEvent = widget.ggEventList[i];

          return InkWell(
            onTap: () {
              // TODO:: Fix this hack
              String user_type = gg_prefs.get("user_type"); // type = dancer
              if (user_type == USER_TYPE[0]){
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new eventListDetailGoddess(ggEvent: ggEvent, redraw_parent: widget.redraw_parent),
                    transitionDuration: Duration(milliseconds: 600),
                    transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                      return Opacity(
                        opacity: animation.value,
                        child: child,
                      );
                    }));
              }

            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: 'hero-tag-' + ggEvent.doc_id,
                    child: Material(
                      child: Container(
                        height: 390.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            image: DecorationImage(image: NetworkImage(
                                // TODO:: make sure no null imgs - change to default
                                ggEvent.image_url), fit: BoxFit.cover),
                            boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.1), spreadRadius: 0.2, blurRadius: 0.5)]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Container(
                      width: 210.0,
                      decoration: BoxDecoration(
                          color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.1), spreadRadius: 0.2, blurRadius: 0.5)]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              ggEvent.title,
                              style: TextStyle(fontSize: 19.0, fontFamily: "Sofia", fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "Zip Code: " + ggEvent.zip.toString(),
                              style: TextStyle(fontSize: 14.0, fontFamily: "Sofia", fontWeight: FontWeight.w400, color: Colors.black45),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              ggEvent.date,
                              style: TextStyle(fontSize: 14.0, fontFamily: "Sofia", fontWeight: FontWeight.w400, color: Colors.black45),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(padding: EdgeInsets.only(top: 3.0, bottom: 30.0),
                                child: whoIsDancing(ggEvent: ggEvent,)
                            ),
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

class profilePhoto extends StatelessWidget {
  final String user_id;
  final GlobalKey globalKey;

  profilePhoto({this.user_id, this.globalKey});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GGUser>(
        future: getGGUser(),
        builder: (context, ggUser) {
          if (!ggUser.hasData) {
            return new Text("Loading");
          }
          var userDocument = ggUser.data;
          return Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 9.0),
              child: InkWell(
                  onTap: () {},
                  child: Showcase(
                    key: globalKey,
                    description: "Photo Profile",
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          image: DecorationImage(
                              image: NetworkImage(userDocument.profile_photo != null ? userDocument.profile_photo : EMPTY_PROFILE),
                              fit: BoxFit.cover)),
                    ),
                  )),
            ),
          ]);
        });
  }
}

Widget loadingEventsHeader(BuildContext context) {
  return ListView.builder(
    shrinkWrap: true,
    primary: false,
    itemCount: 5,
    itemBuilder: (context, i) {
      return loadingEventCard(context);
    },
  );
}

Widget loadingEventCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0),
    child: Container(
      height: 390.0,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.grey[300],
          boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.1), spreadRadius: 0.2, blurRadius: 0.5)]),
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
                decoration: BoxDecoration(
                    color: Colors.black12, boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.1), spreadRadius: 0.2, blurRadius: 0.5)]),
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
