import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:goddessGuild/models.dart';
import 'package:goddessGuild/db_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const GODDESSING = <String>[
  "Goddess-ing!", // T
  "I want to Goddess" // F
];

// class GGEvent
class eventListDetail extends StatefulWidget {
  final GGEvent ggEvent;
  final uid;

  eventListDetail({this.ggEvent, this.uid});

  _eventListDetailState createState() => _eventListDetailState();
}

class _eventListDetailState extends State<eventListDetail> {
  String goddessStatus = GODDESSING[1];

  void checkEventStatus() async{
    bool withEvent = await isGoddessWithEvent(widget.ggEvent.doc_id);
    if (withEvent) {
      goddessStatus = GODDESSING[0];
    }
    else {
      goddessStatus = GODDESSING[1];
    }
    setState((){});
  }

  @override
  void initState() {
    checkEventStatus();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery
        .of(context)
        .size
        .height;
    bool isLoading = false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverPersistentHeader(
                  delegate: MySliverAppBar(
                    expandedHeight: _height / 3,
                    img: widget.ggEvent.image_url,
                    title: " "
                  ),
                  pinned: true,
                ),
                SliverToBoxAdapter(
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 30.0, left: 20.0),
                        child: Text(
                          widget.ggEvent.title,
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, letterSpacing: 1.5, fontFamily: "Popins"),
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
                                    widget.ggEvent.date,
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: "Popins"),
                                  ),
                                  Text(
                                    widget.ggEvent.time_start
                                        + " - "
                                        + widget.ggEvent.time_end,
                                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black54),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 25.0, right: 30.0),
                        child: Divider(
                          color: Colors.black12,
                          height: 2.0,
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
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: "Popins"),
                                  ),
                                  Text(
                                    widget.ggEvent.address,
                                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black54),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 25.0, right: 30.0),
                        child: Divider(
                          color: Colors.black12,
                          height: 2.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.accessibility_new,
                              color: Colors.black26,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Patrons Expected",
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: "Popins"),
                                  ),
                                  Text(
                                    widget.ggEvent.guests_expected.toString(),
                                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black54),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 25.0, right: 30.0),
                        child: Divider(
                          color: Colors.black12,
                          height: 2.0,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection("JoinEvent").doc("user").collection(widget.ggEvent.title).snapshots(),
                            builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              } else {
                                return new joinEvent(list: snapshot.data.docs);
                              }
                            },
                          )),
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
                          style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: "Popins"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
                        child: Text(
                          widget.ggEvent.desc1,
                          style: TextStyle(fontFamily: "Popins", color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400),
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
                  widget.ggEvent.price.toString(),
                  style: TextStyle(color: Colors.black54, fontSize: 19.0, fontFamily: "Popins"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: isLoading
                    ? Container(
                    width: ScreenUtil.getInstance().setWidth(330),
                    height: ScreenUtil.getInstance().setHeight(100),
                    child:
                    SpinKitPumpingHeart(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? Color(0xFFD898F8) : Color(0xFF8189EC),
                          ),
                        );
                      },
                    )
                )
                    : InkWell(
                        onTap: () async {
                          setState(() {isLoading = true;});
                          bool withEvent = await isGoddessWithEvent(widget.ggEvent.doc_id);

                          if (withEvent) {
                            goddessStatus = "I want to Goddess";
                            await deleteGoddessFromEvent(widget.ggEvent.doc_id);
                          }
                          else {
                            goddessStatus = "Goddess-ing!";
                            await addGoddessToEvent(widget.ggEvent.doc_id);
                          }
                          setState(() {isLoading = false;});
                        },
                    child: Container(
                      height: 50.0,
                      width: 180.0,
                      decoration: BoxDecoration(
                          color: (goddessStatus == GODDESSING[0]) ? Colors.purpleAccent : Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.all(Radius.circular(40.0))),
                      child: Center(
                        child: Text(goddessStatus,
                          style: TextStyle(fontFamily: "Popins", color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
              ),
            ],
        ),
      ),
    ),]
    ,
    )
    ,
    )
    ,
    );
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
                  String _title = list[i].data()['nama'].toString();
                  String _uid = list[i].data()['uid'].toString();
                  String _img = list[i].data()['profile_photo'].toString();

                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Container(
                          height: 35.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(70.0)),
                              image: DecorationImage(image: NetworkImage(_img), fit: BoxFit.cover)),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0, left: 135.0),
          child: Text(
            list.length.toString() + " People Join",
            style: TextStyle(fontFamily: "Popins"),
          ),
        )
      ],
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  String img, title, id;

  MySliverAppBar({@required this.expandedHeight, this.img, this.title, this.id});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.clip,
      children: [
        Container(
          height: 50.0,
          width: double.infinity,
          color: Colors.white,
        ),
        Opacity(
          opacity: (1 - shrinkOffset / expandedHeight),
          child: Hero(
            transitionOnUserGestures: true,
            tag: 'hero-tag-${id}',
            child: new DecoratedBox(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: new NetworkImage(img),
                ),
                shape: BoxShape.rectangle,
              ),
              child: Container(
                margin: EdgeInsets.only(top: 130.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                    new Color(0x00FFFFFF),
                    new Color(0xFFFFFFFF),
                  ], stops: [
                    0.0,
                    1.0
                  ], begin: FractionalOffset(0.0, 0.0), end: FractionalOffset(0.0, 1.0)),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                      child: Icon(Icons.arrow_back),
                    ))),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 250.0,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 25.0,
            )
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
