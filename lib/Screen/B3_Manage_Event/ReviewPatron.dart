import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:goddessGuild/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goddessGuild/gg_widgets.dart';
import 'package:goddessGuild/db_service.dart';
import 'package:goddessGuild/constants.dart';
import 'package:rating_dialog/rating_dialog.dart';

///
/// Intro if user open first apps
///
class reviewPatron extends StatefulWidget {
  String event_id;

  reviewPatron({this.event_id});

  _reviewPatronState createState() => _reviewPatronState();
}

class _reviewPatronState extends State<reviewPatron> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    SharedPreferences preferences;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Review Patrons'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: FutureBuilder<List<GGUser>>(
                      future: getAllPatronsAtEvent(widget.event_id),
                      builder: ( ctx,  ggUsers) {
                        if (!ggUsers.hasData) {
                          return loadingEventsHeader(ctx);
                        } else {
                          return new ReviewPatronCardList(
                            ggUserList: ggUsers.data,
                            event_id: widget.event_id
                          );
                        }
                      },
                    )),
              ],
            ),
          ),
        ));
  }
}

class ReviewPatronCardList extends StatefulWidget {
  final List<GGUser> ggUserList;
  final String event_id;

  const ReviewPatronCardList({Key key, this.ggUserList, this.event_id}) : super(key: key);

  @override
  ReviewPatronCardListState createState() {
    return ReviewPatronCardListState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ReviewPatronCardListState extends State<ReviewPatronCardList> {
  SharedPreferences gg_prefs;

  getPrefs() async{
    gg_prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  void showRatingDialog(GGUser ggUser) {
    final _dialog = RatingDialog(
      initialRating: 1.0,
      // your app's name?
      title: Text(
        'Rate ${ggUser.name}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      message: Text(
        'Tap a star to set your rating. Add more details here if you want.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: Image.network(ggUser.profile_photo),
      submitButtonText: 'Submit',
      commentHint: 'Type more here',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, comment: ${response.comment}');

        // TODO: add your own logic
        if (response.rating < 3.0) {
          // send their comments to your email or anywhere you wish
          // ask the user to contact you instead of leaving a bad review
        } else {
          //_rateAndReviewApp();
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Rated ${ggUser.name} a ${response.rating}",
            style: TextStyle(color: Colors.white),
          ),
        ));

      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => _dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: widget.ggUserList.length,
        itemBuilder: (context, i) {
          GGUser ggUser = widget.ggUserList[i];

          return InkWell(
            onTap: () {
              // TODO:: Fix this hack
              String user_type = gg_prefs.get("user_type"); // type = dancer
              if (user_type == USER_TYPE[0]){
                return showRatingDialog(ggUser);
              }

            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: 'hero-tag-' + widget.event_id,
                    child: Material(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            image: DecorationImage(image: NetworkImage(
                              // TODO:: make sure no null imgs - change to default
                                ggUser.profile_photo), fit: BoxFit.cover),
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
                              ggUser.name,
                              style: TextStyle(fontSize: 19.0, fontFamily: "Sofia", fontWeight: FontWeight.w800),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "Rating: 4.9" ,
                              style: TextStyle(fontSize: 14.0, fontFamily: "Sofia", fontWeight: FontWeight.w400, color: Colors.black45),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "Events Attended: 1" ,
                              style: TextStyle(fontSize: 14.0, fontFamily: "Sofia", fontWeight: FontWeight.w400, color: Colors.black45),
                            ),
                            SizedBox(
                              height: 10.0,
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
