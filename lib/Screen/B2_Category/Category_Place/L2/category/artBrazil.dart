import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goddessGuild/Screen/B1_Home/Detail_Event.dart';
import 'package:goddessGuild/Screen/B2_Category/Page_Transformer_Card/page_transformer.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class artBrazil extends StatefulWidget {
  String idUser;
  artBrazil({this.idUser});

  _artBrazilState createState() => _artBrazilState();
}

class _artBrazilState extends State<artBrazil> {
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
    Timer(Duration(seconds: 3), () {
      setState(() {
        loadImage = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 0.0),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("event")
                          .where('country', isEqualTo: 'brazil')
                          .where('category', isEqualTo: 'art')
                          .snapshots(),
                      builder: (BuildContext ctx,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (loadImage) {
                          return _loadingDataHeader(ctx);
                        } else {
                          if (!snapshot.hasData) {
                            return _loadingDataHeader(ctx);
                          } else {
                            return new dataFirestore(
                              list: snapshot.data.docs,
                              dataUser: widget.idUser,
                            );
                          }
                        }
                      },
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

///
///
/// Calling imageLoading animation for set a grid layout
///
///
Widget _loadingDataHeader(BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  return SizedBox.fromSize(
    size: Size.fromHeight(_height / 1.3),
    child: PageTransformer(
      pageViewBuilder: (context, visibilityResolver) {
        return PageView.builder(
          controller: PageController(viewportFraction: 0.87),
          itemCount: 5,
          itemBuilder: (context, index) {
            return cardHeaderLoading(context);
          },
        );
      },
    ),
  );
}

Widget cardHeaderLoading(BuildContext context) {
  double _height = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: _height / 1.3,
      width: 275.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.grey[500],
          boxShadow: [
            BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                spreadRadius: 0.2,
                blurRadius: 0.5)
          ]),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[400],
        highlightColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 320.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 17.0,
                width: 70.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                height: 20.0,
                width: 150.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 20.0,
                width: 250.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 20.0,
                width: 150.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
        ),
      ),
    ),
  );
}

class dataFirestore extends StatelessWidget {
  String dataUser;
  dataFirestore({this.list, this.dataUser});
  final List<DocumentSnapshot> list;
  PageVisibility pageVisibility;

  Widget _applyTextEffects({
    @required double translationFactor,
    @required Widget child,
  }) {
    final double xTranslation = pageVisibility.pagePosition * translationFactor;

    return Opacity(
      opacity: pageVisibility.visibleFraction,
      child: Transform(
        alignment: FractionalOffset.topLeft,
        transform: Matrix4.translationValues(
          xTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
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
      size: Size.fromHeight(_height / 1.3),
      child: PageTransformer(
        pageViewBuilder: (context, visibilityResolver) {
          return PageView.builder(
            controller: PageController(viewportFraction: 0.86),
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

              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Hero(
                  tag: 'hero-tag-$id',
                  child: Material(
                    child: Container(
                      height: 500.0,
                      width: 275.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          color: Colors.grey[500],
                          image: DecorationImage(
                              image: NetworkImage(imageUrl), fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12.withOpacity(0.1),
                                spreadRadius: 0.2,
                                blurRadius: 0.5)
                          ]),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          gradient: LinearGradient(
                            begin: FractionalOffset.bottomCenter,
                            end: FractionalOffset.topCenter,
                            colors: [
                              const Color(0xFF000000),
                              const Color(0x00000000),
                            ],
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      new newsHeaderListDetail(
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
                                  transitionDuration:
                                      Duration(milliseconds: 600),
                                  transitionsBuilder: (_,
                                      Animation<double> animation,
                                      __,
                                      Widget child) {
                                    return Opacity(
                                      opacity: animation.value,
                                      child: child,
                                    );
                                  }),
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              // image,
                              imageOverlayGradient,

                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 20.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          date,
                                          style: textTheme.caption.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2.0,
                                            fontSize: 14.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: Text(
                                            title,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
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
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
