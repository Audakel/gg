import 'package:goddessGuild/Screen/B2_Category/Category_Place/L1/stripclub.dart';
import 'package:flutter/material.dart';

/**
class searchBoxEmpty extends StatefulWidget {
  String idUser;

  searchBoxEmpty({Key key, this.idUser}) : super(key: key);

  _searchBoxEmptyState createState() => _searchBoxEmptyState();
}

class _searchBoxEmptyState extends State<searchBoxEmpty>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20.0, top: 40.0),
          child: Text("Country Event",
              style: TextStyle(
                  fontFamily: "Sofia",
                  fontSize: 18.0,
                  letterSpacing: 0.9,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
          ),
          child: Container(
            height: 200.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                SizedBox(
                  width: 20.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new unitedStates(
                              user_id: widget.idUser,
                            )));
                  },
                  child: cardCountry(
                    colorTop: Color(0xFFF07DA4),
                    colorBottom: Color(0xFFF5AE87),
                    image: "assets/icon/canada.png",
                    title: "America",
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new germany(
                              user_id: widget.idUser,
                              nameAppbar: "Italy",
                            )));
                  },
                  child: cardCountry(
                      colorTop: Color(0xFF63CCD1),
                      colorBottom: Color(0xFF75E3AC),
                      image: "assets/icon/italia.png",
                      title: "Italy"),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new germany(
                              user_id: widget.idUser,
                              nameAppbar: "England",
                            )));
                  },
                  child: cardCountry(
                      colorTop: Color(0xFF9183FC),
                      colorBottom: Color(0xFFDB8EF6),
                      image: "assets/icon/england.png",
                      title: "England"),
                ),

                InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new germany(
                              user_id: widget.idUser,
                              nameAppbar: "Thailand",
                            )));
                  },
                  child: cardCountry(
                      colorTop: Color(0xFFF07DA4),
                      colorBottom: Color(0xFFF5AE87),
                      image: "assets/icon/thailand.png",
                      title: "Thailand"),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class cardCountry extends StatelessWidget {
  Color colorTop, colorBottom;
  String image, title;
  cardCountry({this.colorTop, this.colorBottom, this.title, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
      child: Container(
        height: 200.0,
        width: 130.0,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 8.0, color: Colors.black12)],
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          gradient: LinearGradient(
              colors: [colorTop, colorBottom],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white, fontFamily: "Sofia", fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    image,
                    height: 90,
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

    */