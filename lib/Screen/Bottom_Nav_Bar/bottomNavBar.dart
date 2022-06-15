import 'dart:async';
import 'package:goddessGuild/Screen/B1_Home/Home.dart';
import 'package:goddessGuild/Screen/B2_Category/B2_Category.dart';
import 'package:goddessGuild/Screen/B3_Manage_Event/B3_Manage_Event.dart';
import 'package:goddessGuild/Screen/B4_Profile/B4_Profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goddessGuild/constants.dart';
import 'custom_nav_bar.dart';

class bottomNavBar extends StatefulWidget {
  String idUser;
  bottomNavBar({this.idUser});

  _bottomNavBarState createState() => _bottomNavBarState();
}

class _bottomNavBarState extends State<bottomNavBar> {
  SharedPreferences gg_prefs;
  String user_type;
  int currentIndex = 0;

  getPrefs() async{
    gg_prefs = await SharedPreferences.getInstance();
    user_type = gg_prefs.get("user_type"); // type = dancer
  }

  @override
  void initState() {
    getPrefs();

    if (user_type == USER_TYPE[0]){
      currentIndex = 0;
    }
    // USER TYPE == PATRON
    else{
      currentIndex = 1;
    }

    super.initState();
  }


  bool _color = true;
  Widget callPage(int current) {
    switch (current) {
      case 0:
        return new showCaseHome(
          user_id: widget.idUser,
        );
        break;
      case 1:
        return new Category(
          user_id: widget.idUser,
        );
        break;
      case 2:
        return new manageEvent(
          uid: widget.idUser,
        );
        break;
      case 3:
        return new profile(
          uid: widget.idUser,
        );
        break;
      default:
        return new showCaseHome(
          user_id: widget.idUser,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: callPage(currentIndex),
      bottomNavigationBar: BottomNavigationDotBar(
          // Usar -> "BottomNavigationDotBar"
          color: Colors.black26,
          items: <BottomNavigationDotBarItem>[
            BottomNavigationDotBarItem(
                icon: IconData(0xe900, fontFamily: 'home'),
                onTap: () {
                  setState(() {
                    // Hack to change what "home" is depending on who you are
                    // USER TYPE == dancer
                    if (user_type == USER_TYPE[0]){
                      currentIndex = 0;
                    }
                    // USER TYPE == PATRON
                    else{
                      currentIndex = 1;
                    }

                  });
                }),
            BottomNavigationDotBarItem(
                icon: IconData(0xe900, fontFamily: 'file'),
                onTap: () {
                  setState(() {
                    if (user_type == USER_TYPE[0]){
                      currentIndex = 1;
                    }
                    // USER TYPE == PATRON
                    else{
                      currentIndex = 0;
                    }
                  });
                }),


            BottomNavigationDotBarItem(
                icon: IconData(0xe900, fontFamily: 'hearth'),
                onTap: () {
                  setState(() {
                    currentIndex = 2;
                  });
                }),
            BottomNavigationDotBarItem(
                icon: IconData(0xe900, fontFamily: 'profile'),
                onTap: () {
                  setState(() {
                    currentIndex = 3;
                  });
                }),
          ]),
    );
  }
}
