import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goddessGuild/Screen/B1_Home/UpdateEvent.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateEventList extends StatefulWidget {
  String userId;
  UpdateEventList({this.userId});

  @override
  _UpdateEventListState createState() => _UpdateEventListState();
}

class _UpdateEventListState extends State<UpdateEventList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          "Update Event",
          style: TextStyle(
            fontFamily: "Popins",
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
          ),
        ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Your Events Create",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: "Sofia",
                            fontSize: 17.0)),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.userId)
                          .collection('event')
                          .snapshots(),
                      builder: (BuildContext ctx,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return noItem();
                        } else {
                          if (snapshot.data.docs.isEmpty) {
                            return noItem();
                          } else {
                            return new cardDataFirestore(
                              list: snapshot.data.docs,
                              dataUser: widget.userId,
                            );

                            //  return  new noItem();
                          }
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
          String hours = list[i].data()['time'].toString();
          String date = list[i].data()['date'].toString();
          String location = list[i].data()['place'].toString();

          return InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new updateEvent(
                        category: category,
                        desc: description,
                        imageUrl: imageUrl,
                        time: hours,
                        list: list[i].id,
                        date: date,
                        place: location,
                        title: title,
                        id: id,
                        userId: dataUser,
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
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => NetworkGiffyDialog(
                                  image: Image.network(
                                    "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text('Delete Event?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Gotik",
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600)),
                                  description: Text(
                                    "Are you sure you want to delete " + title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Sofia",
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black26),
                                  ),
                                  onOkButtonPressed: () {
                                    Navigator.pop(context);

                                    FirebaseFirestore.instance
                                        .runTransaction((transaction) async {
                                      DocumentSnapshot snapshot =
                                          await transaction
                                              .get(list[i].reference);
                                      await transaction
                                          .delete(snapshot.reference);
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.remove(title);
                                    });
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Delete" + title),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    ));
                                  },
                                ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                        child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.black12,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
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
                    EdgeInsets.only(top: mediaQueryData.padding.top + 80.0)),
            Image.asset(
              "assets/image/IlustrasiCart.png",
              height: 300.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Text(
              "Not Have Event Create",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 19.5,
                  color: Colors.black26.withOpacity(0.2),
                  fontFamily: "Popins"),
            ),
          ],
        ),
      ),
    );
  }
}
