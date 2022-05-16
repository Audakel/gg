import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class eventDetailFavorite extends StatefulWidget {
  final String title,
      user_id,
      category,
      image_url,
      description,
      price,
      time,
      date,
      place,
      id,
      description2,
      description3;
  final index;

  eventDetailFavorite(
      {this.id,
      this.category,
      this.description,
      this.place,
      this.image_url,
      this.index,
      this.time,
      this.date,
      this.title,
      this.user_id,
      this.description2,
      this.description3,
      this.price});

  @override
  _eventDetailFavoriteState createState() => _eventDetailFavoriteState();
}

class _eventDetailFavoriteState extends State<eventDetailFavorite> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            /// Appbar Custom using a SliverAppBar

            SliverPersistentHeader(
              delegate: MySliverAppBar(
                  expandedHeight: _height - 40.0,
                  img: widget.image_url,
                  title: widget.title,
                  id: widget.id),
              pinned: true,
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
                          fontWeight: FontWeight.w400,
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
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("JoinEvent")
                            .doc("user")
                            .collection(widget.title)
                            .snapshots(),
                        builder: (BuildContext ctx,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
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
                ])),
          ],
        ),
      ),
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
                  String _img = list[i].data()['profile_photo'].toString();

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
          padding: const EdgeInsets.only(top: 6.0, left: 135.0),
          child: Text(
            list.length.toString() + " People Joined",
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

  MySliverAppBar(
      {@required this.expandedHeight, this.img, this.title, this.id});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
            tag: 'hero-tag-list-${id}',
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
                  gradient: LinearGradient(
                      colors: <Color>[
                        new Color(0x00FFFFFF),
                        new Color(0xFFFFFFFF),
                      ],
                      stops: [
                        0.0,
                        1.0
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.0, 1.0)),
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
                  "Event",
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
